:- module(regle, [regle/2]).
:- use_module([code_fourni,occur_check]).

% regle(E,R) : détermine la règle de transformation R qui s’applique à l’équation E
% =================================================================================================================


% Regle rename : renvoie vrai si T est une variable.

regle(X?=T, rename) :-
	var(X),
	var(T),!.


% Regle simplify : renvoie vrai si T est une constante.

regle(X?=T, simplify) :-
	var(X),
	atomic(T),!.


% Regle expand : renvoie vrai si T est composé et que X (X variable) n'est pas dans T.

regle(X?=T, expand) :-
	var(X),
	compound(T),
	occur_check(X, T),!.


% Regle check : renvoie vrai si X différent de T et que le test d'occurence ne passe pas

regle(X?=T, check) :-
	var(X),
	not(X == T),
	not(occur_check(X, T)),!.


% Regle orient: renvoie vrai si X est une variable et que T n'est pas une variable.

regle(T?=X, orient) :-
	var(X),
	nonvar(T),!.


% Regle decompose : renvoie vrai si C1 et C2 sont composés et qu'ils ont les même symbole et arité.

regle(C1?=C2, decompose) :-
	atom(C1),
	atom(C2), C1 == C2.

regle(C1?=C2, decompose) :-
	compound(C1),
	compound(C2),
	functor(C1, Nom, Arite),
	functor(C2, Nom, Arite),!.


% Regle clash : renvoie vrai si C1 et C2 sont composés mais qu'ils n'ont pas les même symbole ou arité.

regle(C1?=C2, clash) :-
	atom(C1),
	atom(C2), C1 \== C2.

regle(C1?=C2, clash) :-
	compound(C1),
	compound(C2),
	functor(C1, Nom1, Arite1),
	functor(C2, Nom2, Arite2),
	 \+ ((Nom1 == Nom2, Arite1 == Arite2)).
