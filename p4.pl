datosEjemplo([	[1,2,6],[1,6,7],[2,3,8],[6,7,9],[6,8,9],[1,2,4],[3,5,6],[3,5,7],
		[5,6,8],[1,6,8],[4,7,9],[4,6,9],[1,4,6],[3,6,9],[2,3,5],[1,4,5],
		[1,6,7],[6,7,8],[1,2,4],[1,5,7],[2,5,6],[2,3,5],[5,7,9],[1,6,8]	]).

nat(0).
nat(N) :- nat(NA), N is NA+1.

concat([],L,L).
concat([X|L1],L2,[X|L3]):-concat(L1,L2,L3).

concatNoRepeat(X, L, C):- \+member(X,L),!,concat([X],L,C).
concatNoRepeat(_, L, L).

checkSlots(_,[],A,B,C,A,B,C).
checkSlots(N,[X|L],A,B,C,SA,SB,SC):- 	member(Xa,X), member(Xb,X), Xa \= Xb, member(Xc,X), Xa \= Xc, Xb \= Xc,
					concatNoRepeat(Xa,A,A1), concatNoRepeat(Xb,B,B1), concatNoRepeat(Xc,C,C1),
					length(A1,NA), length(B1,NB), length(C1,NC), N2 is NA+NB+NC, N2=<N,
					checkSlots(N,L,A1,B1,C1,SA,SB,SC).

triples([],_,_,0).
triples([X|A],B,C,S):-member(X,B), member(X,C), triples(A,B,C,S1), S is S1+1.
triples([_|A],B,C,S):-triples(A,B,C,S).


charlas:-
	nat(N), datosEjemplo(L),
	checkSlots(N,L,[],[],[], A, B, C),
	write('Slot 1: '), write(A), nl, 
	write('Slot 2: '), write(B), nl,
	write('Slot 3: '), write(C), nl, nl,
	write('#charlas: '), write(N), nl,
	triples(A,B,C,NT),
	write('#charlas triples: '),  write(NT), nl,!.

charlasExt:-
	datosEjemplo(L),
	nat(NC), checkSlots(NC,L,[],[],[],_,_,_), !,
	nat(NT), checkSlots(NC,L,[],[],[],A,B,C), triples(A,B,C,NT),
	write('Slot 1: '), write(A), nl, 
	write('Slot 2: '), write(B), nl, 
	write('Slot 3: '), write(C), nl, nl,
	write('#charlas: '), write(NC), nl, 
	write('#charlas triples: '), write(NT), nl,!.


