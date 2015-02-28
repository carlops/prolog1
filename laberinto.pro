:-dynamic(punto/2).

leer(PuntosAbiertos,Nfil,Ncol):-
	write('Nombre Archivo: '),
	read(Archivo),
	open(Archivo,read,Fd),
	readNum(Fd,Ncol,[]),	
	leerLaberinto(Fd,[],PuntosAbiertos,0,Nfil,Ncol),
	close(Fd).
      
readNum(Fd,N,L):-  
	get_code(Fd,Char), 
	(addChar(Fd,Char,L,N)).

% Voltea la lista.
alReves(L1,L2) :- alReves1(L1,L2,[]).
alReves1([],L2,L2) :- !.
alReves1([X|Xs],L2,Acc):-alReves1(Xs,L2,[X|Acc]).

addChar(Fd,Char,L,N):-
	Char \== 10, % 10 es el fin de linea
	Char1 is Char-48, % los numeros empiezan en 48
	L1 = [Char1|L],
	readNum(Fd,N,L1).
addChar(Fd,Char,L,N):-
	Char=:=10, % se llego al fin de linea 
	alReves(LNum,L), % se voltea la lista
	charToNum(LNum,0,N). % se pasa de la lista de Char a un num 

% convertir lista de chars a un num
charToNum([C|Cs],Nactual,N):-
	Nnuevo is (Nactual*10)+C,
	charToNum(Cs,Nnuevo,N).
charToNum([],Nactual,N):- N=Nactual.

%Nc ira disminuyendo, F empieza en 0 y Nf obtendra su valor al llegar al final
leerLaberinto(Fd,PAactual,PuntosAbiertos,FilaActual,Nf,Nc):-
	get_code(Fd,Char),
	leerFila(Fd,PAactual,PAnuevo,FilaActual,0,Nc,Char),
	FilaSig is FilaActual+1,
	leerLaberinto(Fd,PAnuevo,PuntosAbiertos,FilaSig,Nf,Nc).
leerLaberinto(Fd,PAactual,PuntosAbiertos,FilaActual,Nf,_):-
	Nf is FilaActual,
	PuntosAbiertos=PAactual.

leerFila(Fd,PAactual,PA,F,ColActual,Nc,Char):-
	Char > 0,
	ColSig is ColActual +1,
	ColActual<Nc,
	(
	(Char=:=35,
	get_code(Fd,CharNuevo),
	leerFila(Fd,PAactual,PA,F,ColSig,Nc,CharNuevo)
	)
	;
	(Char=:=32,
	asserta(punto(F,ColActual)),
	get_code(Fd,CharNuevo),
	leerFila(Fd,[punto(F,ColActual)|PAactual],PA,F,ColSig,Nc,CharNuevo)
	)
	).
leerFila(Fd,PAactual,PA,_,_,_,Char):-
	Char > 0,
	PA=PAactual,!.

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

