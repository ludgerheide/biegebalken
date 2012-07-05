function [U] = solve_dynamic(S, M, u_, q_, lager, a, b, ht, N)
% Berechnet die Matrix U, die Untereinander die Zeilenvektoren u(t)' enthält
% L1 und L2 können abhängig von der Lagerung Momente oder Kräfte sein
% Eigabewerte:  S ist die Matrix S, numerisch oder analytisch erstellt
%				M ist die Matrix M, numerisch oder analytisch erstellt
%				u_ ist die Auslenkng zum Startzeitpunkt. Sie kann entweder mit solve_static
%				   berechnet werden oder direkt angegeben werden
%               a und b sind die Randbedingungen
%               q_ ist der Vektor mit den Integralen für q*phi
%               lager steht für die Art der Lagerung
%               Mögliche Werte: 1 Feste Einspannung     Kein Lager
%                               2 Loslager              Loslager
%				ht ist die Länge eines Zeitschritts
%				N ist ie Anzahl der Zeitschritte
	
	% Zuerst lösen wir den statischen Fall.
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
	end
	
	S_=[S ed1 ed2; ed1' 0 0; ed2' 0 0];
	
	p_= [q_; a; b];
	
	%Der statische Fall ist gelöst, auf zum Dynamischen!
	
	% M wird mir Nullen auf die Größe von S_ erweitert
	M_ = [ M, zeros(groesse,2); zeros(2,groesse+2)];
	
	% Für den ersten Zwitschritt werden die Ableitungen auf 0 gesetzt
	du = zeros(size(u_));
	ddu = zeros(size(u_));
	
	% TODO: Switch oder Gamma/Beta als Inputwerte
	beta = 1/4;
	gamma = 1/2;
	
	% Erstellen der Lösungsmatrix U und Füllen mit dem Startwert
	U=u_';
	
	for j=1:N
		% Nach Aufschrieb Sitzung 3
		u_star = u_ + du.*ht + (1/2 - beta)*ddu.*ht^2;
		du_star = du + (1-gamma)*ddu.*ht;
		
		ddu_new = ( M_ + beta * ht^2 * S_ ) \ (p_ - S_*u_star);
		
		u_new = u_star + beta*ddu_new.*ht^2;
		du_new = du_star + gamma * ddu_new .* ht;
		
		U(j+1,1:end)=u_new';
		
		u_=u_new;
		du=du_new;
		ddu=ddu_new;
	end
end
