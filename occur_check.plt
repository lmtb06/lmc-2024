:- use_module([occur_check]).

:- begin_tests(occur_check).

% Test 1 : Succés (terme simple)

test(success_simple_term) :-
	occur_check(X,s).

% Test 2 : Succés (terme composé)

test(success_complex_term) :-
	occur_check(X,f(Z,s)).

% Test 3 : Echec (V n'est pas une variable)

test(fail_V_not_variable, [fail]) :-
	occur_check(z,f(Z,s)).

% Test 4 : Echec de l'occur check (terme simple)

test(fail_simple_term, [fail]) :-
	occur_check(X,X).

% Test 5 : Echec de l'occur check (terme composé)

test(fail_complex_term, [fail]) :-
	occur_check(X,f(X,s)).

% Test 6 : Echec de l'occur check (terme composé imbriqué)

test(fail_nested_complex_term, [fail]) :-
	occur_check(X,f(g(X),s)).

:- end_tests(occur_check).