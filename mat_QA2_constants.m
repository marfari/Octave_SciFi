%This scripts defines constants for Mat QA 2

threshold_light_back    = 0.75;   %luminance threshold for backlight
threshold_light_both    = 0.75;   %luminance threshold for bothlight
threshold_diameter      = 40;     %the margin around mean radius of all fibres
threshold_distance      = 50;     %the margin around mean distance
threshold_angle         = 10;     %the margin around 0/60/120 degrees
y_boundaries            = [-0.6875-4.75 0.6875-4.75; -0.6125-4.75 0.6125-4.75];   
    %y_boundaries:    the vertical limits all the fibres must fit within
    %y_boundaries:    the bounds are defined by 1) SIPM active area and 2) SIPM active area - tolerance
    
%Switches for running particular tests
check.wrong_neighbors_count       = 0;
check.frontlight_not_detected     = 1;
check.backlight_not_detected      = 1;
check.backlight_low_light         = 1;
check.bothlight_not_detected      = 1;
check.bothlight_low_light         = 1;
check.diameter_too_low            = 1;
check.diameter_too_high           = 1;
check.neighbor_distance_too_high  = 1;
check.neighbor_distance_too_low   = 1;
check.neighbor_angle_wrong        = 1;
check.out_of_bounds1              = 1;
check.out_of_bounds2              = 1;

