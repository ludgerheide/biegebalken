function [U] = solve_dynamic(S, M, q_, lager, a, b, ht, N)
% Berechnet die Matrix U, die Untereinander die Zeilenvektoren u(t)' enthält
% L1 und L2 können abhängig von der Lagerung Momente oder Kräfte sein
% Eigabewerte:  S ist die Matrix S, numerisch oder analytisch erstellt
%				M ist die Matrix M, numerisch oder analytisch erstellt
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
	
	u=S_\p_;
	
	%Der statische Fall ist gelöst, auf zum Dynamischen!
	
	% M wird mir Nullen auf die Größe von S_ erweitert
	M_ = [ M, zeros(groesse,2); zeros(2,groesse+2)];
	
	% Für den ersten Zwitschritt werden die Ableitungen auf 0 gesetzt
	du = zeros(size(u));
	ddu = zeros(size(u));
	
	% TODO: Switch oder Gamma/Beta als Inputwerte
	beta = 1/4;
	gamma = 1/2;
	
	%TEST: p_ auf 0 setzen
	p_;
	p_= [zeros(1,length(p_)-2) a b]';
	
	% Erstellen der Lösungsmatrix U und Füllen mit dem Startwert
	u';
	U=u';
	
	for j=1:N
		% Nach Aufschrieb Sitzung 3
		u_star = u + du.*ht + (1/2 - beta)*ddu.*ht^2;
		du_star = du + (1-gamma)*ddu.*ht;
		
		ddu_new = ( M_ + beta * ht^2 * S_ ) \ (p_ - S_*u_star);
		
		u_new = u_star + beta*ddu_new.*ht^2;
		du_new = du_star + gamma * ddu_new .* ht;
		
		U(j+1,1:end)=u_new';
		
		u=u_new;
		du=du_new;
		ddu=ddu_new;
	end
end
