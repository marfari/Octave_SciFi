function mat_name = load_mat_name_from_file(path);

try
  %mat_name = csvread([path '/matid.csv']);
  FD = fopen([path '/matid.csv'],'r');
  mat_name = '';

  % change. matid contains 2 lines 1st ID, 2nd Side, will make mat_name prettier
  line = fgetl(FD);
  mat_name=line;
  if ~feof(FD)
  line = fgetl(FD);
  mat_name=[mat_name ' Side: ' line];
  end
  fclose(FD);
  
catch 
  mat_name = '';
end_try_catch
