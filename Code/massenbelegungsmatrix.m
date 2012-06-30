function M = massenbelegungsmatrix(mu,L,n)
%MASSENBELEGUNGSMATRIX(m,L,n) Erstellt die Massenbelegungsmatrix M für die
%numerische Lösung des Biegebalkens.
% mu ist die Massenbelegung in Abhängigkeit von x
% L ist die Länge des Balkens
% n ist die Anzahl der zu verwendenden Stützstellen

fun = @(x) mu(x);
M = numerischematrix(fun,L,n);
end

