function fibres_out = make_master_fibres(fibres_in, pixel_size_um, light_priority)
%This function renumbers the fibres and adds  ".all" field.
%light_priority is a table which gives the priorities of given illuminations
%[priority_backlight priority_frontlight priority_bothlight priority_nolight]
%Standard values are [4 2 3 1]. Higher value means higher priority
%Set priority level to -1 if you don't want to use certain illumination

max_displacement_um = 100;
max_displacement_px = max_displacement_um/pixel_size_um;

  %Tworzymy podkładkę dla wynikowej struktury
fibres_out.backlight = struct('fibre_nr',{},'x',{},'y',{},'x_unaligned',{},'y_unaligned',{},'r',{},'bad',{},'luminance',{},'light',{});
fibres_out.frontlight = struct('fibre_nr',{},'x',{},'y',{},'x_unaligned',{},'y_unaligned',{},'r',{},'bad',{},'luminance',{},'light',{});
fibres_out.bothlight = struct('fibre_nr',{},'x',{},'y',{},'x_unaligned',{},'y_unaligned',{},'r',{},'bad',{},'luminance',{},'light',{});
fibres_out.nolight = struct('fibre_nr',{},'x',{},'y',{},'x_unaligned',{},'y_unaligned',{},'r',{},'bad',{},'luminance',{},'light',{});

  %Tworzymy zbiór wszystkich włókien ze wszystkich świateł.
full_dataset = fibres_in.backlight;
full_dataset = [full_dataset fibres_in.frontlight];
full_dataset = [full_dataset fibres_in.bothlight];
full_dataset = [full_dataset fibres_in.nolight];


  %Teraz szukamy włókien położonych blisko siebie
current_fibre_nr = 1;

while length(full_dataset)
  specimen = full_dataset(1);
  
  X = [full_dataset.x];
  Y = [full_dataset.y];
  
  I = find(((X-specimen.x).^2 + (Y-specimen.y).^2) <= (max_displacement_px^2));
  
    %Jak znajdziemy, to je zapisujemy w odpowiednim miejscu
  results = full_dataset(I);
  
  fibres_out.all(current_fibre_nr).backlight = [];
  fibres_out.all(current_fibre_nr).frontlight = [];
  fibres_out.all(current_fibre_nr).bothlight = [];
  fibres_out.all(current_fibre_nr).nolight = [];
  fibres_out.all(current_fibre_nr).x = NaN;
  fibres_out.all(current_fibre_nr).y = NaN;
  fibres_out.all(current_fibre_nr).x_unaligned = NaN;
  fibres_out.all(current_fibre_nr).y_unaligned = NaN;
  fibres_out.all(current_fibre_nr).r = NaN;
  fibres_out.all(current_fibre_nr).light = NaN;
  level = 0;
  
    %Przepisujemy dane światłowe i wybieramy reprezentację współrzędnych dla "all"
  for j=1:length(results)
    results(j).fibre_nr = current_fibre_nr;
    switch results(j).light
      case 0
          fibres_out.backlight(end+1) = results(j);
          fibres_out.all(current_fibre_nr).backlight = results(j);
          if (level <= light_priority(1))
            fibres_out.all(current_fibre_nr).x = results(j).x;
            fibres_out.all(current_fibre_nr).y = results(j).y;
            fibres_out.all(current_fibre_nr).x_unaligned = results(j).x_unaligned;
            fibres_out.all(current_fibre_nr).y_unaligned = results(j).y_unaligned;
            fibres_out.all(current_fibre_nr).r = results(j).r;
            fibres_out.all(current_fibre_nr).light = 0;
            level = light_priority(1);
          end;
      case 1
          fibres_out.frontlight(end+1) = results(j);
          fibres_out.all(current_fibre_nr).frontlight = results(j);
          if (level <= light_priority(2))
            fibres_out.all(current_fibre_nr).x = results(j).x;
            fibres_out.all(current_fibre_nr).y = results(j).y;
            fibres_out.all(current_fibre_nr).x_unaligned = results(j).x_unaligned;
            fibres_out.all(current_fibre_nr).y_unaligned = results(j).y_unaligned;
            fibres_out.all(current_fibre_nr).r = results(j).r;
            fibres_out.all(current_fibre_nr).light = 1;
            level = light_priority(2);
          end;
      case 2        
          fibres_out.bothlight(end+1) = results(j);
          fibres_out.all(current_fibre_nr).bothlight = results(j);
          if (level <= light_priority(3))
            fibres_out.all(current_fibre_nr).x = results(j).x;
            fibres_out.all(current_fibre_nr).y = results(j).y;
            fibres_out.all(current_fibre_nr).x_unaligned = results(j).x_unaligned;
            fibres_out.all(current_fibre_nr).y_unaligned = results(j).y_unaligned;
            fibres_out.all(current_fibre_nr).r = results(j).r;
            fibres_out.all(current_fibre_nr).light = 2;
            level = light_priority(3);
          end;
      case 3
          fibres_out.nolight(end+1) = results(j);
          fibres_out.all(current_fibre_nr).nolight = results(j);
          if (level <= light_priority(4))
            fibres_out.all(current_fibre_nr).x = results(j).x;
            fibres_out.all(current_fibre_nr).y = results(j).y;
            fibres_out.all(current_fibre_nr).x_unaligned = results(j).x_unaligned;
            fibres_out.all(current_fibre_nr).y_unaligned = results(j).y_unaligned;
            fibres_out.all(current_fibre_nr).r = results(j).r;
            fibres_out.all(current_fibre_nr).light = 3;
            level = light_priority(4);
          end;
      endswitch;
  end; 
 

  current_fibre_nr = current_fibre_nr+1;
  full_dataset(I) = [];
end;

  

