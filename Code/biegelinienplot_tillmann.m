function biegelinienplot_tillmann( u, L )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

n = length(u) / 2;
h = L / (n-1);
X = linspace(0,L,n);


phi_1 = @(xi) 1 - 3 * xi.^2 + 2 * xi.^3;
phi_2 = @(xi) xi .* (xi -1).^2;
phi_3 = @(xi) 3*xi.^2 - 2*xi.^3;
phi_4 = @(xi) xi.^2 .* (xi-1);


phi1 = @(x,X,h) phi_1(x/h) .* and(X(1)*ones(size(x)) <= x , x <= X(2)*ones(size(x)));

phi2 = @(x,X,h) h * phi_2(x/h) .* and(X(1)*ones(size(x)) <= x, x <= X(2)*ones(size(x)));

phi2i_1 = @(x,X,i,h) phi_3((x - X(i-1)) / h) .* and ( X(i-1)*ones(size(x)) <= x, x <= X(i)*ones(size(x))) + ...
                   phi_1((x - X(i)) / h) .* and ( X(i)*ones(size(x)) <= x, x <= X(i+1)*ones(size(x)));
                 
phi2i = @(x,X,i,h) h * phi_4((x - X(i-1)) / h) .* and ( X(i-1)*ones(size(x)) <= x, x <= X(i)*ones(size(x))) + ...
                   h * phi_2((x - X(i)) / h) .* and ( X(i)*ones(size(x)) <= x, x <= X(i+1)*ones(size(x)));
               

               
phi2n_1 = @(x,X,n,h) phi_3((x - X(n-1)) / h) .* and ( X(n-1)*ones(size(x)) <= x, x <= X(n)*ones(size(x)));

phi2n = @(x,X,n,h) h * phi_4((x - X(n-1)) / h) .* and ( X(n-1)*ones(size(x)) <= x, x <= X(n)*ones(size(x)));

  function s = for_i_phi2i(u,x,X,I,h) 
    s=0;
    for j=1:length(u)
      s = s+u(j)*phi2i(x,X,I(j),h);
    end
  end

  function s = for_i_phi2i_1(u,x,X,I,h)
    s=0;
    for j=1:length(u)
      s = s+u(j)*phi2i_1(x,X,I(j),h);
    end
  end

phi = @(u,Xi,X,n,h) u(1)*phi1(Xi,X,h) + u(2)*phi2(Xi,X,h) + ...
                    u(2*n-1)*phi2n_1(Xi,X,n,h) + u(2*n)*phi2n(Xi,X,n,h) + ...
                    for_i_phi2i_1(u(3:2:2*n-3),Xi,X,2:n-1,h) + ...
                    for_i_phi2i(u(4:2:2*n-2),Xi,X,2:n-1,h);


Xi = 0:.1:L;
Phi = phi(u,Xi,X,n,h);

plot(Xi,Phi);

end

