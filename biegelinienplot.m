function biegelinienplot( u, L )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

n = length(u) / 2;
h = L / (n-1);
X = linspace(0,L,n);
umax=max(u(1:2:length(u)));

% Vorbereiten des Plots
figure;
hold on
%axis([0,L,0,umax]);
axis([0,L,-100,100]);

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

%phi = @(u,Xi,X,n,h) u(1)*phi1(Xi,X,h) + u(2)*phi2(Xi,X,h) + ...
%                    u(2*n-1)*phi2n_1(Xi,X,n,h) + u(2*n)*phi2n(Xi,X,n,h) + ...
%                    sum(u(3:2:2*n-3).*phi2i_1(Xi,X,2:n-1,h)) + ...
%                    sum(u(4:2:2*n-2).*phi2i(Xi,X,2:n-1,h));

% Geht nicht, dann plotten wir halt stückweise:
% Phi 1 und 2
precision = 5;
x = linspace(0,h,precision);
y = u(1) * phi1(x,X,h) + u(2) * phi2(x,X,h);
plot(x,y)

for ii=2:n-1
    x = linspace(ii*h, (ii+1)*h, precision);
    y = u((2*ii)-1) * phi2i_1(x,X,ii,h) + u(2*ii) * phi2i(x,X,ii,h);
    plot(x,y);
end

x = linspace(n*h-h,n,precision);
y = u(2*n-1) * phi2n_1(x,X,n,h) + u(2*n) * phi2n(x,X,n,h);

end

