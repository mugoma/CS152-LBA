%  Tell prolog that known/3 and multivalued/1 will be added later
:- dynamic known/3, multivalued/1.

% Enter your KB below this line:

cafe('Cafe Buena Vida') :- noise(quiet), neighborhood(mission), price('$$'), ownership(local), least_busy(morning), dietary_preference(vegan), rating(4.6), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Diamond Coffee N’ Pastry') :- noise(moderate), neighborhood(outer_sunset), price('$$'), ownership(local), least_busy(morning), dietary_preference(none), rating(4.6), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Beluna Cafe') :- noise(quiet), neighborhood(lower_haight), price('$'), ownership(local), least_busy(morning), dietary_preference(none), rating(4.9), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Delah Coffee') :- noise(moderate), neighborhood(soma), price('$'), ownership(local), least_busy(evening), dietary_preference(none), rating(4.7), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Home Coffee Roasters') :- noise(moderate), neighborhood(outer_sunset), price('$$'), ownership(chain), least_busy(morning), dietary_preference(none), rating(4.6), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('The Social Study') :- noise(noisy), neighborhood(western_addition), price('$$'), ownership(local), least_busy(evening), dietary_preference(vegetarian), rating(4.5), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Cafe Réveille') :- noise(quiet), neighborhood(lower_haight), price('$$'), ownership(chain), least_busy(morning), dietary_preference(vegetarian), rating(4.3), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Mercury Cafe') :- noise(quiet), neighborhood(hayes_valley), price('$'), ownership(local), least_busy(morning), dietary_preference(vegetarian), rating(4.3), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Java Beach Cafe') :- noise(noisy), neighborhood(outer_sunset), price('$'), ownership(local), least_busy(morning), dietary_preference(none), rating(4.4), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Progressive Grounds') :- noise(quiet), neighborhood(bernal_heights), price('$'), ownership(local), least_busy(morning), dietary_preference(vegetarian), rating(4.5), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Le Café du Soleil') :- noise(quiet), neighborhood(lower_haight), price('$$'), ownership(local), least_busy(morning), dietary_preference(vegetarian), rating(4.5), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Cafe La Flore') :- noise(quiet), neighborhood(inner_sunset), price('$$'), ownership(local), least_busy(morning), dietary_preference(vegetarian), rating(4.6), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Cafe International') :- noise(moderate), neighborhood(lower_haight), price('$'), ownership(local), least_busy(morning), dietary_preference(vegetarian), rating(4.5), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Fiddle Fig Cafe') :- noise(moderate), neighborhood(russian_hill), price('$$'), ownership(local), least_busy(morning), dietary_preference(none), rating(4.6), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Ocean Beach Cafe') :- noise(noisy), neighborhood(outer_richmond), price('$$'), ownership(local), least_busy(morning), dietary_preference(none), rating(4.7), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Royal Ground Coffee') :- noise(noisy), neighborhood(nob_hill), price('$'), ownership(chain), least_busy(morning), dietary_preference(none), rating(4.4), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Manny’s') :- noise(quiet), neighborhood(mission), price('$$'), ownership(local), least_busy(morning), dietary_preference(vegetarian), rating(4.5), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Simple Pleasures Cafe') :- noise(quiet), neighborhood(outer_richmond), price('$$'), ownership(local), least_busy(morning), dietary_preference(none), rating(4.6), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Philz Coffee Mission') :- noise(noisy), neighborhood(mission), price('$$'), ownership(chain), least_busy(morning), dietary_preference(none), rating(4.5), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Equator Coffees Presidio') :- noise(moderate), neighborhood(presidio), price('$$'), ownership(chain), least_busy(morning), dietary_preference(none), rating(3.9), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Blue Bottle Hayes Valley') :- noise(quiet), neighborhood(hayes_valley), price('$$'), ownership(chain), least_busy(morning), dietary_preference(gluten_free), rating(4.6), has_wifi(yes), \+has_plugs(yes), is_lgbt_friendly(yes).
cafe('Saint Frank Coffee Russian Hill') :- noise(quiet), neighborhood(russian_hill), price('$$'), ownership(chain), least_busy(morning), dietary_preference(none), rating(4.5), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Sightglass Coffee') :- noise(quiet), neighborhood(mission), price('$$'), ownership(local), least_busy(morning), dietary_preference(none), rating(4.5), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Andytown Coffee Roasters') :- noise(quiet), neighborhood(outer_sunset), price('$$'), ownership(chain), least_busy(morning), dietary_preference(none), rating(4.6), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).
cafe('Ritual Coffee Roasters') :- noise(moderate), neighborhood(hayes_valley), price('$$'), ownership(local), least_busy(morning), dietary_preference(none), rating(4.5), has_wifi(yes), has_plugs(yes), is_lgbt_friendly(yes).


% The code below implements the prompting to ask the user:

noise(X) :- ask(noise, X, 'Is your preferred noise level: {0} ?').
neighborhood(X) :- ask(neighborhood, X, 'Do you want a cafe in "{0}" neighborhood?').
price(X) :- ask(price, X, 'Do you prefer a cafe that has {0} price rating on Google Maps?').
ownership(X) :- ask(ownership, X, 'Do you prefer a cafe that is {0} owned?').
least_busy(X) :- ask(least_busy, X, 'Do you prefer going to the cafe when it is least busy in the {0}?').
dietary_preference(X) :- ask(dietary_preference, X, 'Do you want a cafe that caters to this dietary restriction:{0}?').
rating(X) :- ask(rating, X, 'Is the following rating good enough {0}?').
has_wifi(X) :- ask(has_wifi, X, 'Do you want a cafe that responded "{0}" to having Wifi?').
has_plugs(X) :- ask(has_plugs, X, 'Do you want a cafe that responded "{0}" to having plugs?').
is_lgbt_friendly(X) :- ask(is_lgbt_friendly, X, 'Do you want a cafe that responded "{0}" to  being LGBT-friendly:').


% Asking clauses

ask(A, V, _):-
known(yes, A, V), % succeed if true
!.	% stop looking

ask(A, V, _):-
known(_, A, V), % fail if false
!, fail.

% If not multivalued, and already known to be something else, don't ask again for a different value.
ask(A, V, _):-
\+multivalued(A),
known(yes, A, V2),
V \== V2,
!, fail.

ask(A, V, P):-
get_user_response(A,V,Y,P), % get the answer
assertz(known(Y, A, V)), % remember it
Y == yes.	% succeed or fail