matched_played_knockout(d,b,2,3).
matched_played_knockout(h,f,5,3).
matched_played_knockout(l,j,2,3).
matched_played_knockout(p,n,6,3).

matched_played_knockout(b,h,6,3).
matched_played_knockout(j,p,5,2).
matched_played_knockout(b,j,1,2).

next_round([], []).
next_round([[T1,T2], [N1,N2] | Rest], NextRound) :- next_round(Rest, NextRoundRest),
					 	    winnerOf(T1, T2, T3),
					 	    winnerOf(N1, N2, N3),
					 	    NextRound = [[T3, N3] | NextRoundRest].

winner([[A, B]], C) :- winnerOf(A, B, C).
winner(CurrentRound, Winner) :- next_round(CurrentRound, NextRound), winner(NextRound, Winner).

winnerOf(T1, T2, T1) :- matched_played_knockout(T1, T2, S1, S2), S1>S2.
winnerOf(T1, T2, T2) :- matched_played_knockout(T1, T2, S1, S2), S2>S1.
