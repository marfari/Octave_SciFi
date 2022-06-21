function [fibres displacement_px] = center_mat(fibres, pixel_size_um, y_offset_mm);

y_offset_px = y_offset_mm*1000/pixel_size_um;

x_mean = mean([fibres.all.x]);
y_mean = mean([fibres.all.y]);

displacement_px = [-x_mean -y_mean+y_offset_px];

fibres = displace_mat(fibres, displacement_px);
