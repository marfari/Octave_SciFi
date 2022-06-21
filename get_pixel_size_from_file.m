function pixel_size = get_pixel_size_from_file(path)

try
  dpi = csvread([path '/dpi.csv']);
catch 
  dpi = 0;
end_try_catch
  
if isempty(dpi)
  dpi = 0;
end;
dpi = dpi(1);
if isnan(dpi)
  dpi = 0;
end;

if dpi == 0
  pixel_size = 0;
else
  pixel_size = 1000*25.4/dpi;
end;
  
