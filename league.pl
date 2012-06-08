#!/usr/bin/env swipl -q -s

ranking(League, Result) :- insert_sort(League, Result).

points_for_match_310(T1, T2, 3, Id) :-
        match_played(T1, T2, S1, S2, Id), S1>S2;
        match_played(T2, T1, S2, S1, Id), S1>S2.
points_for_match_310(T1, T2, 1, Id) :-
        match_played(T1, T2, S1, S2, Id), S1=S2;
        match_played(T2, T1, S2, S1, Id), S2=S1.
points_for_match_310(T1, T2, 0, Id) :-
        match_played(T1, T2, S1, S2, Id), S1<S2;
        match_played(T2, T1, S2, S1, Id), S1<S2.

points(Team, Points):- findall(P, points_for_match(Team,_,P, Id), Y), sum(Y, Points).

group_phase([], []).
group_phase([FirstLeague | Rest], Winners) :- group_phase(Rest, NextWinners), 
					ranking(FirstLeague, [First, Second | _]),
					Winners = [[First, Second] | NextWinners].






%:- leagues(X), group_phase(X, Winners).

%% Test data
% leagues([
% [a, b, c, d],
% [e, f, g, h],
% [i, j, k, l],
% [m, n, o, p]
% ]).

% match_played(a,b,2,3).
% match_played(a,c,2,4).
% match_played(a,d,2,5).
% match_played(b,c,4,3).
% match_played(b,d,3,3).
% match_played(c,d,5,7).

% match_played(e,f,2,3).
% match_played(e,g,2,4).
% match_played(e,h,2,5).
% match_played(f,g,4,3).
% match_played(f,h,3,3).
% match_played(g,h,5,7).

% match_played(i,j,2,3).
% match_played(i,k,2,4).
% match_played(i,l,2,5).
% match_played(j,k,4,3).
% match_played(j,l,3,3).
% match_played(k,l,5,7).

% match_played(m,n,2,3).
% match_played(m,o,2,4).
% match_played(m,p,2,5).
% match_played(n,o,4,3).
% match_played(n,p,3,3).
% match_played(o,p,5,7).


% :- points_for_match(d,b,1).
% :- points_for_match(a,b,0).
% :- points_for_match(b,a,3).
% :- points_for_match(b,d,1).
