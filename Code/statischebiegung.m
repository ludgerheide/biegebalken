function [ u , L1, L2 ] = statischebiegung( E, I, L, n, q, a, b, varargin)
%STATISCHEBIEGUNG(E,I,L,n,q,a,b) Berechnet die Biegung nach der schwachen
%Formulierung der statischen Biegedifferenzialgleichung. Dabei ist E(x) das
%Elastizitaetsmodul und I(x) das Flaechentraegheitsmoment. L ist die Laenge des
%Balkens und n gibt die Anzahl der Stuetzstellen an.
%
%STATISCHEBIEGUNG(E,I,L,n,q,a,b,'fest_links') Berechnet die Biegelinie mit
%einer festen linken Lagerung. Dabei ist dann:
% a die Auslenkung an der Stelle 0
% b die Steigung an der Stelle 0
%
%STATISCHEBIEGUNG(E,I,L,n,q,a,b,'loslager') Berechnet die Biegelinie mit
%einer losen lagerung auf beiden Seiten.
% a die Auslenkung an der Stelle 0
% b die Auslenkung an der Stelle L
%
%  Der Rueckgabevektor u enthaelt die numerischen Werte der Biegelinie des
%  Balkens. Dabei enthalten die Felder von u mit ungeraden Indizes die
%  Werte der Biegelinie in aequidistanten Stuetzpunkten von 0 bis L. Die
%  Felder mit geradem Index enthalten je die Werte der ersten Ableitung an
%  einer solchen Stuetzstelle.
% TODO was steckt in den Rueckgabeparametern L1 und L2
% [u,L1,L2] liefert zusaetzlich zum Vektor u die harten Bedingungen L1 und
% L2.

if(numel(varargin) > 0) 
  lager = varargin{1};
else
  lager = 'fest_links';
end

S = steifigkeitsmatrix(E,I,L,n);
q_ = qvektor(q,L,n);

switch lager
  case 'fest_links'
    e0 = zeros([2*n 1]);
    e0(1) = 1;
    d0 = zeros([2*n 1]);
    d0(2) = 1;
    u = [ S [ e0 d0 ]; [ e0 d0 ]' zeros(2) ] \ [ q_; a; b ];
  case 'loslager'
    e0 = zeros([2*n 1]);
    e0(1) = 1;
    eL = zeros([2*n 1]);
    eL(end-1) = -1;
    u = [ S [ e0 eL ]; [ e0 eL ]' zeros(2) ] \ [ q_; a; b ];
end
   
u = u(1:2*n);
L1 = u(end-1);
L2 = u(end);
end
