function dynamictest
% Testet das dynamische Verhalten

start=time();
system('rm output/*.png');
%close all
E=@(x)1;
I=@(x)1;
q=@(x)0;

mu=@(x)1;
ht=.001;
N=120;

L=2;
n=15;
precision=.000001;

S=create_S_num(E,I,L,n,precision);
q_=create_q_num(q,n,L,precision);

lager='fest_links';
a=0;
b=0;

[u, L1, L2] = solve_static(S, q_, lager, a, b)

u_=[zeros(size(u)-2,1); 1; -1; L1; L2];

%q für den dynamischen Fall
q=@(x)0;
q_=create_q_num(q,n,L,precision);
M=create_M_num(mu,L,n,precision);

U=solve_dynamic(S, M, u_, q_, lager, a, b, ht, N);

movie(U,L);

system('mencoder mf://output/*.png -mf w=1200:h=900:fps=24:type=png -quiet -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell -oac copy -o output/outputdynamic.avi');

endtime=time();
runtime=endtime-start;
sprintf('Die Berechnung dauerte %i Sekunden', runtime)

end;
