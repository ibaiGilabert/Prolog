ciutats([paris,bangkok,montevideo,windhoek,male,delhi,reunion,lima,banff]).

interessos([paisatges,cultura,etnies,gastronomia,esport,relax]).

atractius( paris,     [cultura,gastronomia]      ).
atractius( bangkok,   [paisatges,relax,esport]   ).
atractius( montevideo,[gastronomia,relax]        ).
atractius( windhoek,  [etnies,paisatges]         ).
atractius( male,      [paisatges,relax,esport]   ).
atractius( delhi,     [cultura,etnies]           ).
atractius( reunion,   [esport,relax,gastronomia] ).
atractius( lima,      [paisatges,esport,cultura] ).
atractius( banff,     [esport,paisatges]         ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Prolog
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nat(0).
nat(N):- nat(N1), N is N1 + 1.

concat([],L,L).
concat([X|L1],L2,[X|L3]):-concat(L1,L2,L3).

subcjt([],[]).
subcjt([X|C],[X|S]):-subcjt(C,S).
subcjt([_|C],S):-subcjt(C,S).

remove_dups([], []).
remove_dups([X|L1], L2):-member(X,L1),remove_dups(L1, L2).
remove_dups([X|L1], [X|L2]):-not(member(X,L1)),remove_dups(L1, L2).

getInteressos([],[]).
getInteressos([X|S],C):-getInteressos(S,C1), atractius(X,C2), concat(C2,C1,C3), remove_dups(C3,C).

cities(S):-
	nat(Size), ciutats(N), interessos(M), subcjt(N,S), length(S, Size),
	getInteressos(S,I), length(I,Msize), length(M,Msize).

% Minim subset must be at least 3.

%paris + bangkok + windhoek
%[cultura,gastronomia] + [paisatges,relax,export] + [etnies,paisatges].
%[cultura, gastronomia, paisatges, relax, esport, etnies]

%bangkok + montevideo + delhi
%[paisatges,relax,esport] + [gastronomia,relax] + [cultura,etnies].
%[paisatges, relax, esport, gastronomia, cultura, etnies]
