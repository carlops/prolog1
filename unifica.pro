/*
 *
 */

unifica(A,B):-
	atomic(A),atomic(B),A=B.
unifica(A,B):-
	var(A),A=B.
unifica(A,B):-
	compound(A),compound(B),
	A=..[F|ArgumentosA],B=..[F|ArgumentosB],
	unificar_argumentos(ArgumentosA,ArgumentosB).

unificar_argumentos([A|ArgumentosA],[B|ArgumentosB]):-
	unifica(A,B),
	unificar_argumentos(ArgumentosA,ArgumentosB).
unificar_argumentos([],[]).
