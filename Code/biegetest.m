
% Taylor-Polynom 7-ten Grades fuer sin(x) um 0

taylor_sin = [ -1/5040, 0, 1/120, 0, -1/6, 0, 1, 0 ];

X = linspace(-pi, pi, 9);

Uvals = horner(taylor_sin, X);
Uders = horner(polyder(taylor_sin), X);

U = reshape([Uvals; Uders], 1, length(Uvals)+length(Uders));

figure
subplot(1,2,1)
hold on 
axis([0-pi,7-pi,-1.5,1.3])
plot(X, Uvals, 'k')
plot(X, Uders, 'g')
scatter(X, Uvals, 'k')
scatter(X, Uders, 'g')

legend('Taylor-Polynom fuer sin(x) an der Stelle 0', ...
       '1. Ableitung des Taylor-Polynoms fuer sin(x) an der Stelle 0')
     
subplot(1,2,2)
hold on
axis([0,7,-1.5,1.3])
biegelinienplot(U,2*pi)

legend('Biegelinienplot der Laenge 2*pi')