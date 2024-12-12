:- module(choix_min_max, [choix_la_plus_grande/5]).
:- use_module([regle, reduit, code_fourni]).


taille(X ?= T, Longueur) :- 
    compound(X),
    compound(T), !,
    term_to_atom(X, Xatoms),
    term_to_atom(T, Tatoms),
    atom_length(Xatoms, XatomsLength),
    atom_length(Tatoms, TatomsLength),
    Longueur is XatomsLength + TatomsLength.

taille(X ?= T, Longueur) :- 
    compound(X),
    var(T), !,
    term_to_atom(X, Xatoms),
    atom_length(Xatoms, XatomsLength),
    Longueur is XatomsLength + 1.

taille(X ?= T, Longueur) :- 
    compound(T),
    var(X), !,
    term_to_atom(T, Tatoms),
    atom_length(Tatoms, TatomsLength),
    Longueur is TatomsLength + 1.

taille(X ?= T, Longueur) :- 
    atomic(X),
    var(T), !,
    atom_chars(X, Xatoms),
    atom_length(Xatoms, XatomsLength),
    Longueur is XatomsLength + 1.

taille(X ?= T, Longueur) :- 
    atomic(T),
    var(X), !,
    atom_chars(T, Tatoms),
    atom_length(Tatoms, TatomsLength),
    Longueur is TatomsLength + 1.

taille(X ?= T, Longueur) :- 
    var(T),
    var(X), !,
    Longueur is 2.

taille(X ?= T, Longueur) :- 
    atomic(X),
    atomic(T), !,
    atom_chars(X, Xatoms),
    atom_chars(T, Tatoms),
    atom_length(Xatoms, XatomsLength),
    atom_length(Tatoms, TatomsLength),
    Longueur is XatomsLength + TatomsLength.

taille(X ?= T, Longueur) :- 
    atomic(X),
    compound(T), !,
    atom_chars(X, Xatoms),
    term_to_atom(T, Tatoms),
    atom_length(Xatoms, XatomsLength),
    atom_length(Tatoms, TatomsLength),
    Longueur is XatomsLength + TatomsLength.

taille(X ?= T, Longueur) :- 
    compound(X),
    atomic(T), !,
    term_to_atom(X, Xatoms),
    atom_chars(T, Tatoms),
    atom_length(Xatoms, XatomsLength),
    atom_length(Tatoms, TatomsLength),
    Longueur is XatomsLength + TatomsLength.


calculer_tailles([], []). 

calculer_tailles([E|Reste], [Longeur|TabLongueur]) :-
        taille(E, Longeur),        
        calculer_tailles(Reste, TabLongueur).  


choix_la_plus_grande(P, Q, E, R, _) :-
    calculer_tailles(P, Taille),           
    max_list(Taille, Plus_grande),        
    nth0(Index, Taille, Plus_grande),
    nth0(Index, P, E),
    regle(E, REGLE),
    !,
    R = REGLE,
    select(E, P, ResteP),
    reduit(REGLE, E, ResteP, Q),
    Q \= P.
