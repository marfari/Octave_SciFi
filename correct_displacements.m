function fibres = correct_displacements(fibres, errors)
%Adjust positions on the fibres from different illuminations
%Uses error fits calculated by check_displacements
%WARNING! Modifies only fields 'x' and 'y' in the 'all' structure and its light-related children
%All unaligned data remain untouched as well as stand-alone light-related data

errors_tab_x(1,:) = errors.backlight.x;
errors_tab_x(2,:) = errors.frontlight.x;
errors_tab_x(3,:) = errors.bothlight.x;
errors_tab_x(4,:) = errors.nolight.x;

errors_tab_y(1,:) = errors.backlight.y;
errors_tab_y(2,:) = errors.frontlight.y;
errors_tab_y(3,:) = errors.bothlight.y;
errors_tab_y(4,:) = errors.nolight.y;


for i=1:length(fibres.all)
  fibres.all(i).x = fibres.all(i).x - polyval(errors_tab_x(fibres.all(i).light+1, :), fibres.all(i).x);
  fibres.all(i).y = fibres.all(i).y - polyval(errors_tab_y(fibres.all(i).light+1, :), fibres.all(i).x); 
  
  if ~isempty(fibres.all(i).backlight)
    fibres.all(i).backlight.x = fibres.all(i).backlight.x - polyval(errors.backlight.x, fibres.all(i).backlight.x);  
    fibres.all(i).backlight.y = fibres.all(i).backlight.y - polyval(errors.backlight.y, fibres.all(i).backlight.x);  
  end;

  if ~isempty(fibres.all(i).frontlight)
    fibres.all(i).frontlight.x = fibres.all(i).frontlight.x - polyval(errors.frontlight.x, fibres.all(i).frontlight.x);  
    fibres.all(i).frontlight.y = fibres.all(i).frontlight.y - polyval(errors.frontlight.y, fibres.all(i).frontlight.x);  
  end;

  if ~isempty(fibres.all(i).bothlight)
    fibres.all(i).bothlight.x = fibres.all(i).bothlight.x - polyval(errors.bothlight.x, fibres.all(i).bothlight.x);  
    fibres.all(i).bothlight.y = fibres.all(i).bothlight.y - polyval(errors.bothlight.y, fibres.all(i).bothlight.x);  
  end;

  if ~isempty(fibres.all(i).nolight)
    fibres.all(i).nolight.x = fibres.all(i).nolight.x - polyval(errors.nolight.x, fibres.all(i).nolight.x);  
    fibres.all(i).nolight.y = fibres.all(i).nolight.y - polyval(errors.nolight.y, fibres.all(i).nolight.x);  
  end;  

  
end;