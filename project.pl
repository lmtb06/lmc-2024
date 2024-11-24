% Code fournis par le sujet.
% =================================================================================================================



:- op(20,xfy,?=).

% Prédicats d'affichage fournis

% set_echo: ce prédicat active l'affichage par le prédicat echo
set_echo :- assert(echo_on).

% clr_echo: ce prédicat inhibe l'affichage par le prédicat echo
clr_echo :- retractall(echo_on).

% echo(T): si le flag echo_on est positionné, echo(T) affiche le terme T
%          sinon, echo(T) réussit simplement en ne faisant rien.

echo(T) :- echo_on, !, write(T).
echo(_).



% Question 1, a) regle(E,R) : détermine la règle de transformation R qui s’applique à l’équation E
% =================================================================================================================


% Regle rename : renvoie vrai si T est une variable, sinon faux et on s'arrête.
regle(_?=T, rename) :- var(T), !.


% Regle simplify : renvoie vrai si T est une constante, sinon faux et on s'arrête.
regle(_?=T, simplify) :- atomic(T), !.


% Regle expand : renvoie vrai si T est composé et que X (X variable) n'est pas dans T, sinon faux et on s'arrête.
regle(X?=T, expand) :- var(X), compound(T), occur_check(X, T), !.


% Regle check : renvoie vrai si X différent de T et si le test d'occurence passe, sinon faux et on s'arrête.
regle(X?=T, check) :- not(X == T), not(occur_check(X,T)), !.


% Regle orient: renvoie vrai si X est une variable et que T n'est pas une variable, sinon faux et on s'arrête.
regle(X?=T, orient) :- var(X), nonvar(T), !.


% Regle decompose : renvoie vrai si on ne peut appliquer la règle expand et que les deux noms et arité sont les mêmes
% sinon faux et on s'arrête.
regle(S?=T, decompose) :- not(regle(S?=T, expand)), !,compound(S), compound(T), functor(S, N1, A1), functor(T, N2, A2), A1==A2, N1==N2, !.


% Regle clash : renvoie vrai si S différent de T, sinon faux et on s'arrête. 
regle(S?=T, clash) :- not(functor(S, N, A) = functor(T, N, A)), !.



% Question 1, b) occur_check(V,T) : teste si la variable V apparaît dans le terme T
% =================================================================================================================



% Cas 1 : T est une variable, est que V est différent de T
% renvoie vrai si T est une variable et que V est différent de T, faux sinon et on arrête
occur_check(V,T):- var(T),!, not(V == T),!.


% Cas 2 : Décomposition de la liste
% décomposition avec =.. et on vérifie que V n'est pas présent dans les éléments de T
occur_check(V,T):- T =.. [_|R], occur_check_rec(V,R), !.


% Cas 3 : Liste vide
% renvoie vrai car la liste est vide
occur_check_rec(_,[]):-!.


% Cas 4 : Liste non vide
% on test avec la tête de la liste et on test avec le reste de la liste.
% soit la liste est vide et renvoie vrai cas 3 sinon cas 4
occur_check_rec(V,[F|R]):- occur_check(V,F), occur_check_rec(V,R),!.



% Question 1, c) 
% =================================================================================================================



% Réduit orient, Q = une nouvelle liste contenant X?=T inversé donc T?=X et P 
reduit(orient,X?=T,P,Q) :- append([T?=X], P, Q).

% Réduit décompose, on décompose X et T, appel à décompose_rec avec les arguments de X, les arguments de T et Q2 une variable temporaire pour l'équation. 
% A la fin on créer une nouvelle liste Q contenant l'équation Q2 et les équations de P.
reduit(decompose, X?=T,P,Q) :- X =.. [_|R], T=..[_|R2], decompose_rec(R, R2, Q2), append(Q2, P, Q).


% Reduit des règles Rename, Simplify et Expand font la même chose dans ce cas.
% Toutes les occurences de X se font renommer par T puis transforme le système d’équations P en le système d’équations Q
% On vérifie que R est différent à clash ou de check car le programme doit s'arreter si l'un des deux règles s'appliquer
% Revient au même que d'expliciter les règles Rename, Simplify et Expand
reduit(R, X?=T, P, Q) :- not(R==clash ; R ==check),!, X = T, Q = P.


% decompose_rec condition d'arrêt
decompose_rec([], [], []). 

% decompose_rec on a 3 listes. [H1|RS] celle de la première équation. [H2|R2S] celle de la deuxième équation
% et Q contenant la liste l'équation entre H1 et H2 et le reste. On appel ensuite récursivement sur le reste des listes
decompose_rec([H1|RS], [H2|R2S], [H1?=H2 | Q]) :- decompose_rec(RS, R2S, Q).

% condition d'arret d'unifie
unifie([]).  

% unfie prend une liste d'équation. 
% regle(H, REGLEAPPLICABLE) permet de trouver la règle qui s'applique sur la première équation. 
% on affiche la réduction
% on appel à reduit de la regle applicable sur H, R est le reste de la liste, Q le resultat de reduit
% on appel recursivement unifie sur Q. 
unifie([H|R]) :-
    regle(H, REGLEAPPLICABLE),
    set_echo,
    echo(reduit(REGLEAPPLICABLE, H, R, Q)), nl,
    reduit(REGLEAPPLICABLE, H, R, Q),
    unifie(Q).



%question 2


% choix pondere 1 = clash, check > rename, simplify > orient > decompose > expand
% choix pondere 2 = decompose > expand > clash > check > rename > simplify > orient


% Liste dans l'ordre de priorité maximale à minimale pour pondere_1
liste_choix_pondere_1([clash, check, rename, simplify, orient, decompose, expand]).

% Si unifie de choix premier on applique unifie "classique"
unifie(P, choix_premier) :- unifie(P), !.

% Unifie avec choix pondere_1 
% Choisie la bonne équation avec la bonne règle à appliquer
% on affiche la réduction
% on appel à reduit de la regle applicable sur E, Q est le reste de la liste, P1 le resultat de reduit
% on appel recursivement unifie sur P1 avec choix_pondere_1 
unifie(P, choix_pondere_1) :- choix_pondere_1(P, Q, E, R),
    set_echo, echo(reduit(R, E, Q, P1)), nl,
    reduit(R, E, Q, P1),
    unifie(P1, choix_pondere_1).

% Choix pondere_1 
% Je recupère ma liste des priorités
% Parcours la liste des priorité
% Pour chaque Regle on regarde si on peut appliquer la regle dans l'ordre de priorité
choix_pondere_1(P, Q, E, R) :- 
    liste_choix_pondere_1(LISTE), 
    member(REGLE, LISTE),
    regle(E, REGLE), 
    !, 
    R = REGLE, 
    select(E, P, Q).


