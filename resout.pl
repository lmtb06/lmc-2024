:- module(resout, [resout/4]).
:- use_module([substitution]).


% Vérifie que R soit l'une des règles suivantes : rename, simplify, expand
% On applique la substitution et on garde l'équation de base
resout(R, X = T, S1, S2):-
	member(R, [rename, simplify, expand]),
	substitution(X, T, S1, S),
    append(S, [X = T], S2).


% On vérifie que R soit l'une des règles suivantes : decompose, orient.
% Il n'y a rien à faire pour ces règles 
resout(R, _, S1, S1):-
    member(R, [decompose, orient]).


% On vérifie que R soit l'une des règles suivantes : check, clash.
% Si c'est le cas on produit bottom.
resout(R, _, _, bottom):-
	member(R, [check, clash]).