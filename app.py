# create a flask app
from pathlib import Path
from flask import Blueprint, Flask, request, jsonify, render_template
from flask_sockets import Sockets
from flask_cors import CORS
from pyswip.prolog import Prolog
from pyswip.easy import *

import sys
from flask_socketio import SocketIO, emit
import threading
import uuid

#TODO: Refactor/clean up the code 

# socketio = SocketIO()
# bp = Blueprint("index", __name__,template_folder='.')

# def create_app():
#     app = Flask(__name__)
#     app.register_blueprint(bp)
#     socketio.init_app(app)
#     return app

# Initialize Flask app
app = Flask(__name__, template_folder=".")
socketio = SocketIO(app, cors_allowed_origins="*")
# Enable CORS for all routes
CORS(app)


from pyswip.prolog import Prolog
from pyswip.easy import *

prolog = Prolog()  # Global handle to interpreter

retractall = Functor("retractall")
known = Functor("known", 3)

# Global dict to store pending input requests
pending_inputs = {}


# Define foreign functions for getting user input and writing to the screen
def write_py(X):
    print(str(X))
    sys.stdout.flush()
    return True


def read_py(A, V, Y):
    if isinstance(Y, Variable):
        req_id = str(uuid.uuid4())
        event = threading.Event()
        pending_inputs[req_id] = {"event": event, "answer": None}
        # Emit a SocketIO event to the frontend (from the main thread)
        socketio.emit("input_request", {"question": f"{A} is {V}?", "req_id": req_id})
        # Wait for the answer to be set by the handler
        event.wait()
        answer = pending_inputs[req_id]["answer"]
        del pending_inputs[req_id]
        Y.unify(Atom(answer))
        return True
    else:
        return False


write_py.arity = 1
read_py.arity = 3

registerForeign(read_py)
registerForeign(write_py)


# Define routes
@app.route("/")
def index():
    return render_template("chatbot.html")


@socketio.on("connect")
def handle_connect():
    print("Client connected via WebSocket")


@socketio.on("start")
def handle_start():
    print("Starting Session")
    prolog.consult("expert_system.pl", relative_to=__file__)
    call(retractall(known))
    query = prolog.query("problem(X).", maxresult=1)
    try:
        problem = next(query)
    except Exception as e:
        print(f"Error: {e}")
        problem = None
    if problem:
        response = f"Problem is {problem["X"]}"
    else:
        response = "No problem identified."
    emit("final_problem", {"problem": response})
    print("Ending Session")


@socketio.on("disconnect")
def handle_disconnect():
    print("Client disconnected")

# TODO: Remove function
@socketio.on("message")
def handle_message(message):
    call(retractall(known))
    # Process the message and generate a response
    problem = prolog.query(message, maxresult=1)
    # problem = [s for s in prolog.query("problem(X).", maxresult=1)]
    next_query = next(problem)
    if next_query:
        response = next_query
    else:
        response = "No problem identified."
    emit("response", response)


# SocketIO handler for user input
@socketio.on("user_input")
def handle_user_input(data):
    req_id = data.get("req_id")
    answer = data.get("answer")
    if req_id in pending_inputs:
        pending_inputs[req_id]["answer"] = answer
        pending_inputs[req_id]["event"].set()


if __name__ == "__main__":
    # socketio.run(app, host
    socketio.run(app, debug=True)
