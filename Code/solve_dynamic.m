% solve dynamic biegelinie

E = @(x)3000;
I = @(x) 1;

L = 1;
n = 5;

precision = .1^4;

q = @(x) -1;

S = create_S_num(E,I,L,n,precision);
q_ = create_q_num(q,n,L,precision);

lager = 'fest_links';

a = 1;
b = 0;

[u, L1, L2] = solve_static(S,q_,lager,a,b);

figure
biegelinienplot(u,L);

ht = .1;
mu = @(x) 1;

M = create_M_num(mu,L,n,precision);
M_ = [ M, zeros(2*n,2); zeros(2,2*n+2)];

du = zeros(size(u));
ddu = zeros(size(u));

beta = 1/4;
gamma = 1/2;

ed1 = zeros(2*n,1);
ed2 = zeros(2*n,1);

switch lager
    case 'fest_links'
        %Wir haben ein einseitiges Festlager, a ist die Auslenkung am
        %Anfang, b ist die Steigung
        ed1(1)=1;
        ed2(2)=1;
    case 'loslager'
        % Wir haben ein beideseitiges Loslager, a ist die Auslenkung am
        % Anfang, b die am Ende
        ed1(1)=1;
        ed2(2*n-1)=-1;
end
   
S_=[S ed1 ed2; ed1' 0 0; ed2' 0 0];

q_ = create_q_num(q,n,L,precision);
p_= [q_; a; b];



figure
N = 10;
for j=1:N
  u_star = u + du.*ht + (1/2 - beta)*ddu.*ht^2;
  du_star = du + (1-gamma)*ddu.*ht;
  
  D_ = zeros(size(M_));
  ddu_new = ( M_ + gamma*ht*D_ + beta * ht^2 * S_ ) \ p_ - D_*[du_star; 0 ; 0] - S_*[u_star; 0 ; 0];
  
  u_new = u_star + beta*ddu_new(1:end-2).*ht^2;
  du_new = du_star + gamma * ddu_new(1:end-2) .* ht;

  subplot(2,5,j);
  biegelinienplot(u_new(1:end-2),L);
  u = u_new;
  du = du_new;
  ddu = ddu_new(1:end-2);
end
