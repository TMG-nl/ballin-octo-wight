insert_sort(List,Sorted):-i_sort(List,[],Sorted).
i_sort([],Acc,Acc).
i_sort([H|T],Acc,Sorted):-insert(H,Acc,NAcc),i_sort(T,NAcc,Sorted).
   
insert(X,[Y|T],[Y|NT]):-not(more_points(X,Y)),insert(X,T,NT).
insert(X,[Y|T],[X,Y|T]):-more_points(X,Y).
insert(X,[],[X]).


sum([], 0).
sum([H|T], S) :- sum(T,H1), S is H1+H.





more_points(X,Y) :- points(X,P1), points(Y,P2), P1>=P2.


ranking(Result) :- teams(X),insert_sort(X, Result).


points_for_match(T1, T2, 3) :- match_played(T1, T2, S1, S2), S1>S2;
                               match_played(T2, T1, S2, S1), S1>S2.
points_for_match(T1, T2, 1) :- match_played(T1, T2, S1, S2), S1=S2;
			       match_played(T2, T1, S2, S1), S2=S1.
points_for_match(T1, T2, 0) :- match_played(T1, T2, S1, S2), S1<S2;
			       match_played(T2, T1, S2, S1), S1<S2.


points(Team, Points):- findall(P, points_for_match(Team,_,P), Y), sum(Y, Points).






teams([a,b,c,d]).

match_played(a,b,2,3).
match_played(a,c,2,4).
match_played(a,d,2,5).
match_played(b,c,4,3).
match_played(b,d,3,3).
match_played(c,d,5,7).



:- points_for_match(d,b,1).
:- points_for_match(a,b,0).
:- points_for_match(b,a,3).
:- points_for_match(b,d,1).
