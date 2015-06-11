pert(X,[X|_]).
pert(X,[_|L]):-pert(X,L).

pert_con_resto(X,L,Resto):-concat(L1,[X|L2],L), concat(L1,L2,Resto).

permutacion([],[]).
permutacion(L,[X|P]):-pert_con_resto(X,L,R), permutacion(R,P).

concat([],L,L).
concat([X|L1],L2,[X|L3]):-concat(L1,L2,L3).

long([], 0).
long([_|L], N):-long(L,N1), N is N1+1.

subcjt([],[]).							%subcjt(L,S) es: "S es un subconjunto de L".
subcjt([X|C],[X|S]):-subcjt(C,S).
subcjt([_|L],S):-subcjt(L,S).

cifras(L,N):-subcjt(L,S), permutacion(S,P), expresion(P,E), N is E, write(E), nl, !.

expresion([X],X).
expresion(L,E1+E2):-concat(L1,L2,L), L1\=[], L2\=[], expresion(L1,E1), expresion(L2,E2).
expresion(L,E1-E2):-concat(L1,L2,L), L1\=[], L2\=[], expresion(L1,E1), expresion(L2,E2).
expresion(L,E1*E2):-concat(L1,L2,L), L1\=[], L2\=[], expresion(L1,E1), expresion(L2,E2).
