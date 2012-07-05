function M = massenbelegungsmatrix(mu,L,n)
%MASSENBELEGUNGSMATRIX(m,L,n) Erstellt die Massenbelegungsmatrix M fuer die
%numerische Loesung des Biegebalkens.
% mu ist die Massenbelegung in Abhaengigkeit von x
% L ist die Laenge des Balkens
% n ist die Anzahl der zu verwendenden Stuetzstellen

fun = @(x) mu(x);
M = numerischematrix(fun,L,n);
end

