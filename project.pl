:- use_module(['substitution.pl']).

% Code fournis par le sujet.
% =================================================================================================================



:- op(20,xfy,?=).

% Prédicats d'affichage fournis

% set_echo: ce prédicat active l'affichage par le prédicat echo

set_echo :-
	assert(echo_on).

% clr_echo: ce prédicat inhibe l'affichage par le prédicat echo

clr_echo :-
	retractall(echo_on).

% echo(T): si le flag echo_on est positionné, echo(T) affiche le terme T
%          sinon, echo(T) réussit simplement en ne faisant rien.

echo(T) :-
	echo_on,
	!,
	write(T).

echo(_).



% Question 1, a) regle(E,R) : détermine la règle de transformation R qui s’applique à l’équation E
% =================================================================================================================


% Regle rename : renvoie vrai si T est une variable, sinon faux et on s'arrête.

regle(_?=T, rename) :-
	var(T),
	!.


% Regle simplify : renvoie vrai si T est une constante, sinon faux et on s'arrête.

regle(X?=T, simplify) :-
	atomic(T),
	not(X == T),
	!.


% Regle expand : renvoie vrai si T est composé et que X (X variable) n'est pas dans T, sinon faux et on s'arrête.

regle(X?=T, expand) :-
	var(X),
	compound(T),
	occur_check(X, T),
	!.


% Regle check : renvoie vrai si X différent de T et si le test d'occurence passe, sinon faux et on s'arrête.

regle(X?=T, check) :-
	not(X == T),
	not(occur_check(X, T)),
	!.


% Regle orient: renvoie vrai si X est une variable et que T n'est pas une variable, sinon faux et on s'arrête.

regle(X?=T, orient) :-
	var(X),
	nonvar(T),
	!.


% Regle decompose : renvoie vrai si on ne peut appliquer la règle expand et que les deux noms et arité sont les mêmes
% sinon faux et on s'arrête.

regle(S?=T, decompose) :-
	not(regle(S ?= T, expand)),
	!,
	compound(S),
	compound(T),
	functor(S, N1, A1),
	functor(T, N2, A2),
	A1 == A2,
	N1 == N2,
	!.


% Regle clash : renvoie vrai si S différent de T, sinon faux et on s'arrête. 

regle(S?=T, clash) :-
	not(functor(S, N, A) = functor(T, N, A)),
	!.



% Question 1, b) occur_check(V,T) : teste si la variable V apparaît dans le terme T
% =================================================================================================================



% Cas 1 : T est une variable, est que V est différent de T
% renvoie vrai si T est une variable et que V est différent de T, faux sinon et on arrête

occur_check(V, T):-
	var(T),
	!,
	not(V == T),
	!.


% Cas 2 : Décomposition de la liste
% décomposition avec =.. et on vérifie que V n'est pas présent dans les éléments de T

occur_check(V, T):-
	T =.. [_|R],
	occur_check_rec(V, R),
	!.


% Cas 3 : Liste vide
% renvoie vrai car la liste est vide

occur_check_rec(_, []):-
	!.


% Cas 4 : Liste non vide
% on test avec la tête de la liste et on test avec le reste de la liste.
% soit la liste est vide et renvoie vrai cas 3 sinon cas 4

occur_check_rec(V, [F|R]):-
	occur_check(V, F),
	occur_check_rec(V, R),
	!.



% Question 1, c) 
% =================================================================================================================

reduit(R, X?=T, P, Q) :-
	member(R, [rename,simplify,expand]),	
	substitution(X, T, P, Q).

reduit(orient, X?=T, P, Q) :-
	append([T ?= X], P, Q).

reduit(decompose, X?=T, P, Q) :-
	X =.. [_|R],
	T =.. [_|R2],
	decompose_rec(R, R2, Q2),
	append(Q2, P, Q).

reduit(R, _, _, _):-
	member(R, [check,clash]).


transformation(R,X ?= T,S1,S2):-
	S1 \== empty,
	member(R, [rename,simplify,expand]),
	substitution(X,T,S1,S), S2 = [X ?= T|S].

transformation(R,_,_,S2):-
	member(R, [check,clash]),	
	S2 = empty.

transformation(R,_,S1,S2):-
	S1 \== empty,
	R == decompose,
	S2 = S1.

transformation(_,_,empty,empty).

% Reduit des règles Rename, Simplify et Expand font la même chose dans ce cas.
% Toutes les occurences de X se font renommer par T puis transforme le système d’équations P en le système d’équations Q
% On vérifie que R est différent à clash ou de check car le programme doit s'arreter si l'un des deux règles s'appliquer
% Revient au même que d'expliciter les règles Rename, Simplify et Expand
% reduit(R, X?=T, P, Q) :-
% 	not(R == clash;
% 	R == check),
% 	!,
% 	substitution(X, T, P, Q),
% 	X = T.
% reduit(R, X?=T, P, Q, _) :- not(R==clash ; R ==check),!, X = T, Q = P.


% decompose_rec condition d'arrêt

decompose_rec([], [], []). 

% decompose_rec on a 3 listes. [H1|RS] celle de la première équation. [H2|R2S] celle de la deuxième équation
% et Q contenant la liste l'équation entre H1 et H2 et le reste. On appel ensuite récursivement sur le reste des listes

decompose_rec([H1|RS], [H2|R2S], [H1?=H2|Q]) :-
	decompose_rec(RS, R2S, Q).



% unfie prend une liste d'équation. 
% regle(H, REGLEAPPLICABLE) permet de trouver la règle qui s'applique sur la première équation. 
% on affiche la réduction
% on appel à reduit de la regle applicable sur H, R est le reste de la liste, Q le resultat de reduit
% on appel recursivement unifie sur Q. 

empty.

unifie(P) :-
	unifie(P, choix_premier).

unifie(P, Strat) :-
	unifie(P, Strat, S),
	(application(S),echo("Yes"),nl;echo("No"),nl).

application([]).

application([X?=T|Q]):-
	% echo(X), echo(" = "), echo(T),nl,
	X = T,
	application(Q).

unifie([],_,S):-
	S \== empty.

unifie(P, Strat, S) :-
	S \== empty,
	echo("system: "),echo(P),nl,
	call(Strat, P, Q, E, R),
	echo(R), echo(": "), echo(E),nl,
	unifie(Q, Strat, S1),
	transformation(R,E,S1,S).

unifie(_,_,empty).

extraction_gauche(E, L, N):-
	select(E, L, N).

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