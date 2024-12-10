:- module(strategies,[choix_premier/4,choix_premier_largeur/4]).
:- use_module([reduit, regle]).

extraction_gauche(E, L, N):-
	append([E], N, L).

extraction_droite(E,L,N):-
	append(N, [E], L).

choix_premier(P, Q, E, R):-
	extraction_gauche(E, P, P1),
	regle(E, R),
	reduit(R, E, P1, Q).

choix_premier_largeur(P, Q, E, R):-
	extraction_droite(E, P, P1),
	regle(E, R),
	reduit(R, E, P1, Q).