:- use_module([code_fourni, regle, reduit, substitution, resout, choix_pondere_i, choix_min_max]).


afficher_mgu(bottom):-
	echo("No"),nl.

afficher_mgu([]):-
	nl,echo("Yes"),nl.

afficher_mgu([X = T|Q]):-
	echo(X), echo(" = "), echo(T),nl,
	afficher_mgu(Q).

afficher_systeme(P):-
	echo("system: "), echo(P),nl.

afficher_application_regle(E,R):-
	echo(R), echo(": "), echo(E),nl.

unifie(P) :-
	unifie(P, choix_premier, parcours_profondeur).

unifie(P, Strat, Parcours) :-
	unifie(P, [], S2, Strat, Parcours),nl,
	afficher_mgu(S2),nl.

unifie([],S1, S1,_, _):-
	S1 \== bottom.

unifie(_,bottom, bottom,_, _).

unifie(P, S1, S2, Strat, Parcours) :-
	S1 \== bottom,
	afficher_systeme(P),
	call(Strat, P, Q, X ?= T, R, Parcours),
	afficher_application_regle(X ?= T,R),
	resout(R,X = T,S1,S3),
	unifie(Q, S3, S2, Strat, Parcours).



extraction_gauche(E, L, N):-
	append([E], N, L).

choix_premier(P, Q, E, R, _):-
	extraction_gauche(E, P, P1),
	regle(E, R),
	reduit(R, E, P1, Q).



unif(P, S, Parcours):-
	clr_echo,
	unifie(P, S, Parcours).


trace_unif(P, S, Parcours):-
	set_echo,
	unifie(P, S, Parcours).
