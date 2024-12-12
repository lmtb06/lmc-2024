:- module(choix_pondere_i, [liste_choix_pondere_1/1, liste_choix_pondere_2/1, liste_choix_pondere_3/1, choix_pondere_1/5, choix_pondere_2/5, choix_pondere_3/5, choisir_element_regle/5]).
:- use_module([regle, reduit]).

% Liste des priorités pour le choix pondéré 1
liste_choix_pondere_1([clash, check, rename, simplify, orient, decompose, expand]).


% Liste des priorités pour le choix pondéré 2
liste_choix_pondere_2([simplify, rename, decompose, expand, clash, check, orient]).


% Liste des priorités pour le choix pondéré 3
liste_choix_pondere_3([expand, decompose, simplify, rename, clash, check, orient]).



% On applique choisir_element_regle_largeur selon les règles de la liste_choix_pondere_1
% Choisi et réduit l'équation
choix_pondere_1(P, Q, E, R, _) :-
	liste_choix_pondere_1(LISTE),
	choisir_element_regle(P, Q, E, R, LISTE).


% On applique choisir_element_regle_largeur selon les règles de la liste_choix_pondere_2
% Choisi et réduit l'équation
choix_pondere_2(P, Q, E, R, _) :-
	liste_choix_pondere_2(LISTE),
	choisir_element_regle(P, Q, E, R, LISTE).


% On applique choisir_element_regle_largeur selon les règles de la liste_choix_pondere_3
% Choisi et réduit l'équation
choix_pondere_3(P, Q, E, R, _) :-
	liste_choix_pondere_3(LISTE),
	choisir_element_regle(P, Q, E, R, LISTE).

% choisir_element_regle_profondeur prend P le système, Q le nouveau systeme, E l'équation, R la règle
% et LISTE la liste des priorités
% Avec member et regle on trouve la règle la plus prioritaire applicable 
% puis avec select on enelève l'equation de P puis on réduit
choisir_element_regle(P, Q, E, R, LISTE) :-
	member(REGLE, LISTE),
    member(E, P),
    regle(E, REGLE),
    !,
    R = REGLE,
    select(E, P, ResteP),         
    reduit(REGLE, E, ResteP, Q),   
    Q \= P.   
