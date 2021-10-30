boolean(t;f).
object(monkey;bananas;chair).
% location(r1,p1;r1,p2;r1,p3;r1,p4;r2,q1;r2,q2).
location(r1p1;r1p2;r1p3;r1p4;r2q1;r2q2).

% preconditions
% if monkey has bananas, it means monkey is in same location as banana
loc(bananas,L,T) :- hasBananas(t,T), loc(monkey,L,T). 

% if monkey is at location it means he is on the chair in the location of the chair
loc(monkey,L,T) :- onChair(t,T), loc(chair,L,T).



% walk

loc(monkey,L,T+1) :- walk(L,T).
% if monkey is in location or on chair. then he is not waking
:- walk(L,T),loc(monkey,L,T). 
:- walk(L,T), onChair(t,T).

% pushChair

loc(chair,L,T+1) :- pushChair(L,T).
loc(monkey,L,T+1) :- pushChair(L,T).
:- pushChair(L,T), loc(monkey,L,T).
:- pushChair(L,T), onChair(t,T).
:- pushChair(L,T), loc(monkey,L1,T), loc(chair,L2,T), L1 !=L2.


% climbOn

onChair(t, T+1) :- climbOn(T).
:- climbOn(T), onChair(t,T).
:- climbOn(T), loc(monkey,L1,T), loc(chair,L2,T), L1 !=L2.

% climboff

onChair(f, T+1) :- climbOff(T).
:- climbOff(T), onChair(f,T).

% grasp Bananas

hasBananas(t,T+1) :- graspBananas(T).
:- graspBananas(T), hasBananas(t,T).
:- graspBananas(T), onChair(f,T).
:- graspBananas(T), loc(monkey, L1,T), loc(bananas,L2,T), L1 != L2.

% disallow similar action

:- walk(L,T), pushChair(L,T).
:- walk(L,T),climbOn(T).
:- pushChair(L,T),climbOn(T).
:- climbOff(T), graspBananas(T).

% fluents

1{hasBananas(BB,0) : boolean(BB)}1.
1{onChair(BB,0) : boolean(BB)}1.
1{loc(O,LL,0) : location(LL)}1 :- object(O).

% unique actions
:- not 1{loc(O,LL,T): location(LL) }1, object(O), T = 1..m.
:- not 1{onChair(BB,T): boolean(BB)}1, T = 1..m.
:- not 1{hasBananas(BB,T) : boolean(BB)}1, T = 1..m.


% actions

{walk(L,T)} :- location(L), T= 0..m-1.
{pushChair(L,T)} :- location(L), T= 0..m-1.
{climbOn(T)} :- T = 0..m-1.
{climbOff(T)} :- T = 0..m-1.
{graspBananas(T)} :- T = 0..m-1.

% inertia law
{hasBananas(B,T+1)} :- hasBananas(B,T), T=0..m-1.
{onChair(B,T+1)} :- onChair(B,T), T=0..m-1.
{loc(O,L,T+1)} :- loc(O,L,T), T=0..m-1.


% #show loc/3.
#show walk/2.
#show pushChair/2.
#show climbOn/1.
#show graspBananas/1.
