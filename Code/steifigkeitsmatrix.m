function S = steifigkeitsmatrix(E,I,L,n)
%STEIFIGKEITSMATRIX(E,I,L,n) Erstellt die Steifigkeitsmatrix S fuer die
%numerische Loesung des Biegebalkens.
% E ist das Elastizitaetsmodul 1. Ordnung in Abhaengigkeit von x
% I ist die das Flaechentraegheitsmoment in Abhaengigkeit von x
% L ist die Laenge des Balkens
% n ist die Anzahl der zu verwendenden Stuetzstellen

fun = @(x) E(x).*I(x);
S = numerischematrix(fun,L,n);  
end
