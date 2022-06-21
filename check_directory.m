function result = check_directory(dirname)
%Sprawdza, czy katalog zawiera poprawne dane z Robertowego kawałka

%contents = dir([dirname '/*_results']);
contents = dir([dirname]);

%Najpierw szukamy, czy są odpowiednie podkatalogi

exported_exists = 0;
raw_exists = 0;

%keyboard;

for i=find([contents.isdir] == 1)
    if strcmp(contents(i).name, 'exported_results')
      exported_exists = i;
    end;
    if strcmp(contents(i).name, 'raw_results')
      raw_exists = i;
    end;
end;

%Teraz patrzymy, czy są odpowiednie pliki

if exported_exists %&& raw_exists

  %disp('Proper subdirs found');

  fibers_exists = 0;

  contents = dir([dirname '/exported_results/*.csv']);
  
  for i=1:length(contents)
    if strcmp(contents(i).name, 'fibers_each.csv')
      fibers_exists = i;
    end;
  end;

  if fibers_exists
    
    %Teraz spróbujemy coś powiedzieć o tym zbiorze 
    result.date = contents(fibers_exists).date;
    if raw_exists
      contents_raw = dir([dirname '/raw_results/*.jpg']);
      result.no_images = length(contents_raw);
    else
      result.no_images = 0;
    end;
    
    %Informacje o oświetleniach
    result.lights = zeros(1,4);
    data = load_backfront_csv_file([dirname '/exported_results/stitch.csv']);
    for light=1:4
      if length(find(data(:,1)==(light-1)))
        result.lights(light) = 1;
      end;
    end;
  
    %A teraz sprawdzimy, czy jest raport
    contents = dir([dirname '/mat_results/report.pdf']);
    if length(contents)
      result.report_present = 1;
    else
      result.report_present = 0;
    end;
    result.mat_name = load_mat_name_from_file([dirname '/exported_results/']);
  
  else
    result = [];
  end;

else
  result = [];
end;