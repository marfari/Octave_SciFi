function fibres = do_everything(config)
%This is the main data processing functions

scripts_ver = version();

%  ********* We prepare directories *********

tic

raw_file_header = sprintf('%s/raw_results',config.data_directory);
exported_file_header = sprintf('%s/exported_results',config.data_directory);
result_file_header = sprintf('%s/mat_results',config.data_directory);
%picture_file_header = sprintf('%s/pictures',config.data_directory);  %At the moment we don't produce control images

mkdir(result_file_header);
%mkdir(picture_file_header);

  %Mat name - if not given, try to load from file
mat_name = config.mat_name;
if length(mat_name) == 0
  mat_name = load_mat_name_from_file(exported_file_header);
end;
if length(mat_name) == 0
  mat_name = 'Unknown';
end;

  %Produce unix-filesystem-compatible mat name
mat_name_nospaces = mat_name;
I=find(mat_name_nospaces == ' '); mat_name_nospaces(I) = '_';  
I=find(mat_name_nospaces == '('); mat_name_nospaces(I) = [];  
I=find(mat_name_nospaces == ')'); mat_name_nospaces(I) = [];  
I=find(mat_name_nospaces == ':'); mat_name_nospaces(I) = [];  

	%Theoretical pixel size. 
  %We look for it at dpi.csv. If not found, we take the standard value from config.
pixel_size_um = get_pixel_size_from_file(exported_file_header);

if pixel_size_um == 0
  pixel_size_um = config.pixel_size_um;
end;

disp(sprintf('  Pixel size is %1.2f um', pixel_size_um));

  %This figure will be used for plotting and saving plots
  %It can be hidden on some platforms
fig_no = figure(1);
%screen_pos = get(gcf,'position');
%set(gcf,'position', [screen_pos(1:2) 1024 768]);
set(gcf,'paperorientation','landscape');
set(gcf,'papersize',[11.0 8.5]);
set(gcf, 'paperunits', 'normalized');
set(gcf, 'paperposition', [0 0 1 1]);
%set(fig_no, 'visible','off');

%  ******** Loading the fibre data and correcting luminance ********

disp('Loading data...');

[fibres lights] = load_csv_data(exported_file_header);
if config.use_fixing_pins
  pins = load_pin_csv_data(exported_file_header);
else
  pins = [];
end;

disp('Deleting redundant fibres...');

[fibres deleted] = delete_redundant_fibres(fibres);

disp('  Illumination types present:');
if (lights.backlight_present)
  disp(sprintf('    Backlight: %d fibres, %d were redundant',length(fibres.backlight), deleted.backlight));
  fibres.backlight = correct_luminance(fibres.backlight);
end;
if (lights.frontlight_present)
  disp(sprintf('    Frontlight: %d fibres, %d were redundant',length(fibres.frontlight), deleted.frontlight));
  fibres.frontlight = correct_luminance(fibres.frontlight);
end;
if (lights.bothlight_present)
  disp(sprintf('    Bothlight: %d fibres, %d were redundant',length(fibres.bothlight), deleted.bothlight));
  fibres.bothlight = correct_luminance(fibres.bothlight);
end;
if (lights.nolight_present)
  disp(sprintf('    Nolight: %d fibres, %d were redundant',length(fibres.nolight), deleted.nolight));
  fibres.nolight = correct_luminance(fibres.nolight);
end;


%  ******** Linking fibres from various illuminations ********

disp('Merging fibres with various illuminations...');

fibres = make_master_fibres(fibres, pixel_size_um, config.light_priorities);	
disp(sprintf('   %d fibres found after merging', length(fibres.all)));


%  ************** Applying light-related position corrections **************
disp('Adjusting positions from various illuminations...');
pos_errors = check_displacements(fibres, config.light_priorities, 1, [result_file_header '/']);
fibres = correct_displacements(fibres, pos_errors); 
 
%  ******** Realigning coordinates *********

disp('Aligning mat...');

  %Pre-rotation
if config.pre_rotate_deg ~= 0
  fibres = rotate_mat(fibres, config.pre_rotate_deg*pi/180);
  pins = rotate_pins(pins, config.pre_rotate_deg*pi/180);     
end;

  %Mat centering
%[fibres displacement_px] = center_mat(fibres, pixel_size_um, config.y_offset_mm);
[fibres displacement_px] = center_mat(fibres, pixel_size_um, 0);
pins = displace_pins(pins, displacement_px);

  %Mat rotation basing on fibres
if config.autorotate
  %disp('Mat autorotation...');
  rotation_rad = calculate_rotation_from_fibres(fibres.all);
  disp(sprintf(' Rotation correction basing on fibres: %d deg', rotation_rad*180/pi));
  fibres = rotate_mat(fibres, rotation_rad);
  pins = rotate_pins(pins, rotation_rad);
    %After rotation, we must realign the mat
  %[fibres displacement_px] = center_mat(fibres, pixel_size_um, config.y_offset_mm);
  [fibres displacement_px] = center_mat(fibres, pixel_size_um, 0);
  pins = displace_pins(pins, displacement_px);
end;

  %Corrections based on fixing pins
mat_was_flipped = 0;
if config.use_fixing_pins
  if length(pins) > 0
    [displacement_px pins] = calculate_displacement_from_pins(pins, config.fixing_pins_pos, pixel_size_um);
    disp(sprintf(' Position correction basing on fixing points: [%d %d] mm', displacement_px(1)*pixel_size_um/1000, displacement_px(2)*pixel_size_um/1000));
    fibres = displace_mat(fibres, displacement_px);
    pins = displace_pins(pins, displacement_px);  
      %Rotation correction
    if config.use_fixing_pins > 1
      rotation_rad = calculate_rotation_from_pins(pins);
      disp(sprintf(' Rotation correction basing on fixing points: %d deg', rotation_rad*180/pi));
      fibres = rotate_mat(fibres, rotation_rad);
      pins = rotate_pins(pins, rotation_rad);
      [displacement_px pins] = calculate_displacement_from_pins(pins, config.fixing_pins_pos, pixel_size_um);
      disp(sprintf(' Post-rotate position correction basing on fixing points: [%d %d] mm', displacement_px(1)*pixel_size_um/1000, displacement_px(2)*pixel_size_um/1000));
      fibres = displace_mat(fibres, displacement_px);
      pins = displace_pins(pins, displacement_px);  
    end;
      %Checking if mat was flipped by 180 degrees and correcting it
      y_mean = mean([fibres.all.y]);
      if (y_mean > 0)
        disp(' Mat was flipped! Will be rotated by 180 degrees...');
        mat_was_flipped = 1;
        fibres = rotate_mat(fibres, pi());
        pins = rotate_pins(pins, pi());
      end;
      
  else
    disp('  No fixing points found, the mat will be center-aligned.');
  end;
  
end;


%  ******** Fibre layers *********

disp('Assigning layers...');
if config.do_cut
  [layer_fits layer_count] = generate_layer_fits(fibres.all, pixel_size_um, config.mat_ends, [result_file_header '/all'], fig_no);
  disp(sprintf('  Layer count: %d', layer_count));
  fibres.all = assign_layers(fibres.all, layer_fits, pixel_size_um, config.mat_ends, [result_file_header '/all'], fig_no);		
else
  [layer_fits layer_count] = generate_layer_fits(fibres.all, pixel_size_um, [], [result_file_header '/all'], fig_no);
  disp(sprintf('  Layer count: %d', layer_count));
  fibres.all = assign_layers(fibres.all, layer_fits, pixel_size_um, [], [result_file_header '/all'], fig_no);		
end;


  %Here we could do the same for various illuminations, like:
%if ~isempty(fibres.backlight)
%  fibres.backlight = assign_layers(fibres.backlight, layer_fits);		
%end;
%However, we have all the data in fibres.all

%  ******** Cutting mats *********

if config.do_cut
  disp('Applying cut...');
    fibres.all = cut_mat(fibres.all, config.mat_ends, pixel_size_um);
  else
    fibres.all = cut_mat(fibres.all, [-1e+9 1e+9], pixel_size_um); %'false cut' just to produce 'nevermind' field
  end;

    
  %  ******** Neighborhood ********

  disp('Finding neighborhood');
  mean_distance = mean_fibre_distance(fibres.all);		
  disp(sprintf('  Preliminary mean fibre distance: %1.2f um',mean_distance*pixel_size_um));
  fibres.all = find_neighborhood(fibres.all, mean_distance);
  mean_distance_error = neighborhood_QA(fibres.all, pixel_size_um, mean_distance, [result_file_header '/all'], 0);  %We don't generate plots this time
  mean_distance = mean_distance + mean_distance_error;	
  disp(sprintf('  Final mean fibre distance: %f um',mean_distance*pixel_size_um));

  if config.do_neighborhood_QA
    disp('Processing neighborhood...');
    
    fibres.all = find_neighborhood(fibres.all, mean_distance);
    neighborhood_QA(fibres.all, pixel_size_um, mean_distance, [result_file_header '/all'], fig_no);
  end;

  %  ******** QA ********

  disp('Mat QA...');

  Simon_QA(fibres.all, pixel_size_um, layer_count, [result_file_header '/all'], fig_no);

  if config.do_mat_QA
    mat_QA(fibres.all, pixel_size_um, [result_file_header '/all'], fig_no);
  end;

  if config.do_mat_QA2
    fibres.all = mat_QA2(fibres.all, lights, pixel_size_um, length(pins), [result_file_header '/all'], fig_no);
  end;

  %  ******** Generate report files ********

  disp('Saving data and generating report');
  export_fibres_to_csv(fibres.all, pixel_size_um, [result_file_header '/merged_fibres_all_um_' mat_name_nospaces '.csv']);
  export_fibres_to_csv(fibres.all, 1, [result_file_header '/merged_fibres_all_pixels_' mat_name_nospaces '.csv']);
  export_pins_to_csv(pins, pixel_size_um, [result_file_header '/pins_all_um_' mat_name_nospaces '.csv']);
  export_pins_to_csv(pins, 1, [result_file_header '/pins_all_pixels_' mat_name_nospaces '.csv']);
  export_errors_to_csv(fibres.all, [result_file_header '/merged_fibre_errors_' mat_name_nospaces '.csv']);
  export_error_summary_to_textfile(fibres.all,[result_file_header '/merged_fibre_errors_summary.txt'], 0); %this file is compiled into tex
  export_error_summary_to_textfile(fibres.all,[result_file_header '/merged_fibre_errors_summary_' mat_name_nospaces '.txt'], 1); %and this one is to be copied.
    

if config.compile_tex
  generate_tex_report([result_file_header '/'], mat_name, config.report_file, scripts_ver);
end;
  

%We can uncomment this line if we wish to save all data for debug
%save ([output_file_header '/all_data']);

time = toc;
disp(sprintf('Calculations completed in %1.1f seconds',time));
disp('Ready!');
