function [dirname nr_selected] = load_helper(maindirname)

directories = search_directory_for_data(maindirname);

disp('');

for i=1:length(directories)
  dirname = [directories(i).name '                                             '];
  dirname = dirname(1:44);
  lightnames = {' Back ',' Front', ' Both ', ' None '};
  descr = '';
  for l=1:4
    if directories(i).lights(l)
      descr = [descr lightnames{l}];
    else
      descr = [descr '      '];
    end;
  end;
  if directories(i).report_present
    report_text = 'FINISHED';
  else  
    report_text = '';
  end;
  
  mat_name = directories(i).mat_name;
  mat_name = [mat_name '                                        '];
  mat_name = mat_name(1:24);
  
	disp(sprintf('%2d: %s %s %4d imgs %s %s %s', i, dirname, directories(i).date, directories(i).no_images, mat_name, descr, report_text));
	%disp(sprintf('%2d: %s %s %4d imgs %s %s', i, dirname, directories(i).date, directories(i).no_images, mat_name, report_text));

end;

disp('');

nr_selected = input('Select directory by number: ');

if (nr_selected > 0) && (nr_selected <= length(directories))
	dirname = directories(nr_selected).name;
else
	dirname = '';
	disp('Keyboard input error!');
  nr_selected = 0;
end;