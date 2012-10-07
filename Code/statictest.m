function statictest
% statictest testet das statische verhalten des biegebalkens
close all;
E=@(x) .5;
I=@(x) 1;
q=@(x) -1;
L=1;
n=2;
precision=.0001;
lagerung='fest_links'
a=1
b=0
S=create_S_num(E,I,L,n,precision);
q=create_q_num(q,n,L,precision);
u=solve_static(S,q,lagerung,a,b);
biegelinienplot(u',L);


end
