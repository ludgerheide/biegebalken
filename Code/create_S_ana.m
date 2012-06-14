function [ S ] = create_S( E, I, L, n, precision )
% Erstellt die Stefigkeitsmatrix S
% E ist das E-Modul von x
% I ist das Flächenträgheitsmoment 1. Ordnung von x
% L ist die Länge des Balkens
% n ist die Anzahl der Knoten

% h ist die Länge eines Intervalls
h = L/(n-1);

% x ist ein Vektor von 0 bis L, der jeweils zwischen den Stützstellen
% precision Werte enthält
x = linspace(0,L,(n-1)*precision);

%x_i ist ein Vektor, der die x-Koordinaten aller Knoten enthält
x_i = linspace(0,L,n);

% Funktionsdeklarationen von phiQuer''
phiQuer1 = @(z) (12 * z - 6);
phiQuer2 = @(z) (6 * z - 4);
phiQuer3 = @(z) (-12 * z + 6);
phiQuer4 = @(z) (6 * z - 2);

% Funktionsdeklarationen für die 1. Hauptdiagonale
phiQuadratGerade = @(x, x_i, i, h) ((1/h^2 * (phiQuer4((x - x_i(i-1))/h))^2) .* and ( x_i(i-1)*ones(size(x)) <= x, x <= x_i(i)*ones(size(x))) + ...
                                    (1/h^2 * (phiQuer1((x - x_i(i))/h))^2) .* and ( x_i(i)*ones(size(x)) <= x, x <= x_i(i+1)*ones(size(x))));
                                
phiQuadratUngerade = @(x, x_i, i, h) ((1/h^2 * (phiQuer3((x - x_i(i-1))/h))^2) .* and ( x_i(i-1)*ones(size(x)) <= x, x <= x_i(i)*ones(size(x))) + ...
                                      (1/h^2 * (phiQuer1((x - x_i(i))/h))^2) .* and ( x_i(i)*ones(size(x)) <= x, x <= x_i(i+1)*ones(size(x))));
                                  
% Funktionsdeklarationen neben der 1. Hauptdiagonale
phi_gleich = @(x, x_i, i, h) ((1/h^2 * (phiQuer3((x - x_i(i-1))/h)) * (phiQuer4((x - x_i(i-1))/h)) .* and ( x_i(i-1)*ones(size(x)) <= x, x <= x_i(i)*ones(size(x)))) + ...
                              (1/h^2 * (phiQuer1((x - x_i(i))/h)) * (phiQuer1((x - x_i(i))/h)) .* and ( x_i(i)*ones(size(x)) <= x, x <= x_i(i+1)*ones(size(x)))));
                          
phi_ungleich = @(x, x_i, i, h) (1/h^2 * (phiQuer3((x - x_i(i))/h)) * (phiQuer2((x - x_i(i))/h)) .* and ( x_i(i)*ones(size(x)) <= x, x <= x_i(i+1)*ones(size(x))));

%S erstellen
S=zeros(2*n,2*n);

% Erste Hauptdiagonale füllen
% Die ersten beiden sowie die letzte Zeile werden zunächst ausgenommen

% Zählvariable zv wird eingeführt, um zu prüfen, wann die i-Werte der
% Matrixeinträge gleich sind (zv wird inkrementiert und durch 2 dividiert,
% der Rest gibt jeden 2. Schritt an, ob die i-Werte gleich sind
zv = 0;

for j = 3:1:2*n-1
    for k = j-1:1:j+1
        
        if(k == j-1)
        
            % Der untere Matrixeintrag wird gespiegelt
            S(j,k) = S(k,j);
                        
        elseif(k == j)
            
            if(mod(k,2) == 0)
                
                % Wir sind bei j=k=gerade
                %S(j,k) = phiQuadratGerade(x, x_i, j/2, h);
                S(j,k) = 1;
                
            else
                
                % j und k können nur ungerade sein
                % S(j,k) = phiQuadratUngerade(x, x_i, (j+1)/2, h);
                S(j,k) = 2;
            
            end
        
        else
            
            % jetzt kann nur die obere 2. Diagonale eintreten
            if(mod(zv,2) == 0)
                
                S(j,k) = 3;
                
            else
                
                S(j,k) = 4;
            end
                
            zv = zv + 1;
            
        end
        
        
    end
    
end

end

