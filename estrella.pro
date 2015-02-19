/*
 *  CUADRADOS MAGICOS
 *
 */

:- public(estrella/1).

estrella(Lista):-
	Lista = [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P],
	fd_all_different(Lista), % Hace todos las variables tomen diferentes valors
	%fd_domain(Lista,1,16),
	%fd_labeling(Lista),  % Le da valores a las variables y aplica backtracking cambiandolas

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

