:- module(occur_check, [occur_check/2]).

% Cas où V est une variable est que T n'est pas composé.
% On vérifie juste que V est différent de T
occur_check(V, T):-
	var(V),
	\+compound(T),!,
	V \== T.


% Cas où V est une variable est que T est composé.
% On récupère les arguments de T sous la forme d'une liste. 
% maplist permet d'appliquer la règle occur_check aux arguments de T.
% Ca permet de vérifier récursivement que V ne se trouve pas dans un des arguments de T.
occur_check(V, T):-
	var(V),
	compound(T),!,	
	T =.. [_|Args],
    maplist(occur_check(V), Args).