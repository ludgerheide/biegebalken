function [u, L1, L2] = solve_static(S, q_, lager, a, b)
% Berechnet den Vektor u, sowie die Lagerreaktionen L1 und L2
% L1 und L2 k�nnen abh�ngig von der Lagerung Momente oder Kr�fte sein
% Eigabewerte:  S ist die Matrix S, numerisch oder analytisch erstellt
%               a und b sind die Randbedingungen
%               q_ ist der Vektor mit den Integralen f�r q*phi
%               lager steht f�r die Art der Lagerung
%               M�gliche Werte: 1 Feste Einspannung     Kein Lager

ed1=zeros(size(S),1);
ed2=zeros(size(S),1);

switch lager
    case 1
        %Wir haben ein einseitiges Festlager
        ed1(1)=1
        ed2(2)=1
    case 2
        sprintf('blubb');
end
   
CSST=[S ed1 ed2; ed1' 0 0; ed2' 0 0];

fab= [q_; a; b];

loesung=CSST\fab;

u=loesung(1:size(loesung)-2);
%L1=loesung(size(loesung)-1);
%L2=loesung(size(loesung));

end