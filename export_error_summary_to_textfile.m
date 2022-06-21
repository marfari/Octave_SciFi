function export_error_summary_to_textfile(fibres, filename, print_zeros)

file = fopen(filename,'w');

error_count = 0;
wrong_neighbors_count = 0;
backlight_not_detected = 0;
frontlight_not_detected = 0;
bothlight_not_detected = 0;
backlight_low_light = 0;
bothlight_low_light = 0;
diameter_too_low = 0;
diameter_too_high = 0;
neighbor_distance_too_low = 0;
neighbor_distance_too_high = 0;
neighbor_angle_wrong = 0;
out_of_bounds1 = 0;
out_of_bounds2 = 0;
outlying_area1 = 0;
outlying_area2 = 0;

for i=1:length(fibres)
            if fibres(i).errors.error_count
                error_count = error_count+1;
            end;
            if fibres(i).errors.wrong_neighbors_count
                wrong_neighbors_count = wrong_neighbors_count+1;
            end;
            if fibres(i).errors.backlight_not_detected
                backlight_not_detected = backlight_not_detected+1;
            end;
            if fibres(i).errors.frontlight_not_detected
                frontlight_not_detected = frontlight_not_detected+1;
            end;
            if fibres(i).errors.bothlight_not_detected
                bothlight_not_detected = bothlight_not_detected+1;
            end;
            if fibres(i).errors.backlight_low_light
                backlight_low_light = backlight_low_light+1;
            end;
            if fibres(i).errors.bothlight_low_light
                bothlight_low_light = bothlight_low_light+1;
            end;
            if fibres(i).errors.diameter_too_low
                diameter_too_low = diameter_too_low+1;
            end;
            if fibres(i).errors.diameter_too_high
                diameter_too_high = diameter_too_high+1;
            end;
            if fibres(i).errors.neighbor_distance_too_low
                neighbor_distance_too_low = neighbor_distance_too_low+1;
            end;
            if fibres(i).errors.neighbor_distance_too_high
                neighbor_distance_too_high = neighbor_distance_too_high+1;
            end;
            if fibres(i).errors.neighbor_angle_wrong
                neighbor_angle_wrong = neighbor_angle_wrong+1;
            end; 
            if fibres(i).errors.out_of_bounds1
                out_of_bounds1 = out_of_bounds1+1;
            end; 
            if fibres(i).errors.out_of_bounds2
                out_of_bounds2 = out_of_bounds2+1;
            end; 
            outlying_area1 = outlying_area1 + fibres(i).errors.outlying_area1;
            outlying_area2 = outlying_area2 + fibres(i).errors.outlying_area2;

end;

if error_count || print_zeros
  fprintf(file, 'total probl. fibres: %d\r\n\r\n', error_count);  %this one is always prointed
end;
if out_of_bounds1 || print_zeros
  fprintf(file, 'out of SiPM bounds: %d\r\n\r\n', out_of_bounds1);
%end;
%if outlying_area1 > 0
  fprintf(file, 'outlying area: %1.2fmm$^2$ = %1.1f fibres\r\n\r\n', outlying_area1, outlying_area1/(0.125^2*pi));
end;

if out_of_bounds2 || print_zeros
  fprintf(file, 'out of SiPM bounds inc. tolerance: %d\r\n\r\n', out_of_bounds2);
%end;
%if outlying_area2 > 0
  fprintf(file, 'outlying area: %1.2fmm$^2$ = %1.1f fibres\r\n\r\n', outlying_area2, outlying_area2/(0.125^2*pi));
end;

if wrong_neighbors_count || print_zeros
  fprintf(file, 'wrong neighbours count: %d\r\n\r\n', wrong_neighbors_count);
end;
if neighbor_distance_too_low || print_zeros
  fprintf(file, 'neighbour distance too low: %d\r\n\r\n', neighbor_distance_too_low);
end;
if neighbor_distance_too_high || print_zeros
  fprintf(file, 'neighbour distance too high: %d\r\n\r\n', neighbor_distance_too_high);
end;
if neighbor_angle_wrong || print_zeros
  fprintf(file, 'neighbour angle wrong: %d\r\n\r\n', neighbor_angle_wrong);
end;
if backlight_not_detected || print_zeros
  fprintf(file, 'backlight not detected: %d\r\n\r\n', backlight_not_detected);
end;
if frontlight_not_detected || print_zeros
  fprintf(file, 'frontlight not detected: %d\r\n\r\n', frontlight_not_detected);
end;
if bothlight_not_detected || print_zeros
  fprintf(file, 'bothlight not detected: %d\r\n\r\n', bothlight_not_detected);
end;
if backlight_low_light || print_zeros
  fprintf(file, 'backlight low light: %d\r\n\r\n', backlight_low_light);
end;
if bothlight_low_light || print_zeros
  fprintf(file, 'bothlight low light: %d\r\n\r\n', bothlight_low_light);
end;
if diameter_too_low || print_zeros
  fprintf(file, 'diameter too low: %d\r\n\r\n', diameter_too_low);
end;
if diameter_too_high || print_zeros
  fprintf(file, 'diameter too high: %d\r\n\r\n', diameter_too_high);
end;

fclose(file);
