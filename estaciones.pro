% Autores:
% Alejandro Guevara carnet: 09-10971
% Carlo Polisano    carnet: 09-10672

/*
 *  ESTACIONES
 *
 *	estaciones/1 unifica su argumento con la mejor estacion, por lo tant
 *	 tiene exito si encuentra la mejor ciudad, y falla cuando no pueda
 *	 hallarla
 */
% Ejemplo propuesto en el enunciado del proyecto
carril(brussel,charleroi).
carril(brussel,haacht).
carril(haacht,mechelen).
carril(mechelen,berchem).
carril(berchem,antwerpen).
carril(brussel,boom).
carril(antwerpen,boom).
carril(antwerpen,turnhout).

/*
 *  ciudad(X,L,N)
 *	-> X, ciudad existente en algun carril
 *	<- L, lista de ciudades conectadas directamente a la ciudad X
 *	<- N, longitud de la lista L.
 *
 */
ciudad(X,L,N) :- 
	bagof(Y,(carril(X,Y);carril(Y,X)),L),
	length(L,N).

/*
 *  ciudadPequena(X)
 *	unifica X con una ciudad pequena
 */
ciudadPequena(X) :-
	ciudad(X,_,N),
	N<3.

/*
 *  ciudadGrande(X)
 *	unifica X con una ciudad grande
 */
ciudadGrande(X) :-
	ciudad(X,_,N),
	N>2.

/*
 *  buenaCiudad(X,N)
 *	El predicado triunfa si X es una ciudad pequena con
 *	 distancia N a ambas ciudades grandes mas cercanas.
 *
 */
buenaCiudad(X,N1) :-
	ciudad(X,_,N),
	N==2, % X va a ser una ciudad pequena
	ciudadGrande(C1),
	ciudadGrande(C2),
	C1 \== C2,
	bfs(C1,[[X]],Camino1), length(Camino1,N1),
	bfs(C2,[[X]],Camino2), length(Camino2,N2),
	N1==N2. % el bfs va a encontrar el mas pequenio de primero.

/*
 *  estacion(X)
 *
 *	El predicado triunfa si X es una mejor ciudad.
 *	
 *	Al ser invocado con una variable, enumera todas las mejores
 *	 ciudades.
 */ 
estacion(X):-
	findall((X1,N),buenaCiudad(X1,N),L1),
	comprimir(L1,L), primero(L,(_,N1)),!,
	select((X,N1),L,_).


/*
 *  comprimir(L1,L2).
 *	Elimina las ocurrencias repetidas de los elementos de la lista
 *	-> L1, lista a remover duplicados
 *	<- L2, lista sin diplicados consecutivos.
 */
comprimir([],[]).
comprimir([X],[X]).
comprimir([X,X|Xs],Zs) :- comprimir([X|Xs],Zs).
comprimir([X,Y|Ys],[X|Zs]) :- X \= Y, comprimir([Y|Ys],Zs).

/*
 *  primero(L,X)
 *	
 *	El predicado triunfa si X es el primer elemento de la lista L
 *	-> L, lista
 *	<- X, primer elemento de L
 *
 */
primero([X],X).
primero([X|_],X).

 /*
 * Esta implementacion de bfs, fue tomada de los ejemplos de la pagina del curso
 *  y adaptada para el funcionamiento con el predicado carriles.
 *
 * bfs(Problema,Posibilidades,Solucion)
 * -> Problema es el estado final al cual se debe llegar
 * -> Posibilidades, es una lista de caminos por recorrer, los caminos
 *    se mantienen en orden inverso, con el estado mas reciente de primero.
 * <- Solucion es el camino que resuelve el problema
 */

bfs(Problema,[[Estado|Estados]|_],Solucion) :- 
	final(Problema,Estado),
    reverse([Estado|Estados],Solucion).

bfs(Problema,[Camino|Caminos],Solucion) :-
    extender(Problema,Camino,Nuevos),
    append(Caminos,Nuevos,Posibilidades),
    bfs(Problema,Posibilidades,Solucion).

extender(Problema,[Estado|Camino],Caminos) :-
    findall( [Proximo,Estado|Camino],
           ( (carril(Proximo,Estado);carril(Estado,Proximo)), 
	     (ciudadGrande(Proximo), Proximo = Problema -> true
	      ;ciudadPequena(Proximo) -> true),
	         \+ member(Proximo,[Estado|Camino])
           ),
           Caminos
         ),!.
extender(_,_,[]).

/*
 * predicado que verifica la condicion de finalizacion del bfs
 */
final(Problema,Estado):- Problema == Estado.
