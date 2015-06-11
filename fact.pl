%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% factorial
%%%%%%%%%%%%%%%%%%%%%%%%%%%
fact(0,1):-!.
fact(X,N):-X1 is X-1, fact(X1, N1), N is X*N1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% generador de naturales
%%%%%%%%%%%%%%%%%%%%%%%%%%%
nat(0).
nat(N):-nat(N1), N is N1+1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% minimo comun multiplo
%%%%%%%%%%%%%%%%%%%%%%%%%%%
mcm(X,Y,M):-nat(M), M>0, 0 is M mod X, 0 is M mod Y.
%mcm(X,Y,M):-nat(N), N>0, M is N*X, 0 is M mod Y. 			mas eficiente

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% factores primos
%%%%%%%%%%%%%%%%%%%%%%%%%%%

fact_prim(1,[]).
fact_prim(N,[F|L]):-nat(F), F>1, 0 is N mod F, N1 is N//F, fact_prim(N1,L),!.