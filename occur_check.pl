:- module(occur_check, [occur_check/2]).

occur_check(V, T):-
	var(V),
	\+compound(T),!,
	V \== T.

occur_check(V, T):-
	var(V),
	compound(T),!,	
	T =.. [_|Args],
    maplist(occur_check(V), Args).