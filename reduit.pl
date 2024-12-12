:- module(reduit, [reduit/4]).
:- use_module([code_fourni,substitution]).


% Cas d'arrêt listes vide.
decompose_rec([], [], []). 


% decompose_rec on a 3 listes :
%	[H1|RS] celle de la première équation
%	[H2|R2S] celle de la deuxième équation
% et Q contenant la liste l'équation entre H1 et H2 et le reste. 
% On appel ensuite récursivement sur le reste des listes
% Permet de créer les nouvelles équations entre deux termes décomposés.
decompose_rec([H1|RS], [H2|R2S], [H1?=H2|Q]) :-
	decompose_rec(RS, R2S, Q).


% Réduit de rename, de simplify et d'expand ont le même comportement.
% On substitue toutes les occurences de X par T
% Pour faire cela il faut que R soit l'une des trois règles.
reduit(R, X?=T, P, Q) :-
	member(R, [rename,simplify,expand]),	
	substitution(X, T, P, Q).


% Réduit d'orient inverse juste le sens d'une équation
% T?=X devient X?+T et on ajoute ça aux restes des équations pour former Q
reduit(orient, T?=X, P, Q) :-
	append([X ?= T], P, Q).


% Réduit de décompose
% On décompose C1 et C2 et on garde leurs arguments.
% On applique ensuite la règle décompose_rec qui permet de créer les nouvelles équations
% on ajoute les nouvelles équations au système pour former Q.
reduit(decompose, C1?=C2, P, P) :-
	atomic(C1).

reduit(decompose, C1?=C2, P, Q) :-
	C1 =.. [_|Args1],
	C2 =.. [_|Args2],
	decompose_rec(Args1, Args2, Q2),
	append(Q2, P, Q).


% Aucune réduction possible pour les règles check et clash.
% On vérifie que R est soit check soit clash
reduit(R, _, _, _):-
	member(R, [check,clash]).