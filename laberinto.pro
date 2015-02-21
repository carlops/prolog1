
leer(PA,Nfil,Ncol):-
	write('Nombre Archivo: '),
	read(Archivo),
	open(Archivo,read,Fd),
	readNum(Fd,Ncol,[]),	
	write(Ncol),nl,
	get_char(Fd,Char),
	write(Char),
	close(Fd).
      
readNum(Fd,N,Y):-  
	get_code(Fd,C), 
	(addChar(Fd,C,Y);alReves(Z,Y),write(Z),nl,charToNum(Z,0,N)),!. %N tendra el num pero por alguna razon sigue haciendo cosas y lo pierde.  

% esto solo voltea la lista.
alReves(L1,L2) :- alReves1(L1,L2,[]).
alReves1([],L2,L2) :- !.
alReves1([X|Xs],L2,Acc):-alReves1(Xs,L2,[X|Acc]).

addChar(Fd,C,Y):-
	C \== 10, % 10 parece ser el fin de linea (en ubuntu al menos)
	C1 is C-48, % los numeros empiezan en 48
	Y1 = [C1|Y],
	write(Y1),
	readNum(Fd,N,Y1).

% intento de convertir lista con char a un num
charToNum([C|Cs],Na,N):-
	N1 is (Na*10)+C,
	charToNum(Cs,N1,N).
%	N=N1.
charToNum([],Na,N):-N=Na.
	
/*
leerLaberinto(PA,Nf,Nc):-
	readLn(Linea),
	length(Linea,Nf).
*/
