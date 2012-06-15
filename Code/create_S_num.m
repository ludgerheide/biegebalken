function [ S ] = create_S_num( E, I, L, n, precision )
% Erstellt die Steifigkeitsmatrix S durch numerisches Lösen der Integrale.
% E ist das E-Modul von x
% I ist das Flächenträgheitsmoment 1. Ordnung von x
% L ist die Länge des Balkens
% n ist die Anzahl der Knoten

% h ist die Länge eines Intervalls
h = L/(n-1);

% x ist ein Vektor von 0 bis L, der jeweils zwischen den Stützstellen
% precision Werte enthält
x = linspace(0,L,(n-1)*precision);

%X ist ein Vektor, der die x-Koordinaten aller Knoten enthält
X = linspace(0,L,n);
 
%S erstellen
S=zeros(2*n,2*n);

% Matrix füllen
% TODO: Gibt es eigentlich auch Switch in Matlab???

for j = 1:1:2*n
    for k = j-3:1:j+3
        if k<=0
            sprintf('Nothing done, k<=0');
        elseif k>=2*n
            sprintf('Nothing done, k>=2n');
        elseif j-k==3
            if mod(j,2)==0
                S(j,k)=quad(@(x)(E(x).*I(x).*phi2i(x,X,(j/2),h,n).*phi2i_1(x,X,((k+1)/2),h,n)),0,L,precision);
            else
                S(j,k)=quad(@(x)(E(x).*I(x)*phi2i_1(x,X,((j+1)/2),h,n).*phi2i(x,X,(k/2),h,n)),0,L,precision);
            end
        elseif j-k==2
            if mod(j,2)==0
                S(j,k)=quad(@(x)(E(x).*I(x).*phi2i(x,X,(j/2),h,n).*phi2i(x,X,(k/2),h,n)),0,L,precision);
            else
                S(j,k)=quad(@(x)(E(x).*I(x).*phi2i(x,X,((j+1)/2),h,n).*phi2i_1(x,X,((k+1)/2),h,n)),0,L,precision);
            end
        elseif j-k==1
            if mod(j,2)==0
                S(j,k)=quad(@(x)(E(x).*I(x).*phi2i(x,X,(j/2),h,n).*phi2i_1(x,X,((k+1)/2),h,n)),0,L,precision);
            else
                S(j,k)=quad(@(x)(E(x).*I(x).*phi2i_1(x,X,((j+1)/2),h,n).*phi2i(x,X,(k/2),h,n)),0,L,precision);
            end
        elseif j==k
            if mod(j,2)==0
                S(j,k)=quad(@(x)(E(x).*I(x).*(phi2i(x,X,(j/2),h,n).^2)),0,L,precision);
            else
                S(j,k)=quad(@(x)(E(x).*I(x).*(phi2i_1(x,X,((j+1)/2),h,n).^2)),0,L,precision);
            end
        elseif j-k==-1
            if k-2 >= 1
                S(j,k)=S(j,(k-2));
            else
                if mod(j,2)==0
                    S(j,k)=quad(@(x)(E(x).*I(x).*phi2i(x,X,(j/2),h,n).*phi2i_1(x,X,((k+1)/2),h,n)),0,L,precision);
                else
                    S(j,k)=quad(@(x)(E(x).*I(x).*phi2i_1(x,X,((j+1)/2),h,n).*phi2i(x,X,(k/2),h,n)),0,L,precision);
                end
            end
        elseif j-k==-2
            if k-4 >= 1
                S(j,k)=S(j,(k-4));
            else
                if mod(j,2)==0
                    S(j,k)=quad(@(x)(E(x).*I(x).*phi2i(x,X,(j/2),h,n).*phi2i(x,X,(k/2),h,n)),0,L,precision);
                else
                    S(j,k)=quad(@(x)(E(x).*I(x).*phi2i(x,X,((j+1)/2),h,n).*phi2i_1(x,X,((k+1)/2),h,n)),0,L,precision);
                end
            end
        elseif j-k==-3
            if k-6 >= 1
                S(j,k)=S(j,(k-6));
            else
                if mod(j,2)==0
                    S(j,k)=quad(@(x)(E(x).*I(x).*phi2i(x,X,(j/2),h,n).*phi2i_1(x,X,((k+1)/2),h,n)),0,L,precision);
                else
                    S(j,k)=quad(@(x)(E(x).*I(x)*phi2i_1(x,X,((j+1)/2),h,n).*phi2i(x,X,(k/2),h,n)),0,L,precision);
                end
            end
        else
            sprintf('Error in create_S');
        end
    end
end

end

function p2_1 = phi2i_1(x,X,i,h,n)
% Funktionsdeklarationen von phiQuer''
phiQuer1 = @(z) (12 * z - 6);
phiQuer2 = @(z) (6 * z - 4);
phiQuer3 = @(z) (-12 * z + 6);
phiQuer4 = @(z) (6 * z - 2);
    if i==1
        %Phi(1)
        p2_1 = ((1/h.^2)*phiQuer1(x)) .* and(X(1)*ones(size(x)) <= x , x <= X(2)*ones(size(x)));
    elseif i==n
        %Phi(2n-1)
        p2_1 = ((1/h^2)*phiQuer3((x - X(n-1)) / h) .* and ( X(n-1)*ones(size(x)) <= x, x <= X(n)*ones(size(x))));
    else
        %Phi(2i-1)
        p2_1 = ((1/h.^2)*phiQuer3((x - X(i-1)) / h) .* and ( X(i-1)*ones(size(x)) <= x, x <= X(i)*ones(size(x))) + ...
                           (1/h.^2)*phiQuer1((x - X(i)) / h) .* and ( X(i)*ones(size(x)) <= x, x <= X(i+1)*ones(size(x))));
    end
end

function p2 = phi2i(x,X,i,h,n)
% Funktionsdeklarationen von phiQuer''
phiQuer1 = @(z) (12 * z - 6);
phiQuer2 = @(z) (6 * z - 4);
phiQuer3 = @(z) (-12 * z + 6);
phiQuer4 = @(z) (6 * z - 2);
    if i==1
        %Phi(2)
        p2 = ((1/h)*phiQuer2(x)) .* and(X(1)*ones(size(x)) <= x, x <= X(2)*ones(size(x)));
    elseif i==n
        %Phi(2n)
        p2 = ((1/h)*phiQuer4((x - X(n-1)) / h) .* and ( X(n-1)*ones(size(x)) <= x, x <= X(n)*ones(size(x))));
    else
        %Phi(2i)
        p2 = ((1/h) * phiQuer4((x - X(i-1)) / h) .* and ( X(i-1)*ones(size(x)) <= x, x <= X(i)*ones(size(x))) + ...
                           (1/h) * phiQuer2((x - X(i)) / h) .* and ( X(i)*ones(size(x)) <= x, x <= X(i+1)*ones(size(x))));
    end
end