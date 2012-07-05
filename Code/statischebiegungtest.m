E = @(x) .5;
I = @(x) 1;

L = 1;
n = 2;
q = @(x) -1;

a = 1;
b = 0;

u=statischebiegung(E,I,L,n,q,a,b);
biegelinienplot(u,L)