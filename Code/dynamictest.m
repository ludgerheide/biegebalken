function U=dynamictest
% Rchtige Ausgabe in Octave
more off;

% Testet das dynamische Verhalten

E=@(x)1;
I=@(x)1;

%q fuer den statischen Fall
q=@(x)(0);

mu=@(x)1;

%Zeitfaktoren HIER
fps = 30; %Bilder pro Sekunde im Video
secs = 15; %Laenge des Videos
timescale=.5; %Skalierung, <1 fuer zeitraffer, >1 fuer Zeitlupe

ht=1/(timescale*fps);
N=secs*fps;

L=2;
n=5;
precision=.00001;

tic;
S=create_S_num(E,I,L,n,precision);
q_=create_q_num(q,n,L,precision);

lager='gleitlager';
a=0;
b=0;

[u, L1, L2] = solve_static(S, q_, lager, a, b);
u_=[u; L1; L2];
%u_=[zeros((2*n)-6,1); 0; 1; 1; 0; 0; 0; L1; L2];
time=toc;
fprintf('Statischer Fall in %2.1f Sekunden geloest.\n', time);

tic;
%q fuer den dynamischen Fall
q = @(x,t)(-x);
q_= @(t) create_q_num(@(x)q(x,t),n,L,precision);
%q_= @(t) create_q_num(q,n,L,precision);
M=create_M_num(mu,L,n,precision);
time=toc;
fprintf('Dynamischer Fall in %2.1f Sekunden vorbereitet.\n', time);

tic;
U=solve_dynamic(S, M, u_, q_, lager, a, b, ht, N);
time=toc;
fprintf('Dynamischer Fall in %2.1f Sekunden geloest.\n', time);

tic;
biegelinienfilm(U, L, fps, 'Balken im Gleitlager wird belastet, 2x Zeitraffer',q);
time=toc;
fprintf('Dynamischer Fall in %2.1f Sekunden gefilmt.\n', time);

end
