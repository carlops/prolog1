
leer(PA,Nfil,Ncol):-
	write('Nombre Archivo: '),
	read(Archivo),
	open(Archivo,read,Fd),
	readNum(Fd,Ncol,[]),	
	%write(Ncol),nl,
	leerLaberinto(Fd,[],PA,0,Nfil,Ncol),
	write(PA),
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
	leerFila(Fd,PAa,PAa2,F,0,Nc),
	F2 is F+1,
	leerLaberinto(Fd,PAa2,PA,F2,Nf,Nc).

leerLaberinto(_,PAa,PA,F,Nf,Nc):-
	write('HOLA'),write(PAa),write(PA),nl,
	Nf is F+1,
	PA=PAa.

leerFila(Fd,PAa3,PAa2,F,Ca,Nc):-
	get_code(Fd,C),
	Ca2 is Ca +1,
	write('Here'),
	Ca<Nc,
	(
	(C=:=35,
	leerFila(Fd,PAa3,PAa2,F,Ca2,Nc)
	)
	;
	(C=:=32,
	leerFila(Fd,[(F,Ca)|PAa3],PAa2,F,Ca2,Nc)
	)
	;(C=:= -1
	%finLaberinto(Fd,PAa,PA,F,Nf,Nc),
	)
	)
	.

leerFila(_,PAa3,PAa2,_,_,_):-
	PAa2=PAa3.

finLaberinto(_,PAa,PA,F,Nf,Nc):-
	write('HOLA'),write(PAa),write(PA),nl,
	Nf is F+1,
	PA=PAa.

