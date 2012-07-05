function dynamictest
% Testet das dynamische Verhalten

E=@(x)1;
I=@(x)1;

%q fuer den statischen Fall
q=@(x)0;

mu=@(x)1;

fps = 30;
secs = .25;

ht=1/fps;
N=secs*fps;

L=2;
n=3;
precision=.00001;

tic;
S=create_S_num(E,I,L,n,precision);
q_=create_q_num(q,n,L,precision);

lager='loslager';
a=0;
b=0;

[u, L1, L2] = solve_static(S, q_, lager, a, b);
u_=[u; L1; L2];
time=toc;
fprintf('Statischer Fall in %2.1f Sekunden geloest.\n', time);

tic;
%q fuer den dynamischen Fall
q = @(x,t) -1*sin(10*t);
q_= @(t) create_q_num(@(x)q(x,t),n,L,precision);
M=create_M_num(mu,L,n,precision);
time=toc;
fprintf('Dynamischer Fall in %2.1f Sekunden vorbereitet.\n', time);

tic;
U=solve_dynamic(S, M, u_, q_, lager, a, b, ht, N);
time=toc;
fprintf('Dynamischer Fall in %2.1f Sekunden geloest.\n', time);

tic;
biegelinienfilm(U, L, fps, 'Beidseitige Loslagerung, Anregung unter Resonanzfrquenz', q);
time=toc;
fprintf('Dynamischer Fall in %2.1f Sekunden gefilmt.\n', time);

end
