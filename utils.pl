%% Generic utilities

% Define "greater" for your own sorting
%greater(X,Y) :- X > Y.

insert_sort(List,Sorted):-i_sort(List,[],Sorted).
i_sort([],Acc,Acc).
i_sort([H|T],Acc,Sorted):-insert(H,Acc,NAcc),i_sort(T,NAcc,Sorted).

insert(X,[Y|T],[Y|NT]):-not(greater(X,Y)),insert(X,T,NT).
insert(X,[Y|T],[X,Y|T]):-greater(X,Y).
insert(X,[],[X]).

sum([], 0).
sum([H|T], S) :- sum(T,H1), S is H1+H.

last_element([A], A).
last_element([_ | Tail], A) :- last_element(Tail, A).

len([], 0).
len([_ | Tail], Len) :- len(Tail, Ltail), Len is Ltail + 1.


