:- module(reduit, [reduit/4]).
:- use_module([code_fourni,substitution]).

% Question 1, c) 
% =================================================================================================================

% decompose_rec condition d'arrêt

decompose_rec([], [], []). 

% decompose_rec on a 3 listes. [H1|RS] celle de la première équation. [H2|R2S] celle de la deuxième équation
% et Q contenant la liste l'équation entre H1 et H2 et le reste. On appel ensuite récursivement sur le reste des listes

decompose_rec([H1|RS], [H2|R2S], [H1?=H2|Q]) :-
	decompose_rec(RS, R2S, Q).

% Réduit pour rename, simplify, et expand vu qu'ils ont les même effets, pour eviter de dupliquer
reduit(R, X?=T, P, Q) :-
	member(R, [rename,simplify,expand]),	
	substitution(X, T, P, Q).

% 
reduit(orient, T?=X, P, Q) :-
	append([X ?= T], P, Q).

reduit(decompose, C1?=C2, P, Q) :-
	C1 =.. [_|Args1],
	C2 =.. [_|Args2],
	decompose_rec(Args1, Args2, Q2),
	append(Q2, P, Q).

reduit(R, _, _, _):-
	member(R, [check,clash]).