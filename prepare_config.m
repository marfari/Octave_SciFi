function config = prepare_config()
%Make a default config structure for do_everything()

config.data_directory = '.';            %data_directory:  main directory with data and results (the actual data is in a subdirectory 'exported_results/' of this)
config.mat_name = 'unknown';            %mat_name:        default mat name as in database. This should be overriden by mat name given by input file.
config.pixel_size_um =  2.64; %9600 dpi %pixel_size_um:   theoretical pixel size in micrometers; this might be overriden by dpi setting read from file or corrected in the future if we use ruler
config.have_ruler = 0;                  %have_ruler:      are we going to process ruler? (unavailable now)
config.um_per_tick = -634.9;            %um_per_tick:     distance between ruler ticks
config.light_priorities = [2 4 3 1];    %light_priorities: gives the priority of different illuminations (Back, Front, Both, None) for master fibre selection
config.do_cut = 1;                      %do_cut:          are we going to cut mat ends? 
%config.mat_ends = [-70 70];             %mat_ends:        positions of the mat ends in milimeters related to mat's centre. This is where the cut will be done.
config.mat_ends = [-65.3 65.3];        %mat_ends:        positions of the mat ends in milimeters related to mat's centre. This is where the cut will be done.
config.pre_rotate_deg = 0.0;            %pre_rotate_deg:  initially rotate mat by specified angle to correct mechanical misalignment. Basically debug use only.
config.autorotate = 1;                  %autorotate:      rotate mat basing on layer fits to make it vertical. May be helpful if no pins are present.
config.use_fixing_pins = 2;             %fixing_pins:     1- use fixation points for finding the mat's centre; 2- apply also rotation correction
                                                          %MUST BE set to 2 to check mat boundaries properly
config.fixing_pins_pos = [-50.0 0; 0.0 0; 50.0 0];
                                        %fixing_points_pos: positions of fixing points in mm [x y] related to datum (see y_offset_mm)
%y_boundaries -> see mat_QA2_constants
config.do_neighborhood_QA = 2;          %do_neighborhood_QA:  are we going to make advanced neighborhood QA? 0-nope, 1-yes, (2-yes, independently for each illumination - unavailable now)
config.do_mat_QA = 2;                   %do_mat_QA:       are we going to ake advanced mat QA: 0-nope, 1-yes, (2-yes, independently for each illumination - unvailable now)
                                        %                 *Remark* basic 'Simon's QA' is performed independently of this setting 
config.do_mat_QA2 = 1;                  %do_mat_QA2:      perform fibre classification
config.compile_tex = 1;                 %compile_tex      compile tex report
config.report_file = 'report_full';     %report_file      filename of a report template - without extension

    



