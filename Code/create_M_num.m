function [ M ] = create_M_num( mu, L, n, precision )
% Erstellt die Massenbelegungsmatrix M durch numerisches Lösen der Integrale.
% mu ist die Massenbelegung
% L ist die Länge des Balkens
% n ist die Anzahl der Knoten

% h ist die Länge eines Intervalls
h = L/(n-1);

%X ist ein Vektor, der die x-Koordinaten aller Knoten enthält
X = linspace(0,L,n);
 
%M erstellen
M=zeros(2*n,2*n);

% Matrix füllen
% Wir gehen jede Zeile der Matrix im Abstand von bis zu 3 zur Hauptdiaginalen durch
% und schreiben jeweils das zugehörige integral hin.

for j = 1:1:2*n % Zeilen
    for k = j-3:1:j %Spalten
        if k<=0
            sprintf('Nothing done, k<=0');
        elseif k>2*n
            sprintf('Nothing done, k>=2n');
        elseif j-k==3
            if mod(j,2)==0
                M(j,k)=quad(@(x)(mu(x).*phi2i(x,X,(j/2),h,n).*phi2i_1(x,X,((k+1)/2),h,n)),X((k+1)/2)-h,X(j/2)+h,precision);
            else
                M(j,k)=quad(@(x)(mu(x).*phi2i_1(x,X,((j+1)/2),h,n).*phi2i(x,X,(k/2),h,n)),X(k/2)-h,X((j+1)/2)+h,precision);
            end
        elseif j-k==2
            if mod(j,2)==0
                M(j,k)=quad(@(x)(mu(x).*phi2i(x,X,(j/2),h,n).*phi2i(x,X,(k/2),h,n)),X(k/2)-h,X(j/2)+h,precision);
            else
                M(j,k)=quad(@(x)(mu(x).*phi2i_1(x,X,((j+1)/2),h,n).*phi2i_1(x,X,((k+1)/2),h,n)),X((k+1)/2)-h,X((j+1)/2)+h,precision);
            end
        elseif j-k==1
            if mod(j,2)==0
                M(j,k)=quad(@(x)(mu(x).*phi2i(x,X,(j/2),h,n).*phi2i_1(x,X,((k+1)/2),h,n)),X((k+1)/2)-h,X(j/2)+h,precision);
            else
                M(j,k)=quad(@(x)(mu(x).*phi2i_1(x,X,((j+1)/2),h,n).*phi2i(x,X,(k/2),h,n)),X(k/2)-h,X((j+1)/2)+h,precision);
            end
        elseif j==k
            if mod(j,2)==0
                M(j,k)=quad(@(x)(mu(x).*(phi2i(x,X,(j/2),h,n).^2)),X(j/2)-h,X(j/2)+h,precision);
            else
                M(j,k)=quad(@(x)(mu(x).*(phi2i_1(x,X,((j+1)/2),h,n).^2)),X((j+1)/2)-h,X((j+1)/2)+h,precision);
            end
        else
            sprintf('Error in create_M');
        end
    end
end

%M "spiegeln"
M=M+(M - diag(diag(M)))';

end

function p2_1 = phi2i_1(x,X,i,h,n)
% Funktionsdeklarationen von phiQuer
phiQuer1 = @(z) (1 - 3.*z.^2 + 2.*z.^3);
phiQuer2 = @(z) (z.*(z-1).^2);
phiQuer3 = @(z) (3.*z.^2-2.*z.^3);
phiQuer4 = @(z) (z.^2.*(z-1));
    if i==1
        %Phi(1)
        sprintf('Phi1 verwendet');
        p2_1 = (phiQuer1(x/h)) .* and(X(1)*ones(size(x)) <= x , x <= X(2)*ones(size(x)));
    elseif i==n
        %Phi(2n-1)
        sprintf('Phi2n-1 verwendet');
        p2_1 = (phiQuer3((x - X(n-1)) / h) .* and ( X(n-1)*ones(size(x)) <= x, x <= X(n)*ones(size(x))));
    else
        %Phi(2i-1)
        sprintf('Phi2i1 verwendet');
        p2_1 = (phiQuer3((x - X(i-1)) / h) .* and ( X(i-1)*ones(size(x)) <= x, x <= X(i)*ones(size(x))) + ...
                phiQuer1((x - X(i)) / h) .* and ( X(i)*ones(size(x)) <= x, x <= X(i+1)*ones(size(x))));
    end
end

function p2 = phi2i(x,X,i,h,n)
% Funktionsdeklarationen von phiQuer
phiQuer1 = @(z) (1 - 3.*z.^2 + 2.*z.^3);
phiQuer2 = @(z) (z.*(z-1).^2);
phiQuer3 = @(z) (3.*z.^2-2.*z.^3);
phiQuer4 = @(z) (z.^2.*(z-1));
    if i==1
        %Phi(2)
        sprintf('Phi2 verwendet');
        p2 = (h .* phiQuer2(x/h)) .* and(X(1)*ones(size(x)) <= x, x <= X(2)*ones(size(x)));
    elseif i==n
        sprintf('Phi2n verwendet');
        %Phi(2n)
        p2 = (h .* phiQuer4((x - X(n-1)) / h) .* and ( X(n-1)*ones(size(x)) <= x, x <= X(n)*ones(size(x))));
    else
        %Phi(2i)
        sprintf('Phi2i verwendet');
        p2 = (h .* phiQuer4((x - X(i-1)) / h) .* and ( X(i-1)*ones(size(x)) <= x, x <= X(i)*ones(size(x))) + ...
              h .* phiQuer2((x - X(i)) / h) .* and ( X(i)*ones(size(x)) <= x, x <= X(i+1)*ones(size(x))));
    end
end
