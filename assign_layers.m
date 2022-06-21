function fibre_data = assign_layers(fibre_data, layer_fits, pixel_size_um, plot_limits, file_header, fig_no)
%Funkcja, kt�ra przypisuje w��kna do warstw - albo warstwy do w��kien, jak kto woli

X = [fibre_data.x];
Y = [fibre_data.y];

for layer=1:length(layer_fits)
	distances(:, layer) = abs(Y - fnval(layer_fits{layer},X));
end;

[val I] = min(distances');

X_in_layers = {};
Y_in_layers = {};

for i=1:length(fibre_data)
	fibre_data(i).layer = I(i);
  X_in_layers{I(i)}(end+1) = fibre_data(i).x;
  Y_in_layers{I(i)}(end+1) = fibre_data(i).y;
end;

%Now plot ALL fibres with layers shown
if fig_no > 0
  linespecs = {'.b','.g','.r','.c','.m','.k','.b','.g','.r','.c','.m','.k'};
  

  figure(fig_no)
  for layer=1:length(layer_fits)
    %plot(x_positions*pixel_size_um/1000,fnval(layer_fits{layer},x_positions)*pixel_size_um/1000,'-k');
    plot(X_in_layers{layer}*pixel_size_um/1000, Y_in_layers{layer}*pixel_size_um/1000, linespecs{layer});
    hold on;
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
  FormatAxesEx(gcf,gca,plot_fmt, [file_header '_layer_assignment']);
  
end;