function [ f ] = horner( A, X )
%HORNER(A,X) Wertet einen Polynom in Koeffizientendarstellung an den
%Stellen X mit Hilfe des Horner-Schemas aus
  g = zeros(size(X));
  for a=A
    f = a * ones(size(X)) + g;
    g = f .* X;
  end
end

