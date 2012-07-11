function [u, L1, L2] = solve_static(S, q_, lager, a, b)
% Berechnet den Vektor u, sowie die Lagerreaktionen L1 und L2
% L1 und L2 koennen abhaengig von der Lagerung Momente oder Kraefte sein
% Eigabewerte:  S ist die Matrix S, numerisch oder analytisch erstellt
%               a und b sind die Randbedingungen
%               q_ ist der Vektor mit den Integralen fuer q*phi
%               lager steht fuer die Art der Lagerung
%               Moegliche Werte: 1 Feste Einspannung     Kein Lager
%                               2 Loslager              Loslager
groesse=size(S);
groesse=groesse(1);
ed1=zeros(groesse,1);
ed2=zeros(groesse,1);

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
        ed2(groesse-1)=1;
    case 'gleitlager'
        % Wir haben ein Loslager links und ein Gleitlager Rechts
        % a die Auslenkung rechts
        % b die Steigung links
        ed1(1)=1;
        ed2(groesse)=1;
end
   
CSST=[S ed1 ed2; ed1' 0 0; ed2' 0 0];

fab= [q_; a; b];

loesung=CSST\fab;

groesse=size(loesung);
groesse=groesse(1);
u=loesung(1:size(loesung)-2);
L1=loesung(groesse-1);
L2=loesung(groesse);

end