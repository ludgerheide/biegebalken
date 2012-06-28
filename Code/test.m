function test
% test testet den biegebalken
close all;
E=@(x)(1);
I=@(x)(1);
q=@(x)(-1);
L=1;
n=9;
precision=.000001;
S=create_S_num(E,I,L,n,precision);
q=create_q_num(q,n,L,precision)
u=solve_static(S,q,2,0,0);
biegelinienplot_langsam(u',L);


end