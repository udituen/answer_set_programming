boolean(t;f).
object(monkey;bananas;box).
location(r1,p1;r1,p2;r1,p3;r1,p4;r2,q1;r2,q2).


% preconditions

% if monkey has bananas, it means monkey is in same location as banana
loc(bananas,L,T) :- hasBananas(t,T), loc(monkey,L,T). 

% if monkey is at location it means he is on the chair in the location of the chair
loc(monkey,L,T) :- onBox(t,T), loc(box,L,T).



% walk

loc(monkey,L,T+1) :- walk(L,T).
% if monkey is in location or on chair. then he is not waking
:- walk(L,T),loc(monkey,L,T). 
:- walk(L,T), onBox(t,T).

% pushBox

loc(box,L,T+1) :- pushBox(L,T).
loc(monkey,L,T+1) :- pushBox(L,T).
:- pushBox(L,T), loc(monkey,L,T).
:- pushBox(L,T), onBox(t,T).
:- pushBox(L,T), loc(monkey,L1,T), loc(box,L2,T), L1 !=L2.


% climbOn

onBox(t, T+1) :- climbOn(T).
:- climbOn(T), onBox(t,T).
:- climbOn(T), loc(monkey,L1,T).

% climboff

onBox(f, T+1) :- climbOff(T).
:- climbOff(T), onBox(f,T).

% grasp Bananas

hasBananas(t,T+1) :- graspBananas(T).
:- graspBananas(T), hasBananas(t,T).
:- graspBananas(T), onBox(f,T).
:- graspBananas(T), loc(monkey, L1,T), loc(bananas,L2,T), L1 != L2.

% disallow

:- walk(L,T), pushBox(L,T).
:- walk(L,T),climbOn(T).
:- pushBox(L,T),climbOn(T).
:- climbOff(T), graspBananas(T).

% fluents

1 {hasBananas(BB,0) : boolean(BB)} 1.
1 {onBox(BB,0) : boolean(BB)} 1.
1 {loc(0,LL,0) : location(LL)} 1 :- object(0).



% actions

{walk(L,T)} :- location(L), T= 0..m-1.
{pushBox(L,T)} :- location(L), T= 0..m-1.
{climbOn(T)} :- T = 0..m-1.
{climbOff(T)} :- T = 0..m-1.
{graspBananas(T)} :- T = 0..m-1.


{hasBananas(B,T+1)} :- hasBananas(B,T), T=0..m-1.
{onBox(B,T+1)} :- onBox(B,T), T=0..m-1.
{loc(0,L,T+1)} :- loc(0,L,T), T=0..m-1.



#show pushBox/2.
#show walk/2.
#show graspBananas/1.
#show climbOn/1.