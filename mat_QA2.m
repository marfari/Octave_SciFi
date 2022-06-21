function fibres = mat_QA2(fibres, lights, pixel_size_um, pins_present, file_header, fig_no)
%Robi bardziej zaawansowan� kontrol� jako�ci mat:
% - z�a liczba s�siad�w
% - w��kno niezdetekowane przy o�w. przednim
% - w��kno niezdetekowane przy o�wietleniu tylnym
% - w��kno za ciemne przy o�wietleniu tylnym
% - za ma�a �rednica w��kna
% - za du�a �rednica w��kna
% - z�a pozycja s�siada
%Potrzebuje danych po przej�ciu przez merge_fibre_sources

mat_QA2_constants;  %load constants

%Mean fibre diameter
diameters = [fibres.r] * 2 *pixel_size_um;
mean_diameter = mean(diameters);


%plot_fmt = DefaultAxesFormat();
plot_fmt = WideAxesFormat();

%Check layer count
nr_layers = max([fibres.layer]);



for i=1:length(fibres)
    
        %Standard error record
    error_record.error_count = 0;
    error_record.wrong_neighbors_count = 0;
    error_record.backlight_not_detected = 0;
    error_record.frontlight_not_detected = 0;
    error_record.bothlight_not_detected = 0;
    error_record.backlight_low_light = 0;
    error_record.bothlight_low_light = 0;
    error_record.diameter_too_low = 0;
    error_record.diameter_too_high = 0;
    error_record.neighbor_distance_too_low = 0;
    error_record.neighbor_distance_too_high = 0;
    error_record.neighbor_angle_wrong = 0;
    error_record.out_of_bounds1 = 0;
    error_record.out_of_bounds2 = 0;
    error_record.outlying_area1 = 0;
    error_record.outlying_area2 = 0;

 
    if fibres(i).nevermind == 0  %Skip neverminds.
   
          %Check neighbour count
      layer = fibres(i).layer;
      if (layer == 1) || (layer == nr_layers)
          expected_neighbor_cnt = 4;
      else
          expected_neighbor_cnt = 6;
      end;
      neighbors = fibres(i).neighbors;
      neighbor_cnt = length(find([neighbors.fibre_no] ~= 0));
      if (check.wrong_neighbors_count) && (neighbor_cnt ~= expected_neighbor_cnt)
          error_record.error_count = error_record.error_count + 1;
          error_record.wrong_neighbors_count = 1;
      end;
      
          %Not detected with frontlight
      if lights.frontlight_present        
        if (check.frontlight_not_detected) && (isempty(fibres(i).frontlight))
            error_record.error_count = error_record.error_count + 1;
            error_record.frontlight_not_detected = 1;
        end;
      end;

          %Not detected with backlight or too dark
      if lights.backlight_present        
        if (check.backlight_not_detected) && (isempty(fibres(i).backlight))
            error_record.error_count = error_record.error_count + 1;
            error_record.backlight_not_detected = 1;
        end;
        if !isempty(fibres(i).backlight)
          if (check.backlight_low_light) &&  (fibres(i).backlight.luminance < threshold_light_back) 
              error_record.error_count = error_record.error_count + 1;
              error_record.backlight_low_light = 1;
          end;
        end;
      end;
      
          %Not detected with bothlight or too dark
      if lights.bothlight_present        
        if (check.bothlight_not_detected) && (isempty(fibres(i).bothlight))
            error_record.error_count = error_record.error_count + 1;
            error_record.bothlight_not_detected = 1;  
        end; 
        if !isempty(fibres(i).bothlight)
          if (check.bothlight_low_light) && (fibres(i).bothlight.luminance < threshold_light_both)        
              error_record.error_count = error_record.error_count + 1;
              error_record.bothlight_low_light = 1;
          end;
        end;
      end;
      
          %Radius too small
      %if (fibres(i).r*pixel_size_um) < (threshold_diameter_low/2)  
      if (check.diameter_too_low) && ((fibres(i).r*pixel_size_um) < ((mean_diameter - threshold_diameter)/2))  
          error_record.error_count = error_record.error_count + 1;
          error_record.diameter_too_low = 1;
      end;

         %Radius too big
      %if (fibres(i).r*pixel_size_um) > (threshold_diameter_high/2) 
      if (check.diameter_too_high) && ((fibres(i).r*pixel_size_um) > ((mean_diameter + threshold_diameter)/2)) 
          error_record.error_count = error_record.error_count + 1;
          error_record.diameter_too_high = 1;
      end;
       
         %Neighbour too far
      for n=1:6
          if (check.neighbor_distance_too_high) && ((fibres(i).neighbors(n).dr*pixel_size_um > threshold_distance))  
              error_record.error_count = error_record.error_count + 1;
              error_record.neighbor_distance_too_high = error_record.neighbor_distance_too_high + 1;
          end;
      end;

          %Neighbour too close
      for n=1:6
          if (check.neighbor_distance_too_low) && ((fibres(i).neighbors(n).dr*pixel_size_um < -threshold_distance))  
              error_record.error_count = error_record.error_count + 1;
              error_record.neighbor_distance_too_low = error_record.neighbor_distance_too_low + 1;
          end;
      end;

          %Wrong neighbour angle
      for n=1:6
          if (check.neighbor_angle_wrong) && ( (fibres(i).neighbors(n).dphi < -threshold_angle) || ...
             (fibres(i).neighbors(n).dphi > threshold_angle) )    
              error_record.error_count = error_record.error_count + 1;
              error_record.neighbor_angle_wrong = error_record.neighbor_angle_wrong + 1;
          end;
      end;

          %Wrong location vs SIPM matrix; two sets of constraints
      if pins_present
          if (check.out_of_bounds1) && ...
              ( ((fibres(i).y*pixel_size_um/1000) < y_boundaries(1,1)) || ((fibres(i).y*pixel_size_um/1000) > y_boundaries(1,2)) )
              error_record.error_count = error_record.error_count + 1;
              error_record.out_of_bounds1 = 1;  
          end;
          if (check.out_of_bounds2) && ...
              ( ((fibres(i).y*pixel_size_um/1000) < y_boundaries(2,1)) || ((fibres(i).y*pixel_size_um/1000) > y_boundaries(2,2)) )
              error_record.error_count = error_record.error_count + 1;
              error_record.out_of_bounds2 = 1;
          end;
          
          %Here we calculate outlying area
%          error_record.outlying_area1 = error_record.outlying_area1 + circular_segment_area(fibres(i).r*pixel_size_um/1000, ...
%                                                                        y_boundaries(1,1)-(fibres(i).y*pixel_size_um/1000)); 
%          error_record.outlying_area1 = error_record.outlying_area1 + circular_segment_area(fibres(i).r*pixel_size_um/1000, ...
%                                                                        -y_boundaries(1,2)+(fibres(i).y*pixel_size_um/1000));   
%          error_record.outlying_area2 = error_record.outlying_area2 + circular_segment_area(fibres(i).r*pixel_size_um/1000, ...
%                                                                        y_boundaries(2,1)-(fibres(i).y*pixel_size_um/1000)); 
%          error_record.outlying_area2 = error_record.outlying_area2 + circular_segment_area(fibres(i).r*pixel_size_um/1000, ...
%                                                                        -y_boundaries(2,2)+(fibres(i).y*pixel_size_um/1000));   
          error_record.outlying_area1 = error_record.outlying_area1 + circular_segment_area(0.125, ...
                                                                        y_boundaries(1,1)-(fibres(i).y*pixel_size_um/1000)); 
          error_record.outlying_area1 = error_record.outlying_area1 + circular_segment_area(0.125, ...
                                                                        -y_boundaries(1,2)+(fibres(i).y*pixel_size_um/1000));   
          error_record.outlying_area2 = error_record.outlying_area2 + circular_segment_area(0.125, ...
                                                                        y_boundaries(2,1)-(fibres(i).y*pixel_size_um/1000)); 
          error_record.outlying_area2 = error_record.outlying_area2 + circular_segment_area(0.125, ...
                                                                        -y_boundaries(2,2)+(fibres(i).y*pixel_size_um/1000));             
          
      end;   
   end; %Non-neverminds  
   

        %Save data
   fibres(i).errors = error_record;   
end;    %for fibres


all_errors = [fibres.errors];
all_X = [fibres.x]*pixel_size_um/1000;
all_Y = [fibres.y]*pixel_size_um/1000;

%Cut display to non-neverminds
all_nevermind = [fibres.nevermind];
I=find(all_nevermind == 0);
all_errors = all_errors(I);
all_X = all_X(I);
all_Y = all_Y(I);


indexes = find([all_errors.error_count]); %Numbers of suspected fibres

figure(fig_no);
clf;
plot(all_X, all_Y,'.','Color',[0.85 0.85 0.85]);
hold on;

    %Wrong distances or angles
indexes = find([all_errors.neighbor_distance_too_high]); %Numbers of suspected fibres
if(indexes)
    ax(1) = plot(all_X(indexes), all_Y(indexes),'+','Color',[1 0.5 0]); 
end;
indexes = find([all_errors.neighbor_distance_too_high]); %Numbers of suspected fibres
if(indexes)
    ax(1) = plot(all_X(indexes), all_Y(indexes),'+','Color',[1 0.5 0]); 
end;
indexes = find([all_errors.neighbor_angle_wrong]); %Numbers of suspected fibres
if(indexes)
    ax(1) = plot(all_X(indexes), all_Y(indexes),'+','Color',[1 0.5 0]); 
end;

    %Wrong neighbour count
indexes = find([all_errors.wrong_neighbors_count]); %Numbers of suspected fibres
if(indexes)
    ax(2) = plot(all_X(indexes), all_Y(indexes),'+r'); 
end;

    %Low transmission
if lights.backlight_present        
  indexes = find([all_errors.backlight_low_light]); %Numbers of suspected fibres
  if(indexes)
      ax(3) = plot(all_X(indexes), all_Y(indexes),'o','Color',[0.5 0 1]);
  end;
end;
if lights.bothlight_present        
  indexes = find([all_errors.bothlight_low_light]); %Numbers of suspected fibres
  if(indexes)
      ax(3) = plot(all_X(indexes), all_Y(indexes),'o','Color',[0.5 0 1]);
  end;
end;


    %Wrong diameter
indexes = find([all_errors.diameter_too_low]); %Numbers of suspected fibres
if(indexes)
    ax(4) = plot(all_X(indexes), all_Y(indexes),'o','Color',[1 0.5 0]);
end;
indexes = find([all_errors.diameter_too_high]); %Numbers of suspected fibres
if(indexes)
    ax(4) = plot(all_X(indexes), all_Y(indexes),'o','Color',[1 0.5 0]);
 end; 

    %Not found in front/both/backlight
indexes = find([all_errors.frontlight_not_detected]); %Numbers of suspected fibres
if(indexes)
    ax(5) = plot(all_X(indexes), all_Y(indexes),'o','Color',[0.5 0.5 0.5]);
end;    
indexes = find([all_errors.backlight_not_detected]); %Numbers of suspected fibres
if(indexes)
    ax(6) = plot(all_X(indexes), all_Y(indexes),'ok');
end;
indexes = find([all_errors.bothlight_not_detected]); %Numbers of suspected fibres
if(indexes)
    ax(7) = plot(all_X(indexes), all_Y(indexes),'o','Color',[0.25 0.25 0.25]);
end;

   %Wrong placement
indexes = find([all_errors.out_of_bounds1]); %Numbers of suspected fibres
if(indexes)
    ax(8) = plot(all_X(indexes), all_Y(indexes),'x','Color',[0 0 0]);
end;
indexes = find([all_errors.out_of_bounds2]); %Numbers of suspected fibres
if(indexes)
    ax(9) = plot(all_X(indexes), all_Y(indexes),'x','Color',[0.5 0.5 0.5]);
end;


axis([min(all_X), max(all_X), min(all_Y)-0.5, max(all_Y)+1.5]);

legends{1} = 'Neighbour position violations';
legends{2} = 'Wrong neighbour count';
legends{3} = 'Low transmission';
legends{4} = 'Wrong diameter';
legends{5} = 'Not detected in frontlight';
legends{6} = 'Not detected in backlight';
legends{7} = 'Not detected in bothlight';
legends{8} = 'Position out of SiPM bounds';
legends{9} = 'Position out of SiPM bounds incl. tolerance';

  %Boundary lines only if fixing points are present
if pins_present
  plot([min(all_X) max(all_X)], [y_boundaries(1,1) y_boundaries(1,1)], '--r');
  plot([min(all_X) max(all_X)], [y_boundaries(1,2) y_boundaries(1,2)], '--r');
  plot([min(all_X) max(all_X)], [y_boundaries(2,1) y_boundaries(2,1)], '--g');
  plot([min(all_X) max(all_X)], [y_boundaries(2,2) y_boundaries(2,2)], '--g');
end;
  

%legend(ax(find(ax ~= 0)), legends{find(ax ~= 0)},'Location','SouthOutside');

%title('Found problems');
if pins_present
  title('Fibre matrix errors and SiPM match');
else
  title('Fibre matrix errors');
end;  
xlabel('Fibre X position [mm]');
ylabel('Fibre Y position [mm]');
if pins_present
  axis([min(all_X) max(all_X) y_boundaries(1,1)-0.2 y_boundaries(1,2)+0.2]);
end;

hold off;

FormatAxesEx(gcf,gca,plot_fmt, [file_header '_mat_QA_main']);




