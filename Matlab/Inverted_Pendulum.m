%% clear variables 
close all;
clear all;
clc;

%% Define basic informations about pendulum

% Mass in kg
M = 2.7;     %% Car mass
m = 0.2351;  %% Pendulum mass

%%Gravity (m/s^2)
g = 9.8;     %% Earth
%g = 1.62     %% Moon
%g = 24.79    %% Jupter

l = 0.3137 %% Stem (m)


%{ 
    State plant. x1 = theta; x2 = omega; x3 = position; x4 = vel

    x' = Ax + Bu
    y = Cx + Dy

    u = -kx
%}

A = [0 1 0 0; 
     9 0 0 0;
     0 0 0 1; 
     9 0 0 0];
 
A(2,1) = g*((M + m)/(M * l));
A(4,1) = -g*(m/M);

B = [0; 
     1; 
     0; 
     1];

B(2, 1) = -1/(M * l);
B(4, 1) = 1/M;
 

C = [1 0 0 0;
     0 0 1 0]
 
D = [0;
     0]
 

%% Calculate K using LQR theory in optimal control

Q = C'*C

%%weight of state plant variable
Q(1,1) = 1;
Q(2,2) = 1;
Q(3,3) = 1;
Q(4,4) = 1;

%%weight control
R = 0.001 % best value
%R = 0.01
%R = 0.1
%R = 1

K = lqr(A,B,Q,R)
 
%% Impulse response

sys = ss(A, B, C, 0);

[y,x,t] = step(sys);

%{
x1 = [1 0 0 0 0]*x';
x2 = [0 1 0 0 0]*x';
x3 = [0 0 1 0 0]*x';
x4 = [0 0 0 1 0]*x';

subplot(3,2,1); plot(t,x); grid
title('x1 versus t')
xlabel('t (s)'); ylabel('x1')

subplot(3,2,2); plot(t,x2); grid
title('x2 versus t')
xlabel('t (s)'); ylabel('x2')

subplot(3,2,3); plot(t,x3); grid
title('x3 versus t')
xlabel('t (s)'); ylabel('x3')

subplot(3,2,4); plot(t,x4); grid
title('x4 versus t')
xlabel('t (s)'); ylabel('x4')
%}















 
 
 
 
 
 
 
 
 
 
 