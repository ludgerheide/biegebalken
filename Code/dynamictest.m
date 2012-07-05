function dynamictest
% Testet das dynamische Verhalten

start=time();
system('rm output/*.png');
%close all
E=@(x)1;
I=@(x)1;
q=@(x)-1;

mu=@(x)1;
ht=.1;
N=120;

L=2;
n=15;
precision=.000001;

S=create_S_num(E,I,L,n,precision);
q_=create_q_num(q,n,L,precision);
M=create_M_num(mu,L,n,precision);

lager='loslager';
a=2;
b=-2;

U=solve_dynamic(S, M, q_, lager, a, b, ht, N);

movie(U,L);

system('mencoder mf://output/*.png -mf w=1200:h=900:fps=24:type=png -quiet -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell -oac copy -o output/outputdynamic.avi');

endtime=time();
runtime=endtime-start;
sprintf('Die Berechnung dauerte %i Sekunden', runtime)

end;
