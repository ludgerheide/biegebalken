function [ S ] = simpson( f, a, b, n)
%SIMPSON(f,a,b,n) Berechnet das numerische Integral von f im Intervall
%[a,b] mit n Stützstellen mit Hilfe der Simpsonregel

h = (b-a)/(n-1);
x = linspace(a,b,n);

y = f(x);
y_inter = f( (x(1:end-1) + x(2:end)) / 2 );

S = h / 6 * ( y(1) + 2 * sum(y(2:end-1)) + 4 * sum(y_inter) + y(end) );


end

