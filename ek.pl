%% EK Specific rules


% Higher rank means more points
greater(X,Y) :- points(X,P1), points(Y,P2), P1>=P2.

% Feeding group phase into knockout
first_knockout_round([[A, B], [C, D], [E, F], [G, H]], Round) :-
             Round = [[A, D], [E, H], [B, C], [F, G]].

points_for_match(T1, T2, Points) :-
        points_for_match_310(T1, T2, Points).

decide_group_phase :-
        [utils],
        [league],
        current_prolog_flag(argv, Argv),
        last_element(Argv, Data),
        [Data],
        leagues(X), group_phase(X, Winners),
        first_knockout_round(Winners, FirstKnockoutRound),
        write(FirstKnockoutRound).

decide_next_knockout_round :-
        [utils],
        [knockout],
        current_prolog_flag(argv, Argv),
        last_element(Argv, Data),
        [Data],
        round(X),
        (
         (len(X, 1), winner(X, Next));
         (next_round(X, Next))
        ),
        write(Next).

