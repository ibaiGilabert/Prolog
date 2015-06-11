:-include(sud78).
:-dynamic(varNumber/3).
symbolicOutput(0). % set to 1 to see symbolic output only; 0 otherwise.

writeClauses:- atLeastOneValuePerSquare, atMostOneValuePerSquare, differentValueRow, differentValueCol, differentSubMatrixRow, differentSubMatrixCube, fillSudoku.

% at least
atLeastOneValuePerSquare:- between(1,9,I), between(1,9,J), 
	findall(x-I-J-K, between(1,9,K), C), writeClause(C), fail.
atLeastOneValuePerSquare.

% at most
atMostOneValuePerSquare:- between(1,9,I), between(1,9,J), between(1,9,K1), between(1,9,K2), K1<K2,
	writeClause( [ \+x-I-J-K1, \+x-I-J-K2 ] ), fail.
atMostOneValuePerSquare.

% row restriction
differentValueRow:- between(1,9,I), between(1,9,K), between(1,9,J1), between(1,9,J2), J1<J2,
	writeClause( [ \+x-I-J1-K, \+x-I-J2-K ] ), fail.
differentValueRow.

% column restriction
differentValueCol:- between(1,9,J), between(1,9,K), between(1,9,I1), between(1,9,I2), I1<I2,
	writeClause( [ \+x-I1-J-K, \+x-I2-J-K ] ), fail.
differentValueCol.

% 3x3 sub-matrix restriction (Row)
differentSubMatrixRow:- between(0,2,I), between(0,2,J), between(1,9,K), between(1,3,X), between(1,3,Y1), between(1,3,Y2), Y1<Y2,
	XM is 3*I+X, YM1 is 3*J+Y1, YM2 is 3*J+Y2,
	writeClause( [\+x-XM-YM1-K, \+x-XM-YM2-K] ), fail.
differentSubMatrixRow.

% 3x3 sub-matrix restriction (Cube)
differentSubMatrixCube:- between(0,2,I), between(0,2,J), between(1,9,K), between(1,3,Y), between(1,3,Z), between(1,3,X1), between(1,3,X2), X1<X2,
	XM1 is 3*I+X1, XM2 is 3*I+X2, YM1 is 3*J+Y, YM2 is 3*J+Z,
	writeClause( [\+x-XM1-YM1-K, \+x-XM2-YM2-K] ), fail.
differentSubMatrixCube.


% fill sudoku with input data
fillSudoku:-filled(I,J,K),
	writeClause([x-I-J-K]), fail.
fillSudoku.

% show results
displaySol([]).
displaySol(S):-
	%write('---------------------'),nl,
	concat([K1,K2,K3],W1,S),  num2var(K1, x-X1-Y1-Z1), write(Z1), write(' '), num2var(K2, x-X2-Y2-Z2), write(Z2), write(' '), num2var(K3, x-X3-Y3-Z3), write(Z3), write(' '),
	concat([K4,K5,K6],W2,W1), num2var(K4, x-X4-Y4-Z4), write(Z4), write(' '), num2var(K5, x-X5-Y5-Z5), write(Z5), write(' '), num2var(K6, x-X6-Y6-Z6), write(Z6), write(' '),
	concat([K7,K8,K9],W3,W2), num2var(K7, x-X7-Y7-Z7), write(Z7), write(' '), num2var(K8, x-X8-Y8-Z8), write(Z8), write(' '), num2var(K9, x-X9-Y9-Z9), write(Z9), nl,
	displaySol(W3).

concat([],L,L).
concat([X|L1],L2,[X|L3]):-concat(L1,L2,L3).

% ========== No need to change the following: =====================================

main:- symbolicOutput(1), !, writeClauses, halt. % escribir bonito, no ejecutar
main:-  assert(numClauses(0)), assert(numVars(0)),
	tell(clauses), writeClauses, told,
	tell(header),  writeHeader,  told,
	unix('cat header clauses > infile.cnf'),
	unix('picosat -v -o model infile.cnf'),
	unix('cat model'),
	see(model), readModel(M), seen, displaySol(M),
	halt.

var2num(T,N):- hash_term(T,Key), varNumber(Key,T,N),!.
var2num(T,N):- retract(numVars(N0)), N is N0+1, assert(numVars(N)), hash_term(T,Key),
	assert(varNumber(Key,T,N)), assert( num2var(N,T) ), !.

writeHeader:- numVars(N),numClauses(C),write('p cnf '),write(N), write(' '),write(C),nl.

countClause:-  retract(numClauses(N)), N1 is N+1, assert(numClauses(N1)),!.
writeClause([]):- symbolicOutput(1),!, nl.
writeClause([]):- countClause, write(0), nl.
writeClause([Lit|C]):- w(Lit), writeClause(C),!.
w( Lit ):- symbolicOutput(1), write(Lit), write(' '),!.
w(\+Var):- var2num(Var,N), write(-), write(N), write(' '),!.
w(  Var):- var2num(Var,N),           write(N), write(' '),!.
unix(Comando):-shell(Comando),!.
unix(_).

readModel(L):- get_code(Char), readWord(Char,W), readModel(L1), addIfPositiveInt(W,L1,L),!.
readModel([]).

addIfPositiveInt(W,L,[N|L]):- W = [C|_], between(48,57,C), number_codes(N,W), N>0, !.
addIfPositiveInt(_,L,L).

readWord(99,W):- repeat, get_code(Ch), member(Ch,[-1,10]), !, get_code(Ch1), readWord(Ch1,W),!.
readWord(-1,_):-!, fail. %end of file
readWord(C,[]):- member(C,[10,32]), !. % newline or white space marks end of word
readWord(Char,[Char|W]):- get_code(Char1), readWord(Char1,W), !.
%========================================================================================
