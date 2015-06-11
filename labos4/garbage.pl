getElement([L1,_,_],1,L1).
getElement([_,L2,_],2,L2).
getElement([_,_,L3],3,L3).

getFirsts([],[]).
getFirsts([X|L],C):-getFirsts(L,C1), getElement(X,1,X1), concat([X1],C1,C).

getSeconds([],[]).
getSeconds([X|L],C):-getSeconds(L,C1), getElement(X,2,X2), concat([X2],C1,C).

getThirds([],[]).
getThirds([X|L],C):-getFirsts(L,C1), getElement(X,3,X3), concat([X3],C1,C).


% A is already sorted.
same_lists([],[]).
same_lists([X|L1],[Y|L2]):-X==Y, same_lists(L1,L2).

checkSlotA(A):-
		datosEjemplo(L), getFirsts(L,C),
		%write('List of firsts: '), write(C), nl,
		sort(C,S),
		%write('removed: '), write(S), nl,
		%write('Equality test with: '), write(A), write(' - '), write(S), nl,
		same_lists(S,A).
		%write('equals!'), nl.

checkSlotB(B):- datosEjemplo(L), getSeconds(L,C),
		sort(C,S), same_lists(S,B).
	
checkSlotC(C):- datosEjemplo(L), getThirds(L,C),
		sort(C,S), same_lists(S,C).

charla:-
	nat(N1), N1>0, list_of_nat(N1,LA), subcjt(LA,A), checkSlotA(A),
	nat(N2), N2>0, list_of_nat(N2,LB), subcjt(LB,B), checkSlotB(B),			
	nat(N3), N3>0, list_of_nat(N3,LC), subcjt(LC,C), checkSlotB(C),			
	write('Slot A: '), write(A),nl,
	write('Slot B: '), write(B),nl,
	write('Slot C: '), write(C),nl,!.
