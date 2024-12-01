:- module(substitution,[substitution/4]).

% Substitution de X par T dans S, S correspond à X. R est le résultat

substitution(X, T, S, T):-
	S == X,
	!.

% Substitution de X par T dans S, R est le résultat. Décomposition de S

substitution(X, T, S, R):-
	compound(S),
	!,
	var(R),
	compound_name_arguments(S, Nom, ArgsS),
	maplist(substitution(X, T),
		ArgsS,
		ArgsR),
	compound_name_arguments(R, Nom, ArgsR).

% Substitution de X par T dans S, cas X non présent dans S

substitution(_, _, S, S).

% TODO: Améliorer perfs (avec green cuts) et mieux faire les régles