% This is an smodels program for the griper problem (we assume one gripper).
% Can be converted to a clingo program by removing #domain derivitives
% by adding domain predicates in rule bodies.

% time(0..steps).

room(r1;r2;r3).
grip(g1;g2;g3).
ball(b1;b2).
time(t).
num_gripper(m).
num_ball(n).

% #show pickup/3.
% #show putdown/3.
% #show move/4.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% action: the gripper pick up ball A
% pickup(G,A,T)
% precondition:
%  1) robot and ball A are at the same room
%  2) the gripper is free
% Postcondition:
%  1)robot stays at the same room
%  2)gripper is holding a ball
%  3)the ball A is on the gripper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

{ pickup(G,A,T) }:-
        grip(G),ball(A),time(T),
        free(G,T),
        at(robot,R1,T),
        at(A,R1,T),
        not moving(robot,T),
        not goal(T).

on(A,G,T+1):-
        pickup(G,A,T),
        grip(G),
        ball(A),
        time(T).

at(robot,R1,T+1):-
        room(R1),
        time(T),
        at(robot,R1,T),
        pickup(G,A,T).

free(G,T):- 
        grip(G),
        time(T),
        not holding(G,T).

change(A,T):-
        ball(A),
        time(T),
        pickup(G,A,T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% action: the gripper G putdown the ball A
% putdown(G,A,T)
% precondition:
%  1) at(robot,R,T)
%  2) gripper is holding the ball A
% Postcondition:
%  1)ball A is at the same room as the robot is
%  2) gripper is free
%  3) robot stays at the same room
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

{putdown(G,A,T)}:-
        grip(G),ball(A),time(T),
        at(robot,R,T),
        not moving(robot,T),
        on(A,G,T).

at(robot,R,T+1):-
        room(R), time(T),
        at(robot,R,T),
        putdown(G,A,T).

free(G,T+1):-
        grip(G), time(T),
        putdown(G,A,T).

at(A,R,T+1):-
        room(R),ball(A),time(T),
        at(robot,R,T),
        putdown(G,A,T).

in_room(R,N-1,T+1):-
        room(R),num_ball(N),time(T),
        at(robot,R,T),
        putdown(G,A,T).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% action: move the robot from room R1 to room R2
% move(robot,R1,R2,T)
% precondition:
%  1) at(robot,R1,T)
% Postcondition:
%  1)at(robot,R2,T+1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

{move(robot,R1,R2,T)}:-
        room(R2), room(R1),time(T),
        at(robot,R1,T),
        R1 != R2.

at(robot,R2,T+1):-
        room(R2),time(T),
        move(robot,R1,R2,T).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if no changes, stay at the same place
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


at(A,R1,T+1):-
        room(R1),ball(A),time(T),
        at(A,R1,T),
        not change(A,T).
on(A,G,T+1):-
        grip(G),ball(A),time(T),
        on(A,G,T),
        not change(A,T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% a ball cannot at two places at the same time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- at(A,R1,T),at(A,R2,T),R1 != R2.
:- at(A,R1,T),on(A,G,T).
:- on(A,G1,T),on(A,G2,T),G1 != G2.
:- on(A,G,T),on(B,G,T), A != B.
:- at(robot,R1,T),at(robot,R2,T), R1 != R2.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% move causes moving
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% move causes moving
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

moving(robot,T) :- move(robot,R1,R2,T).
holding(G,T) :- pickup(G,A,T),
                grip(G),time(T).

goal(T+1):- goal(T).

goal:- goal(T).

moving(robot,T) :- move(robot,R1,R2,T).


goal(T+1):- goal(T).

goal:- goal(T).

:- not goal.


% #defined ball/1.
% #defined holding/2.

#show move/4.









