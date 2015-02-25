:-dynamic(punto/2).

leer(PA,Nfil,Ncol):-
	write('Nombre Archivo: '),
	read(Archivo),
	open(Archivo,read,Fd),
	readNum(Fd,Ncol,[]),	
	leerLaberinto(Fd,[],PA,0,Nf,Ncol),
	Nfil is Nf-1,
	%alReves(PA,Pa),
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

leerLaberinto(Fd,PAa,PA,F,Nf,_):-
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
	leerFila(Fd,[punto(F,Ca)|PAa3],PAa2,F,Ca2,Nc,C1)
	)
	).

leerFila(Fd,PAa3,PAa2,_,_,_,C):-
	C > 0,
	PAa2=PAa3,!.

resolver(PuntosAbiertos,F,C,Solucion):- 
	leer(PuntosAbiertos,F,C),
	Cfinal is C-1,
	%Finales=punto(X,Cfinal),
	puntosFinales(Finales,Cfinal,[],0,F),
	!,
	bfs(Finales,[[punto(0,0)]],Solucion),
	escribir(Solucion,PuntosAbiertos,F,C).

puntosFinales(Finales,Colfinal,L,F,Nf):-
	Nf=:=F,
	Finales=L.

puntosFinales(Finales,Colfinal,L,F,Nf):-
	Sig is F+1,
	(
	(punto(F,Colfinal),
	puntosFinales(Finales,Colfinal,[punto(F,Colfinal)|L],Sig,Nf) )
	;
	puntosFinales(Finales,Colfinal,L,Sig,Nf)
	).

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

escribir(Sol,Pa,F,C):-
	escribirAux(Sol,Pa,0,0,F,C).

escribirAux(Sol,Pa,Fact,Cact,F,C):-
	Cact=:=C,
	Fsig is Fact+1,
	write('\n'),
	escribirAux(Sol,Pa,Fsig,0,F,C).

escribirAux(Sol,Pa,Fact,Cact,F,C):-
	Fact=:=F.

escribirAux(Sol,Pa,Fact,Cact,F,C):-
	member(punto(Fact,Cact),Sol),
	write('.'),
	Csig is Cact+1,
	escribirAux(Sol,Pa,Fact,Csig,F,C).

escribirAux(Sol,Pa,Fact,Cact,F,C):-
	member(punto(Fact,Cact),Pa),
	write(' '),
	Csig is Cact+1,
	escribirAux(Sol,Pa,Fact,Csig,F,C).

escribirAux(Sol,Pa,Fact,Cact,F,C):-
	write('#'),
	Csig is Cact+1,
	escribirAux(Sol,Pa,Fact,Csig,F,C).

