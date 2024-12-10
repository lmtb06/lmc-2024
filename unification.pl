:- module(unification,[unif/2, trace_unif/2]).
:- use_module([strategies,code_fourni, resout, affichage]).

unifie(P) :-
	unifie(P, choix_premier).

unifie(P, Strat) :-
	unifie(P, _, [], S, Strat),
	nl,
	afficher_mgu(S),
	nl.

unifie([], [], S1, S1, _):-
	S1 \== bottom,!.

unifie(P, P1, S1, S2, Strat) :-
	S1 \== bottom,
	afficher_systeme(P),
	call(Strat, P, Q, X ?= T, R),
	afficher_application_regle(X ?= T, R),
	resout(R, X = T, S1, S3),
	unifie(Q, P1, S3, S2, Strat).

unifie(_, _, S1, S2, _) :-
	S1 == bottom,!,
	S2 = bottom.

% Permet d’inhiber la trace d’affichage des règles appliquées à chaque étape.

unif(P, S):-
	clr_echo,
	unifie(P, S).

% Permet d’activer la trace d’affichage des règles appliquées à chaque étape.

trace_unif(P, S):-
	set_echo,
	unifie(P, S).