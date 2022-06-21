function [layer_fits layer_count] = generate_layer_fits(fibres, pixel_size_um, plot_limits, file_header, fig_no)
%Funkcja generuje fity y(x) dla poszczeg�lnych warstw.
%Potem mo�na przypisywa� w��kna do warstw na podstawie odleg�o�ci od poszczeg�lnych fit�w
%Zwraca fity w tablicy celli, bo inaczej si� nie da


segment_length_mm = 4.0;
segment_length_pixels = segment_length_mm*1000/pixel_size_um;
displacement_factor = 0.25;

found_peaks = [];
x_positions = [];
peak_numbers = [];

  %Nie mamy projekcji, więc musimy ręcznie porąbać obrazek na kawałki
X = [fibres.x];
Y = [fibres.y];
xmin = min(X);
xmax = max(X);
ymin = min(Y);
ymax = max(Y);

idx = 1;
for xcenter=xmin : segment_length_pixels*displacement_factor : xmax
   I = find((X > (xcenter-segment_length_pixels)) & (X < (xcenter+segment_length_pixels)));
   views(idx).y_positions = Y(I);
   views(idx).x_center = xcenter;
   idx = idx+1;
end;

for view_nr = 1:length(views)
    if ~isempty(views(view_nr).y_positions)
    
        fibre_positions = [views(view_nr).y_positions];
        %dither = 5.0*rand(1)-2.5;
        dither = 0;
        [count bins] = hist(fibre_positions,[ymin-50:5:ymax+50]+dither);
        
        %figure(2);
        %plot(bins,count);
        %drawnow

        %[peaks,locations]= findpeaks(count);
        [peaks,locations] = myFindPeaks(count', 2, 5);
        peak_positions = bins(locations);

        peak_numbers(end+1) = length(peak_positions);
        peak_positions = [peak_positions zeros(1,100)];
        peak_positions = peak_positions(1:10);	
        found_peaks(end+1,:) = peak_positions;
        x_positions(end+1) = views(view_nr).x_center;

    end;
end;	%po widokach

	%Automatycznie wyszukujemy liczb� warstw
  
 %figure(1);
  
layer_count = median(peak_numbers);

good_fits = find(peak_numbers == layer_count);
found_peaks = found_peaks(good_fits,:);
x_positions = x_positions(good_fits);
%Dodajemy skrajne punkty, �eby fitowi by�o �atwiej
found_peaks = [found_peaks(1,:); found_peaks; found_peaks(end,:)];
x_positions = [views(1).x_center-1024 x_positions views(end).x_center+1024];

for layer=1:layer_count
	%layer_fits{layer} = fit(x_positions', found_peaks(:,layer),'smoothingspline', 'SmoothingParam', 5e-8);
  layer_fits{layer} = csaps(x_positions', found_peaks(:,layer), 5e-8);
end;

figure(fig_no)
plot(x_positions*pixel_size_um/1000, found_peaks(:,1:layer_count)*pixel_size_um/1000,'+');
hold on;
for layer=1:layer_count
	plot(x_positions*pixel_size_um/1000,fnval(layer_fits{layer},x_positions)*pixel_size_um/1000,'-k');
end;
hold off;
title('Layer assignment');
xlabel('X [mm]');
ylabel('Y [mm]');

%Obcinamy wykres, jeśli mamy też obcinać matę
if length(plot_limits)
  axis(plot_limits);
end;

plot_fmt = DefaultAxesFormat();
FormatAxesEx(gcf,gca,plot_fmt, [file_header '_layer_fit']);

