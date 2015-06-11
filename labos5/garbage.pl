:-include(entrada).
:-dynamic(varNumber/3).
symbolicOutput(0). % set to 1 to see symbolic output only; 0 otherwise.

% Vars represents: "Attractive i in City j"

writeClauses:-atLeastOneInterest, differentCities.

% at least 1 city for each attractive
atLeastOneInterest:-
	interessos(N), length(N,Nsize), ciutats(M), length(M, Msize),
	between(1,Nsize,I),findall(x-I-J, between(1,Msize,J), C), writeClause(C), fail.
atLeastOneInterest.

%
differentCities:-atractius(X,L), list_of_interests(N), 
		%write('List of interests: '), write(N), nl,
		remove_interests(N,L,C), numCity(X,J), 
		%write('Interests NOT in city '), write(X), write('('), write(J), write(')'), write(' -> '), write(C), nl,
		writeNot(J,C), fail.	
differentCities.

writeNot(_,[]).
writeNot(J,[I|L]):-writeClause([\+x-I-J]), writeNot(J,L).

list_of_nat(0,[]).
list_of_nat(N,L):-N2 is N-1, list_of_nat(N2,L2), concat(L2,[N],L),!.
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																		
% city numbers [1..9]
list_of_cities(L):-ciutats(N), length(N,Nsize), list_of_nat(Nsize,L).

% Number of attractives [1..6]
list_of_interests(L):-interessos(M), length(M,Msize), list_of_nat(Msize,L).

remove_it([_|L],1,L).
remove_it([X|L],N,[X|S]):-N1 is N-1, remove_it(L,N1,S).

%remove_cities(N,[],N).
%remove_cities(N,[X|L],C):-remove_cities(N,L,C1), numCity(X,X1),
%				write('City: '), write(X), write(' -> #'), write(X1), nl,
%				remove_it(C1,X1,C).

remove_interests(N,[],N).
remove_interests(N,[X|L],C):-remove_interests(N,L,C1), numInterests(X,X1),
				remove_it(C1,X1,C).


indexOf([X|_], X, 1):- !.
indexOf([_|L], X, Pos):-indexOf(L, X, Pos1),!,Pos is Pos1+1.

numCity(X,N):-ciutats(L), indexOf(L,X,N).

numInterests(X,N):-interessos(L), indexOf(L,X,N).


% show results
displaySol([]).
displaySol(S):-
	concat([K],L,S), num2var(K, x-X-Y), 
	write('Interest: '), write(X), write(' in City '), nameCity(Y,C), write(C), nl,
	displaySol(L).

nameCity(1,paris).
nameCity(2,bangkok).
nameCity(3,montevideo).
nameCity(4,windhoek).
nameCity(5,male).
nameCity(6,delhi).
nameCity(7,reunion).
nameCity(8,lima).
nameCity(9,banff).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

concat([],L,L).
concat([X|L1],L2,[X|L3]):-concat(L1,L2,L3).

subcjt([],[]).
subcjt([X|C],[X|S]):-subcjt(C,S).
subcjt([_|C],S):-subcjt(C,S).

pert_con_resto(X,L,Resto):-concat(L1,[X|L2],L), concat(L1,L2,Resto).


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
