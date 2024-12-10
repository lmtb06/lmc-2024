:- module(affichage, [afficher_mgu/1, afficher_systeme/1, afficher_application_regle/2]).
:- use_module([code_fourni]).

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