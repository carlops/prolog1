:-dynamic(punto/2).

leer(PA,Nfil,Ncol):-
	write('Nombre Archivo: '),
	read(Archivo),
	open(Archivo,read,Fd),
	readNum(Fd,Ncol,[]),	
	leerLaberinto(Fd,[],Pa,0,Nf,Ncol),
	Nfil is Nf-1,
	alReves(PA,Pa),
	close(Fd).
      
readNum(Fd,N,Y):-  
	get_code(Fd,C), 
	(addChar(Fd,C,Y,N)).

% esto solo voltea la lista.
alReves(L1,L2) :- alReves1(L1,L2,[]).
alReves1([],L2,L2) :- !.
alReves1([X|Xs],L2,Acc):-alReves1(Xs,L2,[X|Acc]).

addChar(Fd,C,Y,N):-
	C \== 10, % 10 parece ser el fin de linea (en ubuntu al menos)
	C1 is C-48, % los numeros empiezan en 48
	Y1 = [C1|Y],
	readNum(Fd,N,Y1).
addChar(Fd,C,Y,N):-
	C=:=10,
	alReves(Z,Y),
	charToNum(Z,0,N).

% convertir lista de chars a un num
charToNum([C|Cs],Na,N):-
	N1 is (Na*10)+C,
	charToNum(Cs,N1,N).
charToNum([],Na,N):-N=Na.

%Nc ira disminuyendo, F empieza en 0 y Nf obtendra su valor al llegar a end_of_file o Nc=:=0
leerLaberinto(Fd,PAa,PA,F,Nf,Nc):-
	get_code(Fd,C),
	leerFila(Fd,PAa,PAa2,F,0,Nc,C),
	F2 is F+1,
	leerLaberinto(Fd,PAa2,PA,F2,Nf,Nc).

leerLaberinto(_,PAa,PA,F,Nf,_):-
	Nf is F+1,
	PA=PAa.

leerFila(Fd,PAa3,PAa2,F,Ca,Nc,C):-
	C > 0,
	Ca2 is Ca +1,
	Ca<Nc,
	(
	(C=:=35,
	get_code(Fd,C1),
	leerFila(Fd,PAa3,PAa2,F,Ca2,Nc,C1)
	)
	;
	(C=:=32,
	asserta(punto(F,Ca)),
	get_code(Fd,C1),
	leerFila(Fd,[punto(Ca,F)|PAa3],PAa2,F,Ca2,Nc,C1)
	)
	).

leerFila(_,PAa3,PAa2,_,_,_,C):-
	C > 0,
	PAa2=PAa3.

%punto(0,0). punto(1,0). punto(1,1).
%punto(1,2). punto(1,3). punto(1,4).
%punto(1,5). punto(1,6). punto(2,6).
%punto(3,6). punto(4,6). punto(5,6).
%punto(6,6). punto(7,6). punto(8,6).
%punto(8,7). punto(8,8). punto(9,8).
%punto(9,9).

/*
 * soluciones(Columna,Llegada).
 *
 * 	-> Columna es cantidad de columnas
 *	<- Llegada es la lista de puntos abiertos, en la columna dada
 *
 */
soluciones(N,L):-
	N>0,
	N1 is N-1,
	findall(X, X = punto(_,N1),L).

/*
 * bfs(Finales,Movimientos,Solucion).
 *
 *	-> Finales, es la lista de los puntos abiertos finales
 *	-> Movimientos, es la lista de caminos posibles, se lleva 
 *	    en orden inverso, es decir, el punto mas reciente de primero
 *	<- Solucion, es la lista con el camino que lleva a la solucion
 *
 */ 
bfs(Problema,[[Estado|Estados]|_],Solucion) :- 
	final(Problema,Estado),
    reverse([Estado|Estados],Solucion).

bfs(Problema,[Camino|Caminos],Solucion) :-
    extender(Problema,Camino,Nuevos),
    append(Caminos,Nuevos,Posibilidades),
    bfs(Problema,Posibilidades,Solucion).

extender(Problema,[punto(X,Y)|Camino],Caminos) :-
    findall( [Proximo,punto(X,Y)|Camino], 
    	   ( Y1 is Y-1,Y2 is Y+1,X1 is X-1,X2 is X+1,
           ( (punto(X,Y1),Proximo=punto(X,Y1);punto(X,Y2),Proximo = punto(X,Y2);
	      punto(X1,Y),Proximo=punto(X1,Y);punto(X2,Y),Proximo=punto(X2,Y))),
	         \+ member(Proximo,[punto(X,Y)|Camino])
           ),
           Caminos
         ),!.
extender(_,_,[]).

final(Problema,Estado):- member(Estado,Problema).
