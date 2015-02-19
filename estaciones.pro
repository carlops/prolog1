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
	N>0,N<3,
	ciudadesGrandes(L,LG),
	write(LG).

ciudadesGrandes(L,LG):-
	elem(L,X),
	findall(X,ciudadGrande(X),LG).
	%ciudadesGrandes(X,Cs,[C|LCG]).



% ciudadesGrandes(X,[C|Cs],LCG):-
%	ciudadesGrandes(X,Cs,LCG).


