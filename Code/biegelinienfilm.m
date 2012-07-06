function biegelinienfilm(U,L,fps,varargin)
% Plottet den Film der Schwingung eines Balkens der Laenge L
% U ist eine Matrix, die Zeilenweise den Vektor u'(t) enthaelt.
% fps ist die Anzahl der Bilder pro Sekunde
% varargin 1 ist der Titel
% varargin 2 ist die Streckenlast

if numel(varargin)>0
    tit = varargin{1};
else
    tit = 'biegelinienfilm';
end

% Berechnung der Anzahl der Intervalle
n = (size(U,2)-2)/2;

%Berechnung der absolut maximalen Auslenkung
auslenkungen=abs(U(1:end,1:2:end-2));
umax=max(max(auslenkungen));

figure('Position',[0 0 1024 768]);

%Abschaetzen von qmax
if numel(varargin)>1
    q = varargin{2};
    Q_=zeros(size(U,1),size(U,2)-2);
    positionstep=L/(size(U,2)-2);
    timestep=1/fps;
    
    for i=1:size(U,1)
        for j=1:size(U,2)-2
            Q_(i,j)=q(j*positionstep, i*timestep);
        end
    end
    
    querkraefte=abs(Q_);
    qmax=max(max(querkraefte));
end
      
for j=1:size(U,1)
    u=U(j,1:end-2)';
    if numel(varargin)>1
        linie = biegelinienplot(u,L);
        hold on;
        
        % Zeichnen der skalierten Streckenlast
        q = varargin{2};
        t = j/fps;
        X = linspace(0,L,length(linie));
        Q = (umax * q(X,t) / qmax) + linie;
        
        plot(X,Q,'r');
        legend({'biegelinie','streckenlast'});
        hold off;
        
    else
        biegelinienplot(u,L);
        legend( {'biegelinie',});
    end
    title(tit);
    axis([0,L,-2*umax,2*umax]);
    M(j) = getframe(gcf);
    fprintf('%i von %i Bildern gerendert\n', j, size(U,1));
end
movie2avi(M, 'output.avi', 'fps', fps);
close all
end
