:- use_module([code_fourni, unification, strategies]).

% TODO Fix bug renommage des variables souvent au niveau du dernier expand de l'exemple 2 du parcours en profondeur 

exemples_choix_premier:-
	write("Strategie choix premier:"),nl,nl,
	write("Exemple 1:"),nl,
	trace_unif([f(X,Y) ?= f(g(Z),h(a)), Z ?= f(Y)], choix_premier),
	write("Exemple 2:"),nl,
	trace_unif([f(X,Y) ?= f(g(Z),h(a)), Z ?= f(X)], choix_premier),
	write("Exemple 3:"),nl,
	trace_unif([f(X,Y) ?= f(g(Z),h(a)), X ?= f(X), Z ?= f(X)], choix_premier).

exemples_choix_premier_largeur:-
	write("Strategie choix premier parcours en largeur:"),nl,nl,
	write("Exemple 1:"),nl,
	trace_unif([f(X,Y) ?= f(g(Z),h(a)), Z ?= f(Y)], choix_premier_largeur),
	write("Exemple 2:"),nl,
	trace_unif([f(X,Y) ?= f(g(Z),h(a)), Z ?= f(X)], choix_premier_largeur),
	write("Exemple 3:"),nl,
	trace_unif([f(X,Y) ?= f(g(Z),h(a)), X ?= f(X), Z ?= f(X)], choix_premier_largeur). % Le check est détecté beaucoup plus tôt comparé au choix premier normal, nous évitant des traitements en plus en soit en utilisant le parcours en largeur, on effectue le chemin le plus court pour determiner si le système n'a pas de solution comparé à la même stratégie utilisant un parcours en profondeur

start:-
	exemples_choix_premier(),
	exemples_choix_premier_largeur().
