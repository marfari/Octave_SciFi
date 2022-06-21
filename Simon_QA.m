function Simon_QA(fibres, pixel_size_um, layer_count, file_header, fig_no)
%Generuje Simonowy wykres - hisoram wysoko�ci w warstwach

fibres_all = fibres;
I = find([fibres.nevermind] == 0);
fibres = fibres(I); %Wyrzucamy nevermindy

plot_fmt = DefaultAxesFormat();

%Wykopujemy dane

for l=1:layer_count
    layers(l).x = [];
    layers(l).y = [];
    layers(l).neighbor_distance = [];
end;

for i=1:length(fibres)
    layer = fibres(i).layer;
    x = fibres(i).x;
    y = fibres(i).y;
    neighbor_no = fibres(i).neighbors(1).fibre_no;
    if neighbor_no
        dist = fibres_all(neighbor_no).x - x;
        layers(layer).neighbor_distance(end+1) = dist;
    end;
    
    layers(layer).x(end+1) = x;
    layers(layer).y(end+1) = y;
end;
    
colors = {'b','g','r','c','m','k','b','g','r','c','m','k'};
colors_names={'blue','green','red','cyan','magenta','black','blue','green','red','cyan','magenta','black'};

%Po pierwsze - histogramy po�o�e� poszczeg�lnych warstw
figure(fig_no);
clf;


%axis = [1.5:0.01:3.5];
axis_raw = [min([fibres.y])-150 : 5 : max([fibres.y])+150];
axis_scaled = 1e-3*axis_raw*pixel_size_um;

nr_layers = 0;

for l=1:length(layers)
    if length(layers(l).y)
        %histo = histc(layers(l).y, axis_scaled);
        histo = histc(layers(l).y, axis_raw);
        means(l) = mean(layers(l).y*pixel_size_um);
        stds(l) = std(layers(l).y*pixel_size_um);
        %peaks(l) = max(histo);
        %plot (axis_scaled, histo, colors{l});
        ax(l) = stairs (axis_scaled, histo, colors{l});
        %legends{l} = sprintf('L%d: M=%1.1f \n \\sigma=%1.1f\\mum \n h=%1.1f\\mum \n N=%d ', ...
        %                l,means(l), stds(l), max(layers(l).y)-min(layers(l).y), length(layers(l).y));
        legends{l} = sprintf('L%d: $M=%1.1f$, $\\sigma=%1.1f\\mu\\textrm{m}$, $h=%1.1f\\mu\\textrm{m}$, $N=%d$', ...
                        l,means(l), stds(l), max(layers(l).y)-min(layers(l).y), length(layers(l).y));
        
		hold on;
        nr_layers = nr_layers+1;
    end;
end;
hold off;
axis([(means(1)-6*stds(1))/1000 (means(end)+6*stds(end))/1000]);

title(sprintf('Y positions of fibre centres, d_{mean}=%1.1f  \\mum', (means(end)-means(1))/(length(means)-1) ));
xlabel('Y position [mm]');
ylabel('Counts');
%legend(ax,legends,'Location','EastOutside');

FormatAxesEx(gcf,gca,plot_fmt, [file_header '_layer_Y_positions_histo']);
% we will write the tex legend here, as it sucks on image!
write_legend(legends,colors_names,[file_header '_layer_Y_positions_histo.tex']);


%Po drugie - �rednie odleg�o�ci mi�dzy fibrami w warstwach
%figure(242);
clf;

axis_raw = [240:1:310];

axis_scaled = axis_raw/pixel_size_um;

for l=1:nr_layers

    histo = histc(layers(l).neighbor_distance, axis_scaled);
    %fits{l} = fit(axis', histo','gauss1'); 
    fits{l} = gauss_fit(axis_raw', histo');

    ax(l) = stairs (axis_raw, histo, colors{l});
    hold on;
    legends{l} = sprintf('L%d: $M=%1.1f$ $\\sigma=%1.1f\\mu\\texrm{m}$ $N=%d$', ...
                    l,fits{l}(2),fits{l}(3), length(layers(l).y));
end;
hold off;
title('X distances between fibres in layers');
xlabel('Distance [\mum]');
ylabel('Counts');
%legend(ax,legends,'Location','EastOutside');

FormatAxesEx(gcf,gca,plot_fmt, [file_header '_layer_fibre_distances_histo']);
write_legend(legends,colors_names,[file_header '_layer_fibre_distances_histo.tex']);

%Po trzecie - to samo, ale sfitowane
%figure(243);
clf;

for l=1:nr_layers
    ax(l) = plot (axis_raw, gauss_eval(fits{l},axis_raw), colors{l});
    hold on;
end;
hold off;
title('Distances between adjecent fibres');
xlabel('Distance [\mum]');
ylabel('Counts');
%legend(ax,legends,'Location','EastOutside');

FormatAxesEx(gcf,gca,plot_fmt, [file_header '_layer_fibre_distances_histo_fit']);
write_legend(legends,colors_names,[file_header '_layer_fibre_distances_histo_fit.tex']);

