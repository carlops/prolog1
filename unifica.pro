/*
 *
 */

unifica(A,B):-
	atomic(A),atomic(B),A==B.
unifica(A,B):-
	var(A),var(B), A=B.
unifica(A,B):-
	var(A),\+(mi_occurs_check(B,A)),A=B.
unifica(A,B):-
	var(B),\+(mi_occurs_check(A,A)),A=B.
unifica(A,B):-
	compound(A),compound(B),
	A=..[F|ArgumentosA],B=..[F|ArgumentosB],
	unificar_argumentos(ArgumentosA,ArgumentosB).

mi_occurs_check(A,B):- var(A), A=B.
mi_occurs_check(A,B):- compound(A), A=..[_|ArgumentosA],occurs_check_recursivo(ArgumentosA,B).

occurs_check_recursivo([A|ArgumentosA],B):-
	mi_occurs_check(A,B);occurs_check_recursivo(ArgumentosA,B).

unificar_argumentos([A|ArgumentosA],[B|ArgumentosB]):-
	unifica(A,B),
	unificar_argumentos(ArgumentosA,ArgumentosB).
unificar_argumentos([],[]).
