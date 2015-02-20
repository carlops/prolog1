carril(brussel,mechelen).
carril(brussel,antwerpen).
carril(brussel,gent).
carril(antwerpen,mechelen).
carril(antwerpen,gent).
carril(gent,brugge).

ciudad(X,L,N) :- 
	bagof(Y,(carril(X,Y);carril(Y,X)),L),
	%write(L),
	length(L,N).

ciudadPequena(X) :-
	ciudad(X,_,N),
	N>0, N<3.

ciudadGrande(X) :-
	ciudad(X,_,N),
	N>2.

buenaCiudad(X) :-
	ciudad(X,L,N),
	N==2,
	ciudadesGrandes(L,LG),
	write('trolololo'),
	write(LG),nl,
	length(LG,N),
	N>1. %AQUI ESTA VOLVIENDO SIEMPRE CON LG d tamano 1 en vez de buscarlas todas y luego regresar.

ciudadesGrandes(L,LG):-
	length(L,N),
	N>1,
	member(X,L),
	findall(X,ciudadGrande(X),LG). %LG tiene la lista de todas las ciudades grandes a las q X le llega directamente.

ciudadesGrandes(L,LG):-
	length(L,N),
	N>1,
	member(X,L),
	buenaCiudad(X). % intento del caso recursivo

% ciudadesGrandes(L,LG):-
%	

% ciudadesGrandes(X,[C|Cs],LCG):-
%	ciudadesGrandes(X,Cs,LCG).


