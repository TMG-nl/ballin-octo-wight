round_1([[a,b],[c,d],[e,f],[g,h]]).

match_played(a,b,2,3).
match_played(c,d,5,3).
match_played(e,f,2,3).
match_played(g,h,6,3).


next_round([], []).
next_round([[T1,T2]|Rest], NextRound) :- next_round(Rest, N2), winnerOf(T1, T2, T3), NextRound = [T3 | N2].


winnerOf(T1, T2, T1) :- match_played(T1, T2, S1, S2), S1>S2.
winnerOf(T1, T2, T2) :- match_played(T1, T2, S1, S2), S2>S1.