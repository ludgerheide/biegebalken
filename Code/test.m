function test
% test testet den biegebalken
close all;
E=@(x) .5;
I=@(x) 1;
q=@(x) -1;
L=1;
n=2;
precision=.001;
S=create_S_num(E,I,L,n,precision);
q=create_q_num(q,n,L,precision);
u=solve_static(S,q,'fest_links',1,0);
biegelinienplot(u',L);


end