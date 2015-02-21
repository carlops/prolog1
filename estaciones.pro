%carril(brussel,mechelen).
%carril(brussel,antwerpen).
%carril(brussel,gent).
%carril(antwerpen,mechelen).
%carril(antwerpen,gent).
%carril(gent,brugge).

carril(brussel,charleroi).
carril(brussel,haacht).
carril(haacht,mechelen).
carril(mechelen,berchem).
carril(berchem,antwerpen).
carril(brussel,boom).
carril(boom,antwerpen).
carril(antwerpen,turnhout).

ciudad(X,L,N) :- 
	bagof(Y,(carril(X,Y);carril(Y,X)),L),
	%write(L),
	length(L,N).

ciudadPequena(X) :-
	ciudad(X,_,N),
	N<3.

ciudadGrande(X) :-
	ciudad(X,_,N),
	N>2.

buenaCiudad(X,N1) :-
	ciudad(X,L,N),
	N==2,
	ciudadesGrandes(L,LG,Lr,0,N1),
	ciudadesGrandes(Lr,LG2,_,0,N2),
	N1=:=N2.
%	write('trolololo'),
%	write(LG),nl,
%	write(LG2),nl,
%	length(LG,N3),
%	length(LG2,N4),
	
	%N3>1. %AQUI ESTA VOLVIENDO SIEMPRE CON LG d tamano 1 en vez de buscarlas todas y luego regresar.

ciudadesGrandes(L,LG,Lr,Na,Nf):-
	length(L,N),
	N>1,
	select(X,L,L1),
	findall(X,ciudadGrande(X),LG),
	Nf is Na+1. %LG tiene la lista de todas las ciudades grandes a las q X le llega directamente.

ciudadesGrandes(L,LG,Na,Nf):-
	length(L,N),
	N>1,
	member(X,L),
	Na2 is Na + 1,
	ciudadesGrandes(L,LG,Na2,Nf).

estacion(X):-
	buenaCiudad(X,N1),
	%findall(Y,buenaCiudad(Y,N1),Bcs),
	write(N1).
%menorDistancia(Bcs).


% N>0, % buenaCiudad(X). % intento del caso recursivo

% ciudadesGrandes(L,LG):-
%	

% ciudadesGrandes(X,[C|Cs],LCG):-
%	ciudadesGrandes(X,Cs,LCG).


