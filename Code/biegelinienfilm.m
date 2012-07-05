function biegelinienfilm(U,L,fps,varargin)
% Plottet den Film der Schwingung eines Balkens der Länge L
% U ist eine Matrix, die Zeilenweise den Vektor u'(t) enthält.
% Auslenkung sind die ungeraden Einträge von u
% Steigung sind die geraden Einträge.

if numel(varargin)>0
    tit = varargin{1};
else
    tit = 'biegelinienfilm';
end

% Berechnung der Anzahl der Intervalle
n = (size(U,2)-2)/2;

auslenkungen=abs(U(1:end,1:2:end-2));
umax=max(max(auslenkungen));

figure('Position',[0 0 1024 768]);

for j=1:size(U,1)
    u=U(j,1:end-2)';
    if numel(varargin)>2
        linie = biegelinienplot(u,L);
        hold on;
        
        q = varargin{3};
        t = j/fps;
        X = linspace(0,L,length(linie));
        Q = q(X,t);
        err = umax * Q / 10 + linie;
        plot(X,err,'r');
        hold off;
    else
        biegelinienplot(u,L);
    end
    if numel(varargin)>1
        legend(varargin{2})
    end
    title(tit);
    axis([0,L,-2*umax,2*umax]);
    M(j) = getframe(gcf);
    fprintf('%i von %i Bildern gerendert\n', j, size(U,1));
end

movie2avi(M, 'output.avi', 'fps', fps);
end
