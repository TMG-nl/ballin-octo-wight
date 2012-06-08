%% EK Specific rules


% Higher rank means more points
greater(X,Y) :- points(X,P1), points(Y,P2), P1>=P2.

points_for_match(T1, T2, Points) :-
        points_for_match_310(T1, T2, Points).

decide_group_phase :-
        [utils],
        [league],
        current_prolog_flag(argv, Argv),
        last_element(Argv, Data),
        [Data],
        leagues(X), group_phase(X, Winners),
        write(Winners).
