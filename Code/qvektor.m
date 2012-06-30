function q_ = qvektor(q,L,n)
%QVEKTOR(q,L,n) Berechnet einen numerischen Vektor mit Streckenlast-
%belegungen mit der Eigenschaft q(i) = Int(0,L,phi_i*q), dabei ist:
% phi_i die i-te Basisfunktion.
% q ist die Streckenlast in Abhängigkeit von x
% L ist die Länge des Balkens
% n ist die Anzahl der zu verwendenden Stützstellen

h = L / (n-1);
X = linspace(0,L,n);

phi_1 = @(xi) horner([ 2, -3, 0, 1 ],xi);
phi_3 = @(xi) horner([ -2, 3, 0, 0 ],xi);

phi_2 = @(xi) horner([ 1, -2, 1, 0 ],xi);
phi_4 = @(xi) horner([ 1, -1, 0, 0 ],xi);

N=10;
q_ = zeros([2*n, 1]);
for i=1:n
  if(1<i)
    % Integrale von X(i-1) bis X(i)
    a = X(i-1);
    b = X(i);
    
    f = @(x) q(x) .* phi_3((x-a)/h);
    q_(2*i-1) = q_(2*i-1) + simpson(f,a,b,N);
    g = @(x) q(x) .* phi_4((x-a)/h);
    q_(2*i) = q_(2*i) + h*simpson(g,a,b,N);
  end
  if(i<n)
    % Integrale von X(i) bis X(i+1)
    a = X(i);
    b = X(i+1);
    
    f = @(x) q(x) .* phi_1((x-a)/h);
    q_(2*i-1) = q_(2*i-1) + simpson(f,a,b,N);
    g = @(x) q(x) .* phi_2((x-a)/h);
    q_(2*i) = q_(2*i) + simpson(g,X(i),X(i+1),N);
  end 
end

end

