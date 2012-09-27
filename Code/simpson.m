function [ S ] = simpson( f, a, b, n)
%SIMPSON(f,a,b,n) Berechnet das numerische Integral von f im Intervall
%[a,b] mit n Stuetzstellen mit Hilfe der Simpsonregel

h = (b-a)/(n-1);
x = linspace(a,b,n);

x_a = x(1:end-1);
x_b = x(2:end);
x_ab_2 = (x_a + x_b) / 2;
% y = f(x);
% y_inter = f( (x(1:end-1) + x(2:end)) / 2 );

S = h / 6 * sum( f(x_a) + 4 * f(x_ab_2) + f(x_b) );


end

