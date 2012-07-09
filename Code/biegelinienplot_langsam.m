function biegelinienplot_langsam(u,L)
% Plottet die Biegelinie eines Balkens der Laenge L
% u ist ein Vektor, der abwechselnd Auslenkung und Steigung der Linie an
% Punkten gleichen Abstandes enthaelt.
% Auslenkung sind die ungeraden Eintraege von u
% Steigung sind die geraden Eintraege.

% Berechnung der Anzahl der Intervalle
n = length(u)/2;
h = L/(n-1);
auslenkungen=abs(u(1:2:length(u)));
umax=max(auslenkungen);

% Vorbereiten des Plots
figure;
hold on
axis([0,L,-umax,umax]);


for i=1:n-1   
    % Berechnung der FUntion durch Loesen des LGS (wie geht es schoener?)
    xs=(i-1)*h;
    xe=i*h;
    A=[xs^3 xs^2 xs 1; 3*xs^2 2*xs 1 0; xe^3 xe^2 xe 1; 3*xe^2 2*xe 1 0];
    u_part = [u((2*(i-1)+1):2*i+2)];
    f=A\u_part;
    % Plotten des Loesungsstueckes
    x=linspace(xs,xe,50);
    y=f(1)*x.^3+f(2)*x.^2+f(3)*x+f(4);
    plot(x,y);
end

end
   
