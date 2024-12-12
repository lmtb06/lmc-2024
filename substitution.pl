:- module(substitution,[substitution/4]).

% Substitution de X par T dans S, S correspond à X. R est le résultat
substitution(X, T, S, T):-
	S == X,
	!.


% Substitution de X par T dans S, R est le résultat. Décomposition de S
% Si S est composé alors on le décompose en récupérant son nom et ses arguments
% On applique la substitution X T à tout les arguments de la liste ArgsS
% On produit la liste ArgsR
% On construit à la fin un nouveau terme R qui à le même nom que S et la liste des substitutions
% comme arguments
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