:-include(entradaRodear3).
%:-include(entradaSmallRodear3).
:-dynamic(varNumber/3).
symbolicOutput(0). % set to 1 to see symbolic output only; 0 otherwise.

writeClauses:-numSides, corners, hEdges, vEdges, points.

numSides:-num(I,J,K), sides(I,J,L), atLeast(K,L), atMost(K,L),fail.
numSides.

sides(I,J,L):- I2 is I+1, J2 is J+1, L=[h-I-J, h-I2-J, v-I-J, v-I-J2].

% alo K (out of 4).
atLeast(K,L):-subcjt(L,S), length(S,KL), KL is 5-K, writeClause(S),fail.
atLeast(_,_).

% amo generic
atMost(K,L):-subcjt(L,S), length(S,KL), KL is K+1, neg(S,C), writeClause(C),fail.
atMost(_,_).

% neg. the whole clause
neg([],[]).
neg([X|S],C):-neg(S,S2),concat([\+X],S2,C).

% corners
corners:-rows(N), columns(M), N2 is N+1, M2 is M+1,
	C1=[h-1-1,  v-1-1],  atMost(2,C1), notOne(C1),
	C2=[h-1-M,  v-1-M2], atMost(2,C2), notOne(C2),
	C3=[h-N2-1, v-N-1],  atMost(2,C3), notOne(C3),
	C4=[h-N2-M, v-N-M2], atMost(2,C4), notOne(C4).

% horizontal edges
hEdges:-rows(N), columns(M), M2 is M-1, between(1,M2,J), 
	J2 is J+1, E1=[h-1-J, h-1-J2, v-1-J2],    atMost(2,E1), notOne(E1),
	N2 is N+1, E2=[h-N2-J, h-N2-J2, v-N-J2],  atMost(2,E2), notOne(E2),fail.
hEdges.	


% vertical edges
vEdges:-rows(N), columns(M), N2 is N-1, between(1,N2,I),
	I2 is I+1, E3=[h-I2-1, v-I-1, v-I2-1],   atMost(2,E3), notOne(E3),
	M2 is M+1, E4=[h-I2-M, v-I-M2, v-I2-M2], atMost(2,E4), notOne(E4),fail.
	%M2 is M+1, E4=[h-I2-N, v-I-M2, v-I2-M2], atMost(2,E4), notOne(E4),fail.
vEdges.	

% 4-intersection vertex
points:-rows(N), columns(M), between(2,N,I), between(2,M,J),
	vertex(I,J,L), atMost(2,L), notOne(L), fail.
points.

vertex(I,J,L):- I2 is I-1, J2 is J-1, L=[h-I-J2, h-I-J, v-I2-J, v-I-J].

notOne([L1,L2]):-
	writeClause([\+L1, L2]),
	writeClause([\+L2, L1]).
notOne([L1,L2,L3]):-
	writeClause([\+L1, L2, L3]),
	writeClause([\+L2, L1, L3]),
	writeClause([\+L3, L1, L2]).
notOne([L1,L2,L3,L4]):-
	writeClause([\+L1, L2, L3, L4]),
	writeClause([\+L2, L1, L3, L4]),
	writeClause([\+L3, L1, L2, L4]),
	writeClause([\+L4, L1, L2, L3]).

%notOne(L):-subcjt(L,S), length(S,1), concat(S,R,L), concat(\+S,R,C), writeClause(C),fail.
%notOne(_).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

concat([],L,L).
concat([X|L1],L2,[X|L3]):-concat(L1,L2,L3).

subcjt([],[]).
subcjt([X|C],[X|S]):-subcjt(C,S).
subcjt([_|C],S):-subcjt(C,S).

pert_con_resto(X,L,Resto):-concat(L1,[X|L2],L), concat(L1,L2,Resto).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% DISPLAY SOLUTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
writeHeaderPS:-
    writeln('%!PS'),
    writeln('matrix currentmatrix /originmat exch def'),
    writeln('/umatrix {originmat matrix concatmatrix setmatrix} def'),
    writeln('[28.3465 0 0 28.3465 10.5 100.0] umatrix').

writeGrid:-
    writeln('0.01 setlinewidth'),
    writeVertGrid,
    writeHorizGrid.

writeVertGrid:-
    rows(R), columns(C), C1 is C+1,
    between(1,R,I), between(1,C1,J), drawVertical(I,J),fail.
writeVertGrid.

writeHorizGrid:-
    rows(R), columns(C), R1 is R+1,
    between(1,R1,I), between(1,C,J), drawHorizontal(I,J),fail.
writeHorizGrid.

drawVertical(I,J):-
    rows(R),columns(C),
    Size is min(22/R,18/C),
    X is 1+(J-1)*Size,
    Y is 23-(I-1)*Size,
    write(X), write(' '), write(Y), write(' moveto'),nl,
    Y1 is Y-Size,
    write(X), write(' '), write(Y1), write(' lineto'),nl,
    writeln('stroke').

drawHorizontal(I,J):-
    rows(R),columns(C),
    Size is min(22/R,18/C),
    X is 1+(J-1)*Size,
    Y is 23-(I-1)*Size,
    write(X), write(' '), write(Y), write(' moveto'),nl,
    X1 is X+Size,
    write(X1), write(' '), write(Y), write(' lineto'),nl,
    writeln('stroke').

writeNumbers:-
    num(I,J,K),
    writeNumber(I,J,K),
    fail.
writeNumbers.

writeNumber(I,J,K):-
    rows(R),columns(C),
    Size is min(22/R,18/C),
    X is 1+(J-1)*Size + 3*Size/7,
    Y is 23-(I-1)*Size - 5*Size/7,
    writeln('0.001 setlinewidth'),
    S is Size/2,
    write('/Times-Roman findfont '), write(S), writeln(' scalefont setfont'),
    write(X), write(' '), write(Y), write(' moveto ('), write(K), writeln(') show').

writeSolution([X|M]):-
    writeLine(X),
    writeSolution(M).
writeSolution([]).
    
writeLine(X):-num2var(X,h-I-J),!,
    rows(R), columns(C), T is max(R,C),
    W is 2/T,
    write(W), 
    writeln(' setlinewidth'),
    drawHorizontal(I,J).
writeLine(X):-num2var(X,v-I-J),!,
    rows(R), columns(C), T is max(R,C),
    W is 2/T,
    write(W), 
    writeln(' setlinewidth'),
    drawVertical(I,J).
writeLine(_).

displaySol(M):-
    tell('graph.ps'),
    writeHeaderPS,
    writeGrid,
    writeNumbers,
    writeSolution(M),
    writeln('showpage'),
    told.


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
