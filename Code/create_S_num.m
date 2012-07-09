function [ S ] = create_S_num( E, I, L, n, precision )
% Erstellt die Steifigkeitsmatrix S durch numerisches Loesen der Integrale.
% E ist das E-Modul von x
% I ist das Flaechentraegheitsmoment 1. Ordnung von x
% L ist die Laenge des Balkens
% n ist die Anzahl der Knoten

% h ist die Laenge eines Intervalls
h = L/(n-1);

%X ist ein Vektor, der die x-Koordinaten aller Knoten enthaelt
X = linspace(0,L,n);
 
%S erstellen
S=zeros(2*n,2*n);

% Matrix fuellen
% TODO: Umbauen auf Switch
% Wir gehen jede Zeile der Matrix im Abstand von bis zu 3 zur Hauptdiaginalen durch
% und schreiben jeweils das zugehoerige integral hin.
for j = 1:1:2*n % Zeilen
    for k = j-3:1:j %Spalten
        if k<=0
            %fprintf('Nothing done, k<=0\n');
        elseif k>2*n
            %fprintf('Nothing done, k>=2n\n');
        elseif j-k==3
            if mod(j,2)==0
                S(j,k)=quad(@(x)(E(x).*I(x).*phi2i(x,X,(j/2),h,n).*phi2i_1(x,X,((k+1)/2),h,n)),X((k+1)/2)-h,X(j/2)+h,precision);
            else
                S(j,k)=0;
                %S(j,k)=quad(@(x)(E(x).*I(x).*phi2i_1(x,X,((j+1)/2),h,n).*phi2i(x,X,(k/2),h,n)),X(k/2)-h,X((j+1)/2)+h,precision);
            end
        elseif j-k==2
            if mod(j,2)==0
                S(j,k)=quad(@(x)(E(x).*I(x).*phi2i(x,X,(j/2),h,n).*phi2i(x,X,(k/2),h,n)),X(k/2)-h,X(j/2)+h,precision);
            else
                S(j,k)=quad(@(x)(E(x).*I(x).*phi2i_1(x,X,((j+1)/2),h,n).*phi2i_1(x,X,((k+1)/2),h,n)),X((k+1)/2)-h,X((j+1)/2)+h,precision);
            end
        elseif j-k==1
            if mod(j,2)==0
                S(j,k)=quad(@(x)(E(x).*I(x).*phi2i(x,X,(j/2),h,n).*phi2i_1(x,X,((k+1)/2),h,n)),X((k+1)/2)-h,X(j/2)+h,precision);
            else
                S(j,k)=quad(@(x)(E(x).*I(x).*phi2i_1(x,X,((j+1)/2),h,n).*phi2i(x,X,(k/2),h,n)),X(k/2)-h,X((j+1)/2)+h,precision);
            end
        elseif j==k
            if mod(j,2)==0
                S(j,k)=quad(@(x)(E(x).*I(x).*(phi2i(x,X,(j/2),h,n).^2)),X(j/2)-h,X(j/2)+h,precision);
            else
                S(j,k)=quad(@(x)(E(x).*I(x).*(phi2i_1(x,X,((j+1)/2),h,n).^2)),X((j+1)/2)-h,X((j+1)/2)+h,precision);
            end
        else
            fprintf('Error in create_S/n');
        end
    end
end

%S "spiegeln"
S=S+(S - diag(diag(S)))';

end

function p2_1 = phi2i_1(x,X,i,h,n)
% Funktionsdeklarationen von phiQuer''
phiQuer1 = @(z) (12 * z - 6);
phiQuer2 = @(z) (6 * z - 4);
phiQuer3 = @(z) (-12 * z + 6);
phiQuer4 = @(z) (6 * z - 2);
    if i==1
        %Phi(1)
        p2_1 = ((1/h.^2)*phiQuer1(x/h)) .* and(X(1)*ones(size(x)) <= x , x <= X(2)*ones(size(x)));
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
        p2 = ((1/h)*phiQuer2(x/h)) .* and(X(1)*ones(size(x)) <= x, x <= X(2)*ones(size(x)));
    elseif i==n
        %Phi(2n)
        p2 = ((1/h)*phiQuer4((x - X(n-1)) / h) .* and ( X(n-1)*ones(size(x)) <= x, x <= X(n)*ones(size(x))));
    else
        %Phi(2i)
        p2 = ((1/h) * phiQuer4((x - X(i-1)) / h) .* and ( X(i-1)*ones(size(x)) <= x, x <= X(i)*ones(size(x))) + ...
                           (1/h) * phiQuer2((x - X(i)) / h) .* and ( X(i)*ones(size(x)) <= x, x <= X(i+1)*ones(size(x))));
    end
end
