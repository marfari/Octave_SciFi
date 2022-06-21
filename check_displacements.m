function error_fits = check_displacements(fibres, light_priorities, fit_order, file_header)
%Produce adjustment fits for fibre data from different views
%fit_order is the order of fitting function
%set file_header to '' if you don't want to generate nor save plots

%Check which illumination has top priority - it will be the reference
[M I] = max(light_priorities);
basic_illumination = I-1;

%backup_illuminations = 0:3;
%backup_illuminations(I) = [];


lights = [fibres.all.light];
I = find(lights == basic_illumination);

%Check if the main illumination is representative enough

if length(I) < (0.1*length(fibres.all))
  disp('***Warning! The basic illumination has less than 10% of all fibres!'); 
  %Probably do something more here!
  %Either exit this function or find another illumination to be used as basic
end;


%Now calculate the differences

backlight_index = 0;
frontlight_index = 0;
bothlight_index = 0;
nolight_index = 0;
backlight_errors = struct('x',[],'dx',[],'dy',[]);
frontlight_errors = struct('x',[],'dx',[],'dy',[]);
bothlight_errors = struct('x',[],'dx',[],'dy',[]);
nolight_errors = struct('x',[],'dx',[],'dy',[]);


for fibre_nr=I
  if ~isempty(fibres.all(fibre_nr).backlight)
    backlight_index = backlight_index+1; 
    backlight_errors.x(backlight_index) = fibres.all(fibre_nr).x;
    backlight_errors.dx(backlight_index) = fibres.all(fibre_nr).backlight.x - fibres.all(fibre_nr).x;
    backlight_errors.dy(backlight_index) = fibres.all(fibre_nr).backlight.y - fibres.all(fibre_nr).y;
  end;
  if ~isempty(fibres.all(fibre_nr).frontlight)
    frontlight_index = frontlight_index+1; 
    frontlight_errors.x(frontlight_index) = fibres.all(fibre_nr).x;
    frontlight_errors.dx(frontlight_index) = fibres.all(fibre_nr).frontlight.x - fibres.all(fibre_nr).x;
    frontlight_errors.dy(frontlight_index) = fibres.all(fibre_nr).frontlight.y - fibres.all(fibre_nr).y;
  end;    
  if ~isempty(fibres.all(fibre_nr).bothlight)
    bothlight_index = bothlight_index+1; 
    bothlight_errors.x(bothlight_index) = fibres.all(fibre_nr).x;
    bothlight_errors.dx(bothlight_index) = fibres.all(fibre_nr).bothlight.x - fibres.all(fibre_nr).x;
    bothlight_errors.dy(bothlight_index) = fibres.all(fibre_nr).bothlight.y - fibres.all(fibre_nr).y;
  end;
  if ~isempty(fibres.all(fibre_nr).nolight)
    nolight_index = nolight_index+1; 
    nolight_errors.x(nolight_index) = fibres.all(fibre_nr).x;
    nolight_errors.dx(nolight_index) = fibres.all(fibre_nr).nolight.x - fibres.all(fibre_nr).x;
    nolight_errors.dy(nolight_index) = fibres.all(fibre_nr).nolight.y - fibres.all(fibre_nr).y;
  end;
end;  %for fibre_nr=I





%Make fits

if backlight_index > 1
  error_fits.backlight.x = polyfit(backlight_errors.x, backlight_errors.dx, fit_order);
  error_fits.backlight.y = polyfit(backlight_errors.x, backlight_errors.dy, fit_order);
else
  error_fits.backlight.x = zeros(1,fit_order+1);
  error_fits.backlight.y = zeros(1,fit_order+1);
end;

if frontlight_index > 1
  error_fits.frontlight.x = polyfit(frontlight_errors.x, frontlight_errors.dx, fit_order);
  error_fits.frontlight.y = polyfit(frontlight_errors.x, frontlight_errors.dy, fit_order);
else
  error_fits.frontlight.x = zeros(1,fit_order+1);
  error_fits.frontlight.y = zeros(1,fit_order+1);
end;

if bothlight_index > 1
  error_fits.bothlight.x = polyfit(bothlight_errors.x, bothlight_errors.dx, fit_order);
  error_fits.bothlight.y = polyfit(bothlight_errors.x, bothlight_errors.dy, fit_order);
else
  error_fits.bothlight.x = zeros(1,fit_order+1);
  error_fits.bothlight.y = zeros(1,fit_order+1);
end;
  
if nolight_index > 1
  error_fits.nolight.x = polyfit(nolight_errors.x, nolight_errors.dx, fit_order);
  error_fits.nolight.y = polyfit(nolight_errors.x, nolight_errors.dy, fit_order);
else
  error_fits.nolight.x = zeros(1,fit_order+1);
  error_fits.nolight.y = zeros(1,fit_order+1);
end;
  
%Plot plots;)

if length(file_header) > 0
  
  plot_fmt = DefaultAxesFormat();
  %legends = {'x', 'y'};

  if backlight_index > 0
    %figure(10);
    plot(backlight_errors.x, backlight_errors.dx, '.r');
    hold on;
    ax(1) = plot(backlight_errors.x, polyval(error_fits.backlight.x, backlight_errors.x), '-r');
    plot(backlight_errors.x, backlight_errors.dy, '.g');
    ax(2) = plot(backlight_errors.x, polyval(error_fits.backlight.y, backlight_errors.x), '-g');
    holdd off;
    title('Position adjustment on backlight');
    xlabel('X position [pixels]');
    ylabel('Error [pixels]');
    grid on;
    legends{1} = ['x: ' print_polynominal(error_fits.backlight.x)];
    legends{2} = ['y: ' print_polynominal(error_fits.backtlight.y)];
    legend(ax,legends,'Location','SouthOutside');
    FormatAxesEx(gcf,gca,plot_fmt, [file_header 'position_adjust_backlight']);
  end;

  if frontlight_index > 0
    %figure(11);
    plot(frontlight_errors.x, frontlight_errors.dx, '.r');
    hold on;
    ax(1) = plot(frontlight_errors.x, polyval(error_fits.frontlight.x, frontlight_errors.x), '-r');
    plot(frontlight_errors.x, frontlight_errors.dy, '.g');
    ax(2) = plot(frontlight_errors.x, polyval(error_fits.frontlight.y, frontlight_errors.x), '-g');
    hold off;
    title('Position adjustment on frontlight');
    xlabel('X position [pixels]');
    ylabel('Error [pixels]');
    grid on;
    legends{1} = ['x: ' print_polynominal(error_fits.frontlight.x)];
    legends{2} = ['y: ' print_polynominal(error_fits.frontlight.y)];
    legend(ax,legends,'Location','SouthOutside');
    FormatAxesEx(gcf,gca,plot_fmt, [file_header 'position_adjust_frontlight']);
  end;

  if bothlight_index > 0
    %figure(12);
    plot(bothlight_errors.x, bothlight_errors.dx, '.r');
    hold on;
    ax(1) = plot(bothlight_errors.x, polyval(error_fits.bothlight.x, bothlight_errors.x), '-r');
    plot(bothlight_errors.x, bothlight_errors.dy, '.g');
    ax(2) = plot(bothlight_errors.x, polyval(error_fits.bothlight.y, bothlight_errors.x), '-g');
    hold off;
    title('Position adjustment on bothlight');
    xlabel('X position [pixels]');
    ylabel('Error [pixels]');
    grid on;
    legends{1} = ['x: ' print_polynominal(error_fits.bothlight.x)];
    legends{2} = ['y: ' print_polynominal(error_fits.bothlight.y)];
    legend(ax,legends,'Location','SouthOutside');
    FormatAxesEx(gcf,gca,plot_fmt, [file_header 'position_adjust_bothlight']);
  end;

  if nolight_index > 0
    %figure(13);
    plot(nolight_errors.x, nolight_errors.dx, '.r');
    hold on;
    ax(1) = plot(nolight_errors.x, polyval(error_fits.nolight.x, nolight_errors.x) '-r');
    plot(nolight_errors.x, nolight_errors.dy, '.g');
    ax(2) = plot(nolight_errors.x, polyval(error_fits.nolight.y, nolight_errors.x) '-g');
    hold off;
    title('Position adjustment on nolight');
    xlabel('X position [pixels]');
    ylabel('Error [pixels]');
    grid on;
    legends{1} = ['x: ' print_polynominal(error_fits.nolight.x)];
    legends{2} = ['y: ' print_polynominal(error_fits.nolight.y)];
    legend(ax,legends,'Location','SouthOutside');
    FormatAxesEx(gcf,gca,plot_fmt, [file_header 'position_adjust_nolight']);
  end;

end;

end;  %function

function text = print_polynominal(poly)

text = '\Delta = ';

for i=1:length(poly)
  if (i > 1)
    if poly(i) >= 0
      text = [text '+'];
    else
      text = [text '-'];
    end;
  end;
      
  text = [text sprintf("%f", abs(poly(i)))];
  order = length(poly)-i;
  if (order == 0)
  elseif (order == 1)
    text = [text 'x'];
  else
    text = [text 'x^' sprintf('%1d', length(poly)-i)];
  end;
end;  
  
end;  %function



  