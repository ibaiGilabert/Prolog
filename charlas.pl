datosEjemplo([[1,2,6],[1,6,7],[2,3,8],[6,7,9],[6,8,9],[1,2,4],[3,5,6],[3,5,7],
[5,6,8],[1,6,8],[4,7,9],[4,6,9],[1,4,6],[3,6,9],[2,3,5],[1,4,5],
[1,6,7],[6,7,8],[1,2,4],[1,5,7],[2,5,6],[2,3,5],[5,7,9],[1,6,8]]).

appendsinrepes(X, L, LS):- \+member(X,L), !, append([X],L,LS).
appendsinrepes(_, L, LS):- LS = L.

solucionOptimaTriples:- %minimo numero de charlas con el minimo de charlas tripitidas
	nat(NC), problemaCharlas(NC, _, _,_,_), !,
	nat(NT), problemaCharlas(NC, NT, A, B, C),
	write('Slot 1: '), write(A), nl, write('Slot 2: '), write(B), nl, write('Slot 3: '), write(C), nl,
	write('Numero total de charlas: '), write(NC), nl, write('Numero de charlas triples: '),  write(NT), nl.

solucionOptima:- %sin optimizar tripletas.
    nat(NC), % Buscamos solucion NC charlas.
	problemaCharlas(NC, NT, A, B, C),
	write('Slot 1: '), write(A), nl, write('Slot 2: '), write(B), nl, write('Slot 3: '), write(C), nl,
	write('Numero total de charlas: '), write(NC), nl, write('Numero de charlas triples: '),  write(NT), nl.

nat(0).
nat(N) :- nat(NA), N is NA+1.


problemaCharlas(NC, NT, A, B, C):- datosEjemplo(L), !, calcCharlas(L,[],[],[],A,B,C,NC), cuentaTriples(A,B,C,NT).

calcCharlas([], A,B,C,A,B,C, _).
calcCharlas([Charlas|L], A, B, C, AS, BS, CS, N):- member(Xa, Charlas), member(Xb, Charlas), Xa \= Xb,
									member(Xc, Charlas), Xa \= Xc, Xb \= Xc,
									appendsinrepes(Xa, A, A1), appendsinrepes(Xb, B, B1), appendsinrepes(Xc, C, C1),
									cuentaTotalCharlas(A1,B1,C1,NC), NC =< N,
									calcCharlas(L, A1, B1, C1, AS,BS,CS,N).

cuentaTriples([],_,_,N):- N = 0.
cuentaTriples([X|A],B,C, N):- member(X,B), member(X,C), !, cuentaTriples(A,B,C, N1), N is N1+1. 
cuentaTriples([_|A],B,C, N):- cuentaTriples(A,B,C, N).

cuentaTotalCharlas(A,B,C,N):- length(A,Na), length(B,Nb), length(C,Nc), N is Na+Nb+Nc.

