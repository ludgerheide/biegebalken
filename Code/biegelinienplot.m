function biegelinienplot( u, L )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

n = length(u) / 2;
h = L / (n-1);
X = linspace(0,L,n);


phi_1 = @(xi) horner([ 2, -3, 0, 1 ],xi);
phi_3 = @(xi) horner([ -2, 3, 0, 0 ],xi);


  function V = fitvalues(Y,x,U)
    % Y enthält beliebig viele Werte ausschließlich im Bereich [x,x+h]
    % U enthält 2 Werte; wenn x = X(i), dann 
    %   U(1) = u(2*i-1) und 
    %   U(2) = u(2*i-1 + 2)
    % Sei x+h = X(j) = X(i+1), dann gilt x im Bereich [X(j)-h,X(j)] und 
    % phi_3((x-X(j-1)) / h) = phi_3((x-X(i)) / h)
    Xi = (Y - x) / h;
    V = phi_1(Xi) * U(1) + phi_3(Xi) * U(2);
  end
  
phi_2 = @(xi) horner([ 1, -2, 1, 0 ],xi);
phi_4 = @(xi) horner([ 1, -1, 0, 0 ],xi);

  function D = fitderivatives(Y,x,U)
    % Y enthält beliebig viele Werte ausschließlich im Bereich [x,x+h]
    % U enthält 2 Werte; wenn x = X(i), dann 
    %   U(1) = u(2*i) und 
    %   U(2) = u(2*i + 2)
    Xi = (Y - x) / h;
    D = h * (phi_2(Xi) * U(1) + phi_4(Xi) * U(2));
  end

  function Phi = phi(Y)
    Phi = zeros(size(Y));
    for i=1:n-1
      x=X(i);
      which = find(x <= Y & Y <= x+h);
      Uvals = u(2*i-1:2:2*i-1+2);
      Uders = u(2*i:2:2*i+2);
      Phi(which) = fitvalues(Y(which),x,Uvals) + fitderivatives(Y(which),x,Uders);
    end

  end

Y = 0:.1:L;
plot(Y,phi(Y));

end
