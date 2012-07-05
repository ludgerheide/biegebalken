function dynamictest
% Testet das dynamische Verhalten

E=@(x)1;
I=@(x)1;
q=@(x)0;

mu=@(x)1;

fps = 30;
secs = 10;

ht=1/fps;
N=secs*fps;

L=2;
n=3;
precision=.01;

S=create_S_num(E,I,L,n,precision);
q_=create_q_num(q,n,L,precision);

lager='fest_links';
a=0;
b=0;

[u, L1, L2] = solve_static(S, q_, lager, a, b);
u_=[u; L1; L2];

%q für den dynamischen Fall

q = @(x,t) sin(10*t);

q_= @(t) create_q_num(@(x)q(x,t),n,L,precision);
M=create_M_num(mu,L,n,precision);

U=solve_dynamic(S, M, u_, q_, lager, a, b, ht, N);

biegelinienfilm(U, L, fps, 'Links fest eingespannt mit hochfrequenter Sinus-Last.', {'biegelinie','streckenlast'}, q);

end
