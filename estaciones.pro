%carril(brussel,mechelen).
%carril(brussel,antwerpen).
%carril(brussel,gent).
%carril(antwerpen,mechelen).
%carril(antwerpen,gent).
%carril(gent,brugge).

carril(brussel,charleroi).
carril(brussel,haacht).
carril(antwerpen,boom).
carril(haacht,mechelen).
carril(mechelen,berchem).
carril(berchem,antwerpen).
carril(brussel,boom).
carril(antwerpen,turnhout).

ciudad(X,L,N) :- 
	bagof(Y,(carril(X,Y);carril(Y,X)),L),
	length(L,N).

ciudadPequena(X) :-
	ciudad(X,_,N),
	N<3.

ciudadGrande(X) :-
	ciudad(X,_,N),
	N>2.

buenaCiudad(X,N1) :-
	ciudad(X,L,N),
	N==2, % X va a ser una ciudad pequena
	ciudadGrande(C1),
	ciudadGrande(C2),
	C1 \== C2,
	bfs(C1,[[X]],Camino1), length(Camino1,N1),
	bfs(C2,[[X]],Camino2), length(Camino2,N2),
	N1==N2. % el bfs va a encontrar el mas pequenio de primero.
%	write(Camino1),nl,
%	write(Camino2),nl,
%	write(N1).

estacion(X):-
	buenaCiudad(X,N1),!.


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
	     (ciudadGrande(Proximo)-> Proximo == Problema),
            % movimiento(Problema,Estado,Movimiento),
  	    %     moverse(Problema,Estado,Movimiento,Proximo),
  	     %    legal(Problema,Proximo),
	         \+ member(Proximo,[Estado|Camino])
           ),
           Caminos
         ),!.
extender(_,_,[]).

final(Problema,Estado):- Problema == Estado.
