function q_ = create_q_num(q, n, L, precision)
% Erstellt den Vektor q_ durch numerisches Integrieren
% q ist die Streckenlast
% n ist die Anzahl der Stützstellen
% L idt die Länge des Balkens
% precision ist die Toleranz beim Integrieren

% h ist die Länge eines Intervalls
h = L/(n-1);

% x ist ein Vektor von 0 bis L, der jeweils zwischen den Stützstellen
% precision Werte enthält
x = linspace(0,L,(n-1)*(1/precision));

%X ist ein Vektor, der die x-Koordinaten aller Knoten enthält
X = linspace(0,L,n);

% Erster und zweiter von Hand, um outofbounds zu vermeiden
q_(1)=quad(@(x)(q(x).*phi2i_1(x, X, 1, h, n)), 0, h, precision);
q_(2)=quad(@(x)(q(x).*phi2i(x, X, 1, h, n)), 0, h, precision);

% Vorletzter und Letzte von Hand, um outofbounds zu vermeiden
q_(2*n-1)=quad(@(x)(q(x).*phi2i_1(x, X, n, h, n)), X(n-1), X(n), precision);
q_(2*n)=quad(@(x)(q(x).*phi2i(x, X, n, h, n)), X(n-1), X(n), precision);

% Dazwischenliegende qs in einer Schleife
for j=3:2*n-2
    if mod(j,2)==0
        %i gerade
        i=(j/2);
        q_(j)=quad(@(x)(q(x).*phi2i(x, X, i, h, n)), X(i-1), X(i+1), precision);
    else
        %i ungerade
        i=(j+1)/2;
        q_(j)=quad(@(x)(q(x).*phi2i_1(x, X, i, h, n)), X(i-1), X(i+1), precision);
    end
end
q_ = q_';
end

function p2_1 = phi2i_1(x,X,i,h,n)
% Funktionsdeklarationen von phiQuer
phiQuer1 = @(z) (1 - z.^2 + 2.*z.^3);
phiQuer2 = @(z) (z.*(z-1).^2);
phiQuer3 = @(z) (3.*z.^2-2.*z.^3);
phiQuer4 = @(z) (z.^2.*(z-1));
    if i==1
        %Phi(1)
        sprintf('Phi1 verwendet')
        p2_1 = (phiQuer1(x/h)) .* and(X(1)*ones(size(x)) <= x , x <= X(2)*ones(size(x)));
    elseif i==n
        %Phi(2n-1)
        sprintf('Phi2n-1 verwendet')
        p2_1 = (phiQuer3((x - X(n-1)) / h) .* and ( X(n-1)*ones(size(x)) <= x, x <= X(n)*ones(size(x))));
    else
        %Phi(2i-1)
        sprintf('Phi2i1 verwendet')
        p2_1 = (phiQuer3((x - X(i-1)) / h) .* and ( X(i-1)*ones(size(x)) <= x, x <= X(i)*ones(size(x))) + ...
                phiQuer1((x - X(i)) / h) .* and ( X(i)*ones(size(x)) <= x, x <= X(i+1)*ones(size(x))));
    end
end

function p2 = phi2i(x,X,i,h,n)
% Funktionsdeklarationen von phiQuer
phiQuer1 = @(z) (1 - z.^2 + 2.*z.^3);
phiQuer2 = @(z) (z.*(z-1).^2);
phiQuer3 = @(z) (3.*z.^2-2.*z.^3);
phiQuer4 = @(z) (z.^2.*(z-1));
    if i==1
        %Phi(2)
        sprintf('Phi2 verwendet')
        p2 = (h .* phiQuer2(x/h)) .* and(X(1)*ones(size(x)) <= x, x <= X(2)*ones(size(x)));
    elseif i==n
        sprintf('Phi2n verwendet')
        %Phi(2n)
        p2 = (h .* phiQuer4((x - X(n-1)) / h) .* and ( X(n-1)*ones(size(x)) <= x, x <= X(n)*ones(size(x))));
    else
        %Phi(2i)
        sprintf('Phi2i verwendet')
        p2 = (h .* phiQuer4((x - X(i-1)) / h) .* and ( X(i-1)*ones(size(x)) <= x, x <= X(i)*ones(size(x))) + ...
              h .* phiQuer2((x - X(i)) / h) .* and ( X(i)*ones(size(x)) <= x, x <= X(i+1)*ones(size(x))));
    end
end