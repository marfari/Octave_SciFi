function data = load_pin_csv_data(dirname)

if ~exist([dirname '/pins.csv'],'file')
  data = [];
  return;
end;

raw_pin_data = load_backfront_csv_file([dirname '/pins.csv']);


%Record template
	data = struct('pin_nr',{},'x',{},'y',{},'x_unaligned',{},'y_unaligned',{},'r',{},'light',{},'base_position',{},'position_index',{});

for i=1:size(raw_pin_data,1)
  
	clear record;
	row = raw_pin_data(i,:);
	light = row(1);
  record.light = light;
	record.pin_nr = row(3); %This will be re-numbered
  record.base_position = row(2);
	record.x = row(4) + row(2);
  record.x_unaligned = record.x;
	record.y = -row(5);
  record.y_unaligned = record.y;
	record.r = row(6);
  record.position_index = 0;
	
  data(end+1) = record;
end;
	