%% EK rules

greater(X,Y) :- points(X,P1), points(Y,P2), P1>=P2.

points_for_match(T1, T2, Points, Id) :-
        points_for_match_310(T1, T2, Points, Id).

decide_group_phase :-
        [utils], [league],
        current_prolog_flag(argv, Argv), last_element(Argv, Data), [Data],
        league(X), ranking(X, Ranking),
        write(Ranking).
