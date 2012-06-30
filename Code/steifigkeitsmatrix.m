function S = steifigkeitsmatrix(E,I,L,n)
%STEIFIGKEITSMATRIX(E,I,L,n) Erstellt die Steifigkeitsmatrix S für die
%numerische Lösung des Biegebalkens.
% E ist das Elastizitätsmodul 1. Ordnung in Abhängigkeit von x
% I ist die das Flächenträgheitsmoment in Abhängigkeit von x
% L ist die Länge des Balkens
% n ist die Anzahl der zu verwendenden Stützstellen

fun = @(x) E(x).*I(x);
S = numerischematrix(fun,L,n);  
end
