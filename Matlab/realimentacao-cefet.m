%% limpar
close all;
clear all;
clc;

%% {theta, omega, pos, vel}
A = [0 1 0 0; 33.96 0 0 0;0 0 0 1; -0.85 0 0 0];
B = [0; -1.18; 0; 0.37];

C = [1 0 0 0; 0 0 1 0]
D = [0; 0]

Q = C'*C
R = 0.001

Q(1,1) = 1;
Q(2,2) = 1;
Q(3,3) = 1;
Q(4,4) = 1;

K = lqr(A,B,Q,R)






