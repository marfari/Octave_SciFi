function data = load_fibre_csv_data(dirname)

raw_fibre_data = load_backfront_csv_file([dirname '/fibers_each.csv']);

%data = stitch_data;
last_pos = 0;
last_view_nr = 0;

%Tworzymy pomocnicz� tabel� pozycji przy okazji inicjalizujemy tablice w��kien
	data.backlight = struct('fibre_nr',{},'x',{},'y',{},'x_unaligned',{},'y_unaligned',{},'r',{},'bad',{},'luminance',{},'light',{},'base_position',{});
	data.frontlight = struct('fibre_nr',{},'x',{},'y',{},'x_unaligned',{},'y_unaligned',{},'r',{},'bad',{},'luminance',{},'light',{},'base_position',{});
  data.bothlight = struct('fibre_nr',{},'x',{},'y',{},'x_unaligned',{},'y_unaligned',{},'r',{},'bad',{},'luminance',{},'light',{},'base_position',{});
  data.nolight = struct('fibre_nr',{},'x',{},'y',{},'x_unaligned',{},'y_unaligned',{},'r',{},'bad',{},'luminance',{},'light',{},'base_position',{});

for i=1:size(raw_fibre_data,1)
  
	clear record;
	row = raw_fibre_data(i,:);
	light = row(1);
  record.light = light;
	%servo_pos = row(2);
	record.fibre_nr = row(3); %Ten numer włókna idzie do przenumerowania
  record.base_position = row(2);
	record.x = row(4) + row(2);
  record.x_unaligned = record.x;
	%record.y = 1536-row(5);
	record.y = -row(5);
  record.y_unaligned = record.y;
	record.r = row(6);
	record.bad = row(7);
	record.luminance = row(8);

    switch light
      case 0
          data.backlight(end+1) = record;
      case 1
          data.frontlight(end+1) = record;
      case 2        
          data.bothlight(end+1) = record;
      case 3
          data.nolight(end+1) = record;
    endswitch;
	
end;
	
