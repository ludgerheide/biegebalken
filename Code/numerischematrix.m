function M = numerischematrix( fun, L, n)
%NUMERISCHEMATRIX(fun,L,n) Erstellt eine numerische Matrix mit der
%Eigenschaft, dass M(i,j) = Int(0,L,fun*ddphi_i*ddphi_j). Wobei:
% ddphi_i die 2. Ableitung der i-ten Basisfunktion ist und entsprechend 
% ddphi_j die 2. Ableitung der j-ten Basisfunktion.
% fun ist eine beliebige Funktion in Abhaengigkeit von x
% L ist die Laenge des Balkens
% n ist die Anzahl der zu verwendenden Stuetzstellen

h = L / (n-1);
X = linspace(0,L,n);

ddphi_1 = @(xi) horner([ 12, -6 ],xi);
ddphi_3 = @(xi) horner([ -12, 6 ],xi);

ddphi_2 = @(xi) horner([ 6, -4 ],xi);
ddphi_4 = @(xi) horner([ 6, -2 ],xi);

N=10; % Dieser Wert kann die Performance beeinflussen, oder?
M = zeros(2*n);

  for j=1:n

    if(j<n)
      % rechtsseitig von X(j) integrieren
      a = X(j);
      b = X(j+1);

      f = @(x) fun(x).*ddphi_1((x-a)/h).*ddphi_1((x-a)/h);
      M(2*j-1,2*j-1) = simpson(f,a,b,N);
      f = @(x) fun(x).*ddphi_1((x-a)/h).*(1/h).*ddphi_2((x-a)/h);
      M(2*j-1,2*j) = simpson(f,a,b,N);
      M(2*j,2*j-1) = M(2*j-1,2*j);

      f = @(x) fun(x).*ddphi_1((x-a)/h).*ddphi_3((x-a)/h);
      M(2*j-1,2*(j+1)-1) = simpson(f,a,b,N);
      f = @(x) fun(x).*ddphi_1((x-a)/h).*(1/h).*ddphi_4((x-a)/h);
      M(2*j-1,2*(j+1)) = simpson(f,a,b,N);

      f = @(x) fun(x).*(1/h).*ddphi_2((x-a)/h).*(1/h).*ddphi_2((x-a)/h);
      M(2*j,2*j) = simpson(f,a,b,N);
      f = @(x) fun(x).*(1/h).*ddphi_2((x-a)/h).*(1/h).*ddphi_4((x-a)/h);
      M(2*j,2*(j+1)) = simpson(f,a,b,N);
      f = @(x) fun(x).*(1/h).*ddphi_2((x-a)/h).*ddphi_3((x-a)/h);
      M(2*j,2*(j+1)-1) = simpson(f,a,b,N);
    end

    if(1<j)
      % linksseitig von X(j) integrieren
      a = X(j-1);
      b = X(j);

      f = @(x) fun(x).*ddphi_3((x-a)/h).*ddphi_3((x-a)/h);
      M(2*j-1,2*j-1) = M(2*j-1,2*j-1) + simpson(f,a,b,N);
      f = @(x) fun(x).*ddphi_3((x-a)/h).*(1/h).*ddphi_4((x-a)/h);
      M(2*j-1,2*j) = M(2*j-1,2*j) + simpson(f,a,b,N);
      M(2*j,2*j-1) = M(2*j-1,2*j);

      f = @(x) fun(x).*ddphi_3((x-a)/h).*ddphi_1((x-a)/h);
      M(2*j-1,2*(j-1)-1) = simpson(f,a,b,N);
      f = @(x) fun(x).*ddphi_3((x-a)/h).*(1/h).*ddphi_2((x-a)/h);
      M(2*j-1,2*(j-1)) = simpson(f,a,b,N);

      f = @(x) fun(x).*(1/h).*ddphi_4((x-a)/h).*(1/h).*ddphi_4((x-a)/h);
      M(2*j,2*j) = M(2*j,2*j) + simpson(f,a,b,N);
      f = @(x) fun(x).*(1/h).*ddphi_4((x-a)/h).*(1/h).*ddphi_2((x-a)/h);
      M(2*j,2*(j-1)) = simpson(f,a,b,N);
      f = @(x) fun(x).*(1/h).*ddphi_4((x-a)/h).*ddphi_1((x-a)/h);
      M(2*j,2*(j-1)-1) = simpson(f,a,b,N);
    end

  end
end
