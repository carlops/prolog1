% Autores:
% Alejandro Guevara carnet: 09-10971
% Carlo Polisano    carnet: 09-1067

/*
 *  ESTRELLAS MAGICAS
 *	
 *	Resuelve el problema de estrellas magicas de 8 puntas.
 *
 *	Consiste en un predicado estrella/1, el cual espera una lista y triunfa
 *	 si la lista corresponde a una estrella magica valida de 8 puntas.
 *
 *	El predicado es puro, lo que al ser consultado sin unificar el enumera
 *	 todas las posibles estrellas magicas de 8 puntas.
 */

:- public(estrella/1).

/*  estrella/1
 *	
 *	Consiste basicamente crear una lista Dominio, que posee los numeros
 *	 del 1 hasta el 16, y de alli ir asignando valores a las variables 
 *	 de Lista via backtraking, utilizando el predicado 'select' ya que este
 *	 ademas de proporsionarnos una elemento de la lista dada, nos provee
 *	 una lista con los elementos anteriores sin el que acaba de seleccionar
 *	 evitando asi la repeticion de valores dentro una misma estrella.
 *
 *	Ademas, se realizan asignaciones de 4 en 4, de variables de Lista, y se 
 *	 procede a verificar las cuentas necesarias con dichas variables, para 
 *	 asi ganar un poco de velocidad en encontrar asignaciones correctas, 
 *	 en vez de darle valores a todas las variables y despues proceder a
 *	 los calculos.
 */
estrella(Lista):-
	Lista = [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P],
	fd_all_different(Lista), % Hace todos las variables tomen diferentes valors

	Dominio = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],
	
	select(B1,Dominio,L1), B = B1,
	select(C1,L1,L2), C = C1,
	select(D1,L2,L3), D = D1,
	select(E1,L3,L4), E = E1,
	B+C+D+E=:=34,

	select(H1,L4,L5), H = H1,
	select(F1,L5,L6), F = F1,
	select(A1,L6,L7), A = A1,
	H+F+C+A=:=34,

	select(I1,L7,L8), I = I1,
	select(G1,L8,L9), G = G1,
	A+D+G+I=:=34,

	select(P1,L9,L10), P = P1,
	select(M1,L10,L11), M = M1,
	select(J1,L11,L12), J = J1,
	H+J+M+P=:=34,

	select(K1,L12,L13), K = K1,
	select(N1,L13,L14), N = N1,
	I+K+N+P=:=34,

	select(La1,L14,L15), L = La1,
	B+F+J+L=:=34,

	select(O1,L15,L16), O = O1,
	E+G+K+O=:=34,
	L+M+N+O=:=34.

