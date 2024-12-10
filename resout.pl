:- module(resout, [resout/4]).
:- use_module([substitution]).

resout(R, X = T, S1, S2):-
	member(R, [rename, simplify, expand]),
	substitution(X, T, S1, S),
    append(S, [X = T], S2).

resout(R, _, S1, S1):-
    member(R, [decompose, orient]).

resout(R, _, _, bottom):-
	member(R, [check, clash]).