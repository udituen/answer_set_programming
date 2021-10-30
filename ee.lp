% There is an elevator which transports passengers from their initial
% floors to their goal floors. There are three types of objects: the
% elevator, the passengers, and the floors. The elevator
% can move up and down to any floor. When it stops at a floor, any
% passenger in the elevator can be unboarded, and any passenger waiting
% at the floor can be boarded onto the elevator. The goal of the
% problem is to transport all the passengers to their destination
% floors.

state(0..steps).

#show board/3.
#show unboard/3.
#show up/4.
#show down/4.
%#show at/3.

%action board(P,F,T)

{board(P,F,T)}:-
   state(T), person(P), floor(F),
   at(P,F,T),
   at(lift,F,T),
   not affected(lift,T),
   not goal(T).

{unboard(P,F,T)}:-
   state(T), person(P), floor(F),
   in(lift,P,T),
   at(lift,F,T),
   not affected(lift,T),
   not goal(T).
 

{up(lift,From,To,T)}:-
%  state(T), floor(From), floor(To),
   above(To,From),
   at(lift,From,T),
   not goal(T).

{down(lift,From,To,T)}:-
%  state(T), floor(From), floor(To),
   above(From,To),
   at(lift,From,T),
   not goal(T).

above(From,To):-
   floor(From), floor(To),  % From and To are unsafe if commented out
   From > To.


%affected
change(P,T):- board(P,F,T).
change(P,T):- unboard(P,F,T).

affected(lift,T):-
   state(T), floor(From), floor(To),
   down(lift,From,To,T).
affected(lift,T):-
   state(T), floor(From), floor(To),
   up(lift,From,To,T).

%effects

at(lift,To,T+1):-
    state(T), floor(From), floor(To),
    down(lift,From,To,T).

at(lift,To,T+1):-
    state(T), floor(From), floor(To),
    up(lift,From,To,T).

in(lift,P,T+1):-
%   state(T), floor(F), person(P),
    board(P,F,T).

at(P,F,T+1):-
    state(T), floor(F), person(P),
    unboard(P,F,T).


%frame axioms

at(P,F,T+1):-
   state(T), person(P), floor(F),
   not change(P,T),
   at(P,F,T).

in(lift,P,T+1):-
   state(T), person(P),
   not change(P,T),
   in(lift,P,T).

at(lift,F,T+1):-
   state(T), floor(F),
   not affected(lift,T),
   at(lift,F,T).

%constraints things that shouldn't happen

:- up(lift,From,To,T), up(lift,From,To1,T), To != To1, floor(To1), floor(From).
:- up(lift,From,To,T), up(lift,From1,To,T), From != From1,
   floor(From1), floor(From).

:- down(lift,From,To,T), down(lift,From,To1,T), To != To1,
   floor(To1), floor(From).

:- down(lift,From,To,T), down(lift,From1,To,T), From != From1,
   floor(From1), floor(To), floor(From).


goal(T+1):- goal(T), state(T).
goal:- goal(T), state(T).
:- not goal.



