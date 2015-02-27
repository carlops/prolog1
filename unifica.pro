/*
 *  UNIFICA CON OCCURS CHECK
 *	
 *	El predicado unifica/2 implementa el algoritmo de unificacion de prolog2
 *	 con 'Occurs Check'
 */

/* 
 *  unifica(A,B).
 *	-> A variable a unificar
 *	-> B variables a unificar
 *	Triunfa si ambas variables unifican.
 *
 *	Realiza las verificaciones necesarias para proceder a la unificacion
 *	 en caso de ser variables se vefirica la ocurrecia de una variable 
 * 	 con la otra, y en el caso de se variables compuestas, se invoca
 *	 un predicado recursivo para unificar los argumentos de ambas variables.
 *
 */
unifica(A,B):-
	atomic(A),atomic(B),A==B.
unifica(A,B):-
	var(A),var(B), A=B.
unifica(A,B):-
	var(A),\+(mi_occurs_check(B,A)),A=B.
unifica(A,B):-
	var(B),\+(mi_occurs_check(A,B)),A=B.
unifica(A,B):-
	compound(A),compound(B),
	A=..[F|ArgumentosA],B=..[F|ArgumentosB],
	unificar_argumentos(ArgumentosA,ArgumentosB).
/*
 *  unificar_argumentos(ListaA,ListaB).
 *	-> ListaA, Lista con los argumentos de la variable compuesta A
 * 	-> ListaB, Lista con los argumentos de la variable compuesta B
 *
 *	Manda a verificar recursivamente un argumento de A con un argumento
 *	 de B, en orden izquierda a derecha, y triunfa si todos los argumentos
 *	 unifican.
 *
 */
unificar_argumentos([A|ArgumentosA],[B|ArgumentosB]):-
	unifica(A,B),
	unificar_argumentos(ArgumentosA,ArgumentosB).
unificar_argumentos([],[]).

/*
 *  mi_occurs_check/2
 *	
 *	Posee la misma idea que el predicado unifica/2, toma
 *	 dos variables y realiza las verificaciones necesarias
 *	 para encontrar ocurrencia de A en B.
 *
 *	En caso de ser variables compuestas se invoca un predicado
 *	 recursivo para la verificacion de ocurrencia argumento por argumento.
 *
 */
mi_occurs_check(A,B):- var(A), A=B.
mi_occurs_check(A,B):- compound(A), A=..[_|ArgumentosA],occurs_check_recursivo(ArgumentosA,B).

occurs_check_recursivo([A|ArgumentosA],B):-
	mi_occurs_check(A,B);occurs_check_recursivo(ArgumentosA,B).


