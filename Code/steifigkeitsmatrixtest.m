E = @(x).5;
I = @(x) 1;
L = 1;
n = 2;
eps = 10^(-10);

S_star = [ 6 3 -6 3; 3 2 -3 1; -6 -3 6 -3; 3 1 -3 2];

tic;
S = create_S_num(E,I,L,n,eps);
t_1 = toc;
err_1 = sum(sum(S_star - S>eps));

tic;
S2 = steifigkeitsmatrix(E,I,L,n);
t_2 = toc;
err_2 = sum(sum(S_star - S2>eps));


fprintf('Bei der Berechnung mit create_S_num gibt es %d ungenaue Werte. Laufzeit %f.\n', err_1, t_1);
fprintf('Bei der Berechnung mit steifigkeitsmatrix gibt es %d ungenaue Werte. Laufzeit %f.\n', err_2, t_2);
