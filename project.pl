:- use_module([code_fourni, regle, reduit, substitution, resout]).





% Question 1, b) occur_check(V,T) : teste si la variable V apparaît dans le terme T
% =================================================================================================================


% Reduit des règles Rename, Simplify et Expand font la même chose dans ce cas.
% Toutes les occurences de X se font renommer par T puis transforme le système d’équations P en le système d’équations Q
% On vérifie que R est différent à clash ou de check car le programme doit s'arreter si l'un des deux règles s'appliquer
% Revient au même que d'expliciter les règles Rename, Simplify et Expand





% unfie prend une liste d'équation. 
% regle(H, REGLEAPPLICABLE) permet de trouver la règle qui s'applique sur la première équation. 
% on affiche la réduction
% on appel à reduit de la regle applicable sur H, R est le reste de la liste, Q le resultat de reduit
% on appel recursivement unifie sur Q. 

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
	unifie(P, choix_premier).

unifie(P, Strat) :-
	unifie(P, [], S2, Strat),nl,
	afficher_mgu(S2),nl.

unifie([],S1, S1,_):-
	S1 \== bottom.

unifie(P, S1, S2, Strat) :-
	S1 \== bottom,
	afficher_systeme(P),
	call(Strat, P, Q, X ?= T, R),
	afficher_application_regle(X ?= T,R),
	resout(R,X = T,S1,S3),
	unifie(Q, S3, S2, Strat).

unifie(_,bottom, bottom,_).

extraction_gauche(E, L, N):-
	append([E], N, L).

choix_premier(P, Q, E, R):-
	extraction_gauche(E, P, P1),
	regle(E, R),
	reduit(R, E, P1, Q).

%question 2

% choix pondere 1 = clash, check > rename, simplify > orient > decompose > expand
% choix pondere 2 = decompose > expand > clash > check > rename > simplify > orient


% Liste dans l'ordre de priorité maximale à minimale pour pondere_1

liste_choix_pondere_1([clash, check, rename, simplify, orient, decompose, expand]).

liste_choix_pondere_2([simplify, rename, decompose, expand, clash, check, orient]).

liste_choix_pondere_3([expand, decompose, simplify, rename, clash, check, orient]).

% Unifie avec choix pondere_1 
% Choisie la bonne équation avec la bonne règle à appliquer
% on affiche la réduction
% on appel à reduit de la regle applicable sur E, Q est le reste de la liste, P1 le resultat de reduit
% on appel recursivement unifie sur P1 avec choix_pondere_1 

% strategie(P,Q,E,R,Selection):-
%     call(S, P, E, R, Reste),
%     reduit(R, E, Reste, Q).
    

% choix_pondere(I,Extraction,P,Q,E,R).

% choix_equation_premier(Systeme, NouveauSysteme, Regle, Equation, Parcours):-
%     select(Equation, Systeme, Reste),
%     regle(Equation, Regle),
%     reduit(Regle, Equation, Reste, NouveauSysteme, Parcours).

% choix_pondere_1(Systeme, NouveauSysteme, Regle, Equation, Parcours):-
%     liste_choix_pondere_1(Ponderation),
%     member(Regle, Ponderation),
%     member(Equation, Systeme),!,
%     select(Equation, Systeme, Reste),         
%     reduit(Regle, Equation, Reste, NouveauSysteme, Parcours),   
%     NouveauSysteme \= Systeme.

% choix_premier_largeur(P, Q, E, R):-
%     call(choix,P, Q, E, R, choix_equation_premier, parcour_en_largeur).

% choix_pondere1(P, Q, E, R):-
%     call(choix,P, Q, E, R, choix_equation_pondere1, parcours_en_profondeur).

% choix_pondere1_largeur(P, Q, E, R):-
%     call(choix,P, Q, E, R, choix_equation_premier, parcour_en_largeur).


% choix premier
% choix_premier([Tete|Queue], Q, Tete, R) :- 
%     regle(Tete, R),
%     reduit(R, Tete, Queue, Q).


% choisir_element_regle(P, Q, E, R, LISTE) :-
%     member(REGLE, LISTE),
%     member(E, P),
%     regle(E, REGLE),
%     !,
%     R = REGLE,
%     select(E, P, ResteP),         
%     reduit(REGLE, E, ResteP, Q),   
%     Q \= P.   

% Choix pondere_1 
% Je recupère ma liste des priorités
% Parcours la liste des priorité
% Pour chaque Regle on regarde si on peut appliquer la regle dans l'ordre de priorité
% Affectation de la règle à R pour pouvoir l'appliquer à la fin
% On retire l'équation E de P et on le met dans Q
% choix_pondere_1(P, Q, E, R) :- 
%     liste_choix_pondere_1(LISTE),
%     choisir_element_regle(P, Q, E, R, LISTE).
    
% choix_pondere_2(P, Q, E, R) :- 
%     liste_choix_pondere_2(LISTE),
%     choisir_element_regle(P, Q, E, R, LISTE).

% choix_pondere_3(P, Q, E, R) :- 
% liste_choix_pondere_3(LISTE),
%     choisir_element_regle(P, Q, E, R, LISTE).

% choix_aleatoire

% choix_plus_courte_equation

% choix_plus_longue_equation

% choix_largeur




% Permet d’inhiber la trace d’affichage des règles appliquées à chaque étape.

unif(P, S):-
	clr_echo,
	unifie(P, S).

% Permet d’activer la trace d’affichage des règles appliquées à chaque étape.

trace_unif(P, S):-
	set_echo,
	unifie(P, S).

start:-
	trace_unif([f(X,Y) ?= f(g(Z),h(a)), Z ?= f(X)], choix_premier),
	trace_unif([f(X,Y) ?= f(g(Z),h(a)), Z ?= f(Y)], choix_premier).
