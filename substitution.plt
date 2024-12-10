:- use_module([substitution]).

:- begin_tests(substitution).

% Test 1 : Substitution simple

test(simple_substitution) :-
	substitution(x, y, x + 1, R),
	assertion(R == y + 1).

% Test 2 : Aucune substitution

test(no_substitution) :-
	substitution(x, y, 1 + 1, R),
	assertion(R == 1 + 1).

% Test 3 : Substitution multiple

test(multiple_occurrences) :-
	substitution(x, y, x + x, R),
	assertion(R == y + y).

% Test 4 : Terme non présent dans le terme

test(term_not_in_term) :-
	substitution(z, y, 1 + 1, R),
	assertion(R == 1 + 1).

% Test 5 : Substitution dans un terme imbriqué

test(nested_term_substitution) :-
	substitution(x,
		y,
		1 + (x - 2),
		R),
	assertion(R == 1 + (y - 2)).

% Test 6 : Substitution dans une liste

test(list_substitution) :-
	substitution(x, y, [x, 2, x], R),
	assertion(R == [y, 2, y]).

% Test 7 : Substitution dans une structure complexe

test(complex_structure) :-
	substitution(x,
		y,
		f(a,
			x,
			g(x, b)),
		R),
	assertion(R == f(a,
			y,
			g(y, b))).

% Test 8 : Substitution avec le même terme

test(same_term) :-
	substitution(x, x, x + 1, R),
	assertion(R == x + 1).

% Test 9 : Substitution dans un terme avec des termes différents

test(different_variables) :-
	substitution(x, y, a + b + x + z, R),
	assertion(R == a + b + y + z).

% Test 10 : Substitution avec un terme vide

test(empty_term) :-
	substitution(x, y, [], R),
	assertion(R == []).

% Test 11 : Substitution dans un terme avec plusieurs types de données

test(mixed_data_types) :-
	substitution(x,
		y,
		[x, f(x), 3.14],
		R),
	assertion(R == [y, f(y), 3.14]).

% Test 12 : Substitution variable en entrée par un terme simple

test(simple_term_simple_variable_substitution) :-
	substitution(X, a, X, Res),
	assertion(Res == a).

% Test 13 : Substitution variable en entrée par terme complexe

test(complex_term_simple_variable_substitution) :-
	substitution(X,
		f(a, b, c),
		X,
		Res),
	assertion(Res == f(a, b, c)).

% Test 14 : Substitution terme complexe avec variable en entrée par un terme simple

test(simple_term_complex_variable_substitution) :-
	substitution(f(X, Y),
		a,
		k(f(X, Y),
			c),
		Res),
	assertion(Res == k(a, c)).

% Test 15 : Substitution terme complexe avec variable en entrée par un terme complexe

test(complex_term_complex_variable_substitution) :-
	substitution(f(X, Y),
		g(a, b, c),
		k(f(X, Y),
			c),
		Res),
	assertion(Res == k(g(a, b, c),
			c)).

% Test 16 : Substitution terme simple avec variable en entrée par un terme simple terme vide

test(simple_term_simple_variable_empty_term_substitution) :-
	substitution(X, a, [], Res),
	assertion(Res == []).

% Test 17 : Substitution terme complexe avec variable en entrée par un terme simple terme vide

test(simple_term_simple_variable_empty_term_substitution) :-
	substitution(f(X),
		a,
		[],
		Res),
	assertion(Res == []).

% Test 18 : Substitution terme complexe avec variable en entrée par un terme complexe terme vide

test(simple_term_simple_variable_empty_term_substitution) :-
	substitution(f(X),
		g(a, d),
		[],
		Res),
	assertion(Res == []).

% Test 19 : Substitution impossible car Res déjà set

test(impossible_substitution, [fail]) :-
	substitution(f(X),
		g(a, d),
		d(f(X),
			a),
		f(a)).

:- end_tests(substitution).