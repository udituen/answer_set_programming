% init condition

:- not loc(monkey, r2q1, 0).
:- not loc(bananas, r1p1, 0).
:- not loc(chair, r1p4, 0).
:- not hasBananas(f, 0).

% goal constraint
:- not hasBananas(t,m).