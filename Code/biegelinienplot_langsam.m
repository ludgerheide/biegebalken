function biegelinienplot_alt(u,L)
% Plottet die Biegelinie eines Balkens der L�nge L
% u ist ein Vektor, der abwechselnd Auslenkung und Steigung der Linie an
% Punkten gleichen Abstandes enth�lt.
% Auslenkung sind die ungeraden Eintr�ge von u
% Steigung sind die geraden Eintr�ge.

% Berechnung der Anzahl der Intervalle
n = length(u)/2;
h = L/(n-1);
umax=max(u(1:2:length(u)))

% Vorbereiten des Plots
figure;
hold on
axis([0,L,0,umax]);


for i=1:n-1   
    % Berechnung der FUntion durch L�sen des LGS (wie geht es sch�ner?)
    xs=(i-1)*h;
    xe=i*h;
    A=[xs^3 xs^2 xs 1; 3*xs^2 2*xs 1 0; xe^3 xe^2 xe 1; 3*xe^2 2*xe 1 0];
    u_part = [u((2*(i-1)+1):2*i+2)]';
    f=A\u_part;
    % Plotten des L�sungsst�ckes
    x=linspace(xs,xe,50);
    y=f(1)*x.^3+f(2)*x.^2+f(3)*x+f(4);
    plot(x,y);
end
end
   