:- use_module([regle]).
:- op(20,xfy,?=).
:- begin_tests(regle).

% Test Rename

test(rename) :-
	regle(X?=T,R),
    assertion(var(X)),
    assertion(var(T)),
    assertion(R==rename).
    

% Test Simplify

test(simplify) :-
	regle(X?=t,R),
    assertion(R==simplify).

% Test Expand

test(expand_simple) :-
	regle(X?=f(a),R),
    assertion(R==expand).

test(expand_complex) :-
	regle(X?=f(a,k(c)),R),
    assertion(R==expand).

% Test Check

test(check_simple) :-
	regle(X?=f(X),R),
    assertion(R==check).

test(check_complex) :-
	regle(X?=f(a,k(X)),R),
    assertion(R==check).

% Test Orient

test(orient_simple) :-
	regle(a?=X,R),
    assertion(R==orient).

test(orient_complex) :-
    regle(f(a)?=X,R),
    assertion(R==orient).

% Test Decompose

test(decompose_simple) :-
	regle(f(X)?=f(T),R),
    assertion(R==decompose).

test(decompose_complex) :-
    regle(f(X, Y) ?= f(g(Z), h(a)), R),
    assertion(R==decompose).

% Test Clash

test(clash_symbole) :-
	regle(f(X)?=g(T),R),
    assertion(R==clash).

test(clash_arite) :-
    regle(f(X)?=f(T,a),R),
    assertion(R==clash).

test(clash_arite_symbole) :-
    regle(f(X)?=g(T,a),R),
    assertion(R==clash).

:- end_tests(regle).