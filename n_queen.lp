
% For testing purposes, consider a 2X2 board;  a position may have a queen
#const k = 6.
{q(X,Y)} :- d(X),d(Y).
d(1..6).

% assume queens on the same row or column attack each other (for the assignment, you need to define a more involved attack relation).
attack(X,Y) :- q(X,Y),q(X,Y), X != Y.
attack(X,Y1) :- q(X,Y1),q(X,Y1), X != Y1.
attack(X1,Y) :- q(X1,Y),q(X1,Y), X1 != Y.
attack(X1,Y1) :- q(X1,Y),q(X1,Y1), X1 != Y1.
% attack(X,Y,X1,Y1) :- attack(X1,Y1,X,Y).   % also, attack is symmetric.

% count the number of attacks for each q(X,Y) and restrict it to be k
num_attacks(X,Y,N) :-
   #count{ (X,Y):attack(X,Y1),attack(X1,Y),attack(X1,Y1) } = N, q(X,Y).
:- q(X,Y), num_attacks(X,Y,N), N != k.

% maximize total number of queens on board.
total_q(N) :- #count{(I,J):q(I,J)}=N.
#maximize{N : total_q(N)}.

