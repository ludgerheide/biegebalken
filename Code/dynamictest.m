function dynamictest
% Testet das dynamische Verhalten
close all
E=@(x)1;
I=@(x)1;
q=@(x)-1;

mu=@(x)1;
ht=.1;
N=240;

L=2;
n=15;
precision=.0000001;

S=create_S_num(E,I,L,n,precision);
q_=create_q_num(q,n,L,precision);
M=create_M_num(mu,L,n,precision);

lager='loslager';
a=1;
b=-1;

U=solve_dynamic(S, M, q_, lager, a, b, ht, N)

movie(U,L)
