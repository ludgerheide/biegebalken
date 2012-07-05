function biegelinienfilm(U,L,varargin)
% Plottet den Film der Schwingung eines Balkens der Länge L
% U ist eine Matrix, die Zeilenweise den Vektor u'(t) enthält.
% Auslenkung sind die ungeraden Einträge von u
% Steigung sind die geraden Einträge.

if numel(varargin)>0
  tit = varargin{1};
else
  tit = 'biegelinienfilm';
end


global fps;
  % Berechnung der Anzahl der Intervalle
  n = (size(U,2)-2)/2;
  h = L/(n-1);

  auslenkungen=abs(U(:,1:2:end-2));
  umax=max(max(auslenkungen));

  figure('Position',[0 0 1024 768]);

  for j=1:size(U,1)
    u=U(j,1:end-2)';
    if numel(varargin)>2
      linie = biegelinienplot(u,L); 
      q = varargin{3};
      t = j*1/fps;
      X = linspace(0,L,length(linie));
      Q = q(X,t);
      err = umax * Q / max(Q) + linie;
      U_ = zeros(size(linie));
      U_(err<0) = err(err<0);
      L_ = zeros(size(linie));
      L_(err>0) = err(err>0);
      errorbar(X,linie,U_,L_,'r');
    else
      biegelinienplot(u,L); 
    end
    if numel(varargin)>1
     legend(varargin{2})
    end
    title(tit);
    axis([0,L,-2*umax,2*umax]);
    M(j) = getframe(gcf);
  end

  movie2avi(M, 'output.avi', 'fps', fps);
end
