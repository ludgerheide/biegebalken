function movie(U,L)
% Plottet den Film der Schwingung eines Balkens der Länge L
% U ist eine Matrix, die Zeilenweise den Vektor u'(t) enthält.
% Auslenkung sind die ungeraden Einträge von u
% Steigung sind die geraden Einträge.

	groesse=size(U);
	hoehe=groesse(1);
	breite=groesse(2);

	% Berechnung der Anzahl der Intervalle
	n = (breite-2)/2;
	h = L/(n-1);
	auslenkungen=abs(U(1:end,1:2:breite-2));
	umax=max(max(auslenkungen));

	%Beginn der Filmschleife
	for j=1:hoehe
	
		u=U(j,1:breite-2)';
		% Vorbereiten des Plots
		figure ("visible", "off");
		hold on
		axis([0,L,-umax,umax]);


		for i=1:n-1   
			% Berechnung der FUntion durch Lösen des LGS (wie geht es schöner?)
			xs=(i-1)*h;
			xe=i*h;
			A=[xs^3 xs^2 xs 1; 3*xs^2 2*xs 1 0; xe^3 xe^2 xe 1; 3*xe^2 2*xe 1 0];
			u_part = [u((2*(i-1)+1):2*i+2)];
			f=A\u_part;
			% Plotten des Lösungsstückes
			x=linspace(xs,xe,50);
			y=f(1)*x.^3+f(2)*x.^2+f(3)*x+f(4);
			plot(x,y);
		end
	filename=sprintf('output/%05d.png',j);
	print(filename);
	%sprintf('%i von %i Bildern', j, hoehe)
	end
end
