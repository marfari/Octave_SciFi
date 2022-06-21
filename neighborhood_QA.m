function  mean_distance_error = neighborhood_QA(fibres, pixel_size_um, mean_distance, file_header, fig_no)
%Plot some plots about neighborhood

plot_fmt = DefaultAxesFormat();

	%First - an example of neighbours of a random fibre

I = find([fibres.nevermind] == 0);
all_fibres = fibres;
fibres = fibres(I); %Don't look at neverminds
  
  %Let's find a random fibre from inner layer
found_layer = 0;
while (found_layer < 2) || (found_layer > 3) 
  central_fibre_no = round(rand(1)*length(fibres));
  found_layer = fibres(central_fibre_no).layer;
end;
	
indexes = [fibres(central_fibre_no).neighbors.fibre_no];
indexes(find(indexes == 0)) = [];
%indexes(find(indexes > length(all_fibres))) = [];
subset = [fibres(central_fibre_no) all_fibres(indexes)];
data_to_draw = subset;

if fig_no
  figure(fig_no);
  clf;
  plot([data_to_draw.x]*pixel_size_um/1000,[data_to_draw.y]*pixel_size_um/1000,'+');
  title('Neighborhood of an example fibre');
  xlabel('X position [mm]');
  ylabel('Y position [mm]');
  grid on;
  FormatAxesEx(gcf,gca,plot_fmt, [file_header '_neighborhood_example']);
end;

	%Now the histos...
	
DR = [];
R = [];
DPHI = [];
PHI = [];
neighbor_count = [];

for fibre_no = 1:length(fibres)
	neighbors = fibres(fibre_no).neighbors;
	DR = [DR [neighbors.dr]];
  R = [R [neighbors.r]];
	DPHI = [DPHI [neighbors.dphi]];
  PHI = [PHI [neighbors.phi]];
	neighbor_count(end+1) = length(find([neighbors.fibre_no] ~= 0));
end;

mean_distance_error = mean(DR(find(~isnan(DR))));

if fig_no
  %figure(162);
  clf;
  hist(DR*pixel_size_um,100);
  xlabel('Distance error [\mum]');
  ylabel('Counts');
  title('Neighbour distance errors');

  text_pos_x = get(gca,'XLim');
  text_pos_x = text_pos_x(1)*0.05 + text_pos_x(2)*0.95;
  text_pos_y = get(gca,'YLim');
  text_pos_y = text_pos_y(1)*0.05 + text_pos_y(2)*0.95;
  text(text_pos_x, text_pos_y, sprintf('Mean distance: %1.2f \\mum', mean_distance*pixel_size_um),'HorizontalAlignment','right', 'VerticalAlignment','top','BackgroundColor',[1 1 1]);

  FormatAxesEx(gcf,gca,plot_fmt, [file_header '_neighborhood_dr']);

  %figure(163);
  clf;
  hist(rad2deg(DPHI),100);
  xlabel('Angle error [^o]');
  ylabel('Counts');
  title('Neighbour angle errors');
  FormatAxesEx(gcf,gca,plot_fmt, [file_header '_neighborhood_dphi']);

  %figure(164);
  clf;
  bar([0:6],histc(neighbor_count,[0:6]));
  xlabel('Found neighbours');
  ylabel('Counts');
  title('Found neighbours for each fibre');
  FormatAxesEx(gcf,gca,plot_fmt, [file_header '_neighborhood_count']);

    %Histos per neighbour direction

  for n=1:6
      neighbors_dir(n).DR = [];
      neighbors_dir(n).DPHI = [];
      neighbors_dir(n).R = [];
      neighbors_dir(n).PHI = [];
  end;

  for fibre_no = 1:length(fibres)
    neighbors = fibres(fibre_no).neighbors;
      for n=1:6
          if neighbors(n).fibre_no
              neighbors_dir(n).DR(end+1) = neighbors(n).dr;
              neighbors_dir(n).DPHI(end+1) = neighbors(n).dphi;
              neighbors_dir(n).R(end+1) = neighbors(n).r;
              neighbors_dir(n).PHI(end+1) = neighbors(n).phi;
          end;
      end;
  end;

  colors = {'r', 'g', 'b', 'c', 'm', 'k'};
colors_names={'blue','green','red','cyan','magenta','black'};

  rscale = [-50:50];
  rscale_pix = rscale/pixel_size_um;

  %figure(165)
  clf;
  for n=1:3   %We don't need to count to 6; the plots would be equal
      histo = histc(neighbors_dir(n).DR,rscale_pix);
      histo_mean =  mean(neighbors_dir(n).R);
      histo_std = std(neighbors_dir(n).R);
      ax(n) = plot(rscale, histo, colors{n});
      hold on;
      legenda{n} = sprintf('Angle = $%d/%d^{\\circ}$, $M = %1.1f$, $\\sigma = %1.1f\\mu\\textrm{m}$',60*(n-1), 60*(n-1)+180, histo_mean*pixel_size_um, histo_std*pixel_size_um);
  end;
  hold off;
  title('Distance error for different orientations');
  %legend(ax, legenda,'Location','NorthEast');
  xlabel('Distance errors [\mum]');
  ylabel('Counts');
  FormatAxesEx(gcf,gca,plot_fmt, [file_header '_neighborhood_dr_by_dir']);
  write_legend(legenda,colors_names,[file_header '_neighborhood_dr_by_dir.tex']);

  phiscale = [-10:0.25:10];

  %figure(166)
  clf;
  for n=1:3  %We don't need to count to 6; the plots would be equal
      histo = histc(rad2deg(neighbors_dir(n).DPHI),phiscale);
      ax(n) = plot(phiscale, histo, colors{n});
      histo_mean =  rad2deg(mean(neighbors_dir(n).DPHI)) + (n-1)*60;
      histo_std = rad2deg(std(neighbors_dir(n).DPHI));
      hold on;
      legenda{n} = sprintf('Angle = $%d/%d^{\\circ}$, $M = %1.1f$, $\\sigma = %1.1f^{\\circ}$',60*(n-1), 60*(n-1)+180, histo_mean, histo_std );
  end;
  hold off;
  title('Angle error for different orientations');
  %legend(ax, legenda,'Location','NorthEast');
  xlabel('Angle errors [^o]');
  ylabel('Counts');
  FormatAxesEx(gcf,gca,plot_fmt, [file_header '_neighborhood_dphi_by_dir']);
write_legend(legenda,colors_names,[file_header '_neighborhood_dphi_by_dir.tex']);
end;


