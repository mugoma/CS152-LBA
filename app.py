# create a flask app
from flask import Flask, request, session, render_template
from flask_cors import CORS
from pyswip.prolog import Prolog
from pyswip.easy import *

from flask_socketio import SocketIO, emit, join_room
import threading
import uuid

# TODO: Refactor/clean up the code

# Initialize Flask app
app = Flask(__name__, template_folder=".")
socketio = SocketIO(app, cors_allowed_origins="*")
# Enable CORS for all routes
CORS(app)

import pyswip, ctypes

class PrologMT(pyswip.Prolog):
    """Multi-threaded (one-to-one) pyswip.Prolog ad-hoc reimpl"""
    _swipl = pyswip.core._lib

    PL_thread_self = _swipl.PL_thread_self
    PL_thread_self.restype = ctypes.c_int

    PL_thread_attach_engine = _swipl.PL_thread_attach_engine
    PL_thread_attach_engine.argtypes = [ctypes.c_void_p]
    PL_thread_attach_engine.restype = ctypes.c_int

    @classmethod
    def _init_prolog_thread(cls):
        pengine_id = cls.PL_thread_self()
        if (pengine_id == -1):
            pengine_id = cls.PL_thread_attach_engine(None)
            print("{INFO} attach pengine to thread: %d" % pengine_id)
        if (pengine_id == -1):
            raise pyswip.prolog.PrologError("Unable to attach new Prolog engine to the thread")
        elif (pengine_id == -2):
            print("{WARN} Single-threaded swipl build, beware!")

    class _QueryWrapper(pyswip.Prolog._QueryWrapper):
        def __call__(self, *args, **kwargs):
            PrologMT._init_prolog_thread()
            return super().__call__(*args, **kwargs)

prolog = PrologMT()  # Global handle to interpreter

retractall = Functor("retractall")
known = Functor("known", 3)

# Global dict to store pending input requests
pending_inputs = {}


def get_user_response(A, V, Y, P: str):
    if isinstance(Y, Variable):
        req_id = str(uuid.uuid4())
        event = threading.Event()
        pending_inputs[req_id] = {"event": event, "answer": None, "sid": request.sid}
        # Emit a SocketIO event to the frontend (from the main thread), only to the current user
        socketio.emit("input_request", {"question": str(P).format(V), "req_id": req_id, "sid": request.sid}, to=request.sid)
        # Wait for the answer to be set by the handler
        event.wait()
        answer = pending_inputs[req_id]["answer"]
        del pending_inputs[req_id]
        Y.unify(Atom(answer))
        return True
    else:
        return False


get_user_response.arity = 4

registerForeign(get_user_response)


# Define routes
@app.route("/")
def index():
    return render_template("chatbot.html")


@socketio.on("connect")
def handle_connect():
    print("Client connected via WebSocket")
    # Optionally, join a room for this sid
    # join_room(request.sid)


@socketio.on("start")
def handle_start():
    try:
        # Check if session is new.If not, terminate the existing prolog thread
        if session.get("prolog_thread"):
            session["prolog_thread"] = ''

        # session["prolog_thread"] = threading.Thread(target=prolog_thread)

        print("Starting Session")
        prolog.consult("cafe_recommender.pl", relative_to=__file__)
        # prolog.consult("expert_system.pl", relative_to=__file__)
        call(retractall(known))
        query = prolog.query("cafe(X).", maxresult=1)
        # query = prolog.query("problem(X).", maxresult=1)

        problem = next(query)
    except Exception as e:
        print(f"Error: {e}")
        problem = None
    if problem:
        response = f"Recommended cafe is {problem['X']}"
    else:
        response = "No cafe identified."
    emit("final_problem", {"problem": response}, to=request.sid)
    print("Ending Session")


@socketio.on("disconnect")
def handle_disconnect():
    print("Client disconnected")


# SocketIO handler for user input
@socketio.on("user_input")
def handle_user_input(data):
    req_id = data.get("req_id")
    answer = data.get("answer")
    if req_id in pending_inputs:
        pending_inputs[req_id]["answer"] = answer
        pending_inputs[req_id]["event"].set()


if __name__ == "__main__":
    socketio.run(app, debug=True)
