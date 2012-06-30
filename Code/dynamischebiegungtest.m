function dynamischebiegungtest
%DYNAMISCHEBIEGUNG(E,I,L,n,q,a,b)
% mu
% lager

E = @(x) .5;
I = @(x) 1;
q = @(x) -1;

L = 1;
n = 2;

a = 1;
b = 0;

lager = 'fest_links';
[ u, L1, L2 ] = statischebiegung(E,I,L,n,q,a,b,lager);

figure
biegelinienplot(u,L);

ht = .1^6;
mu = @(x) 1;

M = massenbelegungsmatrix(mu,L,n);
M_ = [ M, zeros(2*n,2); zeros(2,2*n+2)];

du = zeros(size(u));
ddu = zeros(size(u));

beta = 1/4;
gamma = 1/2;

S = steifigkeitsmatrix(E,I,L,n);
switch lager
  case 'fest_links'
    e0 = zeros([2*n 1]);
    e0(1) = 1;
    d0 = zeros([2*n 1]);
    d0(2) = 1;
    S_ = [ S [ e0 d0 ]; [ e0 d0 ]' zeros(2) ];
  case 'loslager'
    e0 = zeros([2*n 1]);
    e0(1) = 1;
    eL = zeros([2*n 1]);
    eL(end-1) = -1;
    S_ = [ S [ e0 eL ]; [ e0 eL ]' zeros(2) ];
end

q_ = qvektor(q,L,n);
p_= [q_; a; b];


figure
N = 10;
for j=1:N
  u_star = u + du.*ht + (1/2 - beta)*ddu.*ht^2;
  du_star = du + (1-gamma)*ddu.*ht;
  
  D_ = zeros(size(M_));
  ddu_new = ( M_ + gamma*ht*D_ + beta * ht^2 * S_ ) \ p_ - D_*[du_star; L1 ; L2 ] - S_*[u_star; L1 ; L2];
  
  u_new = u_star + beta*ddu_new(1:end-2).*ht^2;
  du_new = du_star + gamma * ddu_new(1:end-2) .* ht;

  subplot(2,5,j);
  biegelinienplot(u_new,L);
  u = u_new;
  du = du_new;
  ddu = ddu_new(1:end-2);
end

end