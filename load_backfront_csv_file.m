function data = load_backfront_csv_file(filename)
%Funkcja �aduje plik csv, kt�ry ma wiersz nag��wk�w i w pierwszej kolumnie okre�lenia Back/Front/Both/None
%Back przerabia na zero, a Front na 1
%Both przerabia na 2, a None na 3

FD = fopen(filename,'r');

fgetl(FD);	%Nag��wki id� w devnull;)

nr_lines = 0;

while ~feof(FD)
	nr_lines = nr_lines+1;
	line = fgetl(FD);
	fields = strsplit(line,';');
	if  strcmpi(fields{1},'Back')
		data(nr_lines,1) = 0;
	elseif  strcmpi(fields{1},'Front')
		data(nr_lines,1) = 1;
  elseif  strcmpi(fields{1},'Both')
		data(nr_lines,1) = 2;
  else
		data(nr_lines,1) = 3;
	end;
	
	for field=2:length(fields)
		data(nr_lines,field) = str2double(fields{field});
	end;
end;

fclose(FD);