function fibres = find_neighborhood(fibres, mean_distance)
%Funkcja znajduje s�siad�w w��kien i podaje ich numery oraz odchylenia w odleg�o�ci i w k�cie
%Dodaje do struktury pole neighbors, kt�re ma 6 element�w ponumerowanych tak:
%   3   2
% 4   x   1
%   5   6
%Ka�dy element to struktura posiadaj�ca pola:
%fibre_no	- numer w��kna w tablicy fibres
%dr			- odchylenie od zadanej odleg�o�ci
%dphi		- odchylenie od zadanego k�ta

for i=1:6
	angle = (i-1)*deg2rad(60);
	displacements(i,1) = cos(angle);
	displacements(i,2) = sin(angle);
end;
displacements = displacements * mean_distance;


%data = [fibres.output_data];
data = fibres;

for fibre_nr = 1:length(data)
	
	if mod(fibre_nr,500) == 0
		disp(sprintf('    Processing fibre nr %d',fibre_nr));
	end;	
	
	central_fibre = data(fibre_nr);
	central_x = central_fibre.x;
	central_y = central_fibre.y;
	
		%Wy�awiamy do dalszej analizy tylko w��kna le��ce w pobli�u
	ROI_I = find( ([data.x] > (central_x-2*mean_distance)) & ([data.x] < (central_x+2*mean_distance)) );
	
	subset = data(ROI_I);

		%W tym zbiorze szukamy poszczeg�lnych s�siad�w
	for neighbor_nr=1:6
		desired_x = central_x + displacements(neighbor_nr,1);
		desired_y = central_y + displacements(neighbor_nr,2);
		
		I = find( sqrt(([subset.x]-desired_x).^2 + ([subset.y]-desired_y).^2) < (mean_distance/2) );
		
		if length(I) == 0
			record.fibre_no = 0;
			record.dr = NaN;
      record.r = NaN;
			record.dphi = NaN;
      record.phi = NaN;
		else
			found_fibre_no = ROI_I(I(1));
			found_fibre = data(found_fibre_no);
			distance = sqrt((found_fibre.x-central_x)^2 + (found_fibre.y-central_y)^2);
			angle = atan2(found_fibre.y-central_y, found_fibre.x-central_x);
			if angle<0
				angle = angle + 2*pi;
			end;
			
			record.fibre_no = found_fibre_no;
			record.dr = distance-mean_distance;
      record.r = distance;
			record.dphi = angle - (neighbor_nr-1)*deg2rad(60);
      record.phi = angle;
			if (record.dphi > pi) 
				record.dphi = record.dphi - 2*pi;
			end;
			if (record.dphi < -pi) 
				record.dphi = record.dphi + 2*pi;
			end;
		end;
		
		fibres(fibre_nr).neighbors(neighbor_nr) = record;
		
	end;	%szukanie poszczeg�lnych s�siad�w
	
	
	
	
	
	
	
	
end;	%for po wszystkich fibrach