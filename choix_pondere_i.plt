:- use_module([choix_pondere_i]).
:- op(20,xfy,?=).
:- begin_tests(choix_pondere_i).

test(choix_pondere_1_test) :-
    choix_pondere_1([X ?= a], Q, E, R), !,
    assertion(Q == []), assertion(E== X?=a), assertion(R==simplify).


test(choix_pondere_2_test) :-
    choix_pondere_2([X ?= a], Q, E, R), !,
    assertion(Q == []), assertion(E== X?=a), assertion(R==simplify).


test(choix_pondere_3_test) :-
    choix_pondere_3([X ?= a], Q, E, R), !,
    assertion(Q == []), assertion(E== X?=a), assertion(R==simplify).     


test(choix_pondere_1_test_2) :-
    \+ choix_pondere_1([X ?= f(X)], _,_,_).


test(choix_pondere_2_test_2) :-
    \+ choix_pondere_2([X ?= f(X)], _,_,_).


test(choix_pondere_3_test_2) :-
    \+choix_pondere_3([X ?= f(X)], _,_,_).


test(choix_pondere_1_test_3) :-
    \+choix_pondere_1([a ?= b], _,_,_).  


test(choix_pondere_2_test_3) :-
    \+choix_pondere_2([a ?= b], _,_,_).


test(choix_pondere_3_test_3) :-
    \+choix_pondere_3([a ?= b], _, _, _).


test(choix_pondere_1_test_4) :- 
    \+choix_pondere_1([f(a) ?= g(b), X ?= a, Y ?= b, X ?= X, Z ?= f(Y, a), f(X, g(Y)) ?= f(a, g(b))], _, _, _).


test(choix_pondere_2_test_4) :- 
    choix_pondere_2([f(a) ?= g(b), X ?= a, Y ?= b, X ?= X, Z ?= f(Y, a), f(X, g(Y)) ?= f(a, g(b))], Q, E, R), !, 
    assertion(Q == [f(a)?=g(b), Y?=b, a?=a, Z?=f(Y, a), f(a, g(Y))?=f(a, g(b))]),
    assertion(E== X?=a),
    assertion(R==simplify).    

test(choix_pondere_3_test_4) :- 
    choix_pondere_3([f(a) ?= g(b), X ?= a, Y ?= b, X ?= X, Z ?= f(Y, a), f(X, g(Y)) ?= f(a, g(b))], Q, E, R), !,
    assertion(X== Z),
    assertion(Z== f(Y, a)),
    assertion(Q == [f(a)?=g(b), f(Y, a)?=a, Y?=b, f(Y, a)?=f(Y, a), f(f(Y, a), g(Y))?=f(a, g(b))]),
    assertion(E == f(Y, a)?=f(Y, a)),
    assertion(R == expand).

:- end_tests(choix_pondere_i).