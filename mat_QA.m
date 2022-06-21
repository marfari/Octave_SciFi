function mat_QA(fibres, pixel_size_um, file_header, fig_no)
%Podaje jakie� informacje o macie

I = find([fibres.nevermind] == 0);
fibres = fibres(I); %Wyrzucamy nevermindy


plot_fmt = DefaultAxesFormat();

%output_data = [fibres.output_data];
output_data = fibres;

for i=1:length(output_data)
  if ~isempty(output_data(i).x)
    X(i) = output_data(i).x;
  else
    X(i) = NaN;
  end;
  if ~isempty(output_data(i).r)
    R(i) = output_data(i).r;
  else
    R(i) = NaN;
  end;
  if isfield(output_data(i).backlight,'luminance')
    Lb(i) = output_data(i).backlight.luminance;
  else
    Lb(i) = NaN;
  end;
  if isfield(output_data(i).frontlight,'luminance')
    Lf(i) = output_data(i).frontlight.luminance;
  else
    Lf(i) = NaN;
  end;
  if isfield(output_data(i).bothlight,'luminance')
    Ld(i) = output_data(i).bothlight.luminance;
  else
    Ld(i) = NaN;
  end;
end;

%X = [output_data.x];
%R = [output_data.r];
%Lb = [output_data.luminance_backlight];
%Lf = [output_data.luminance_frontlight];


figure(fig_no);
clf;
plot(X*pixel_size_um/1000, R*pixel_size_um*2,'.k');
grid on;
title('Fibre diameters');
xlabel('X position [mm]');
ylabel('Fibre diameters [\mum]');
FormatAxesEx(gcf,gca,plot_fmt, [file_header '_mat_QA_diameters']);

%figure(172);
clf;
plot(X*pixel_size_um/1000, Lb,'.k');
grid on;
title('Backlight luminance');
xlabel('X position [mm]');
ylabel('Luminance [a.u.]');
FormatAxesEx(gcf,gca,plot_fmt, [file_header '_mat_QA_luminance_backlight']);

%figure(173);
clf;
plot(X*pixel_size_um/1000, Lf,'.k');
grid on;
title('Frontlight luminance');
xlabel('X position [mm]');
ylabel('Luminance [a.u.]');
FormatAxesEx(gcf,gca,plot_fmt, [file_header '_mat_QA_luminance_frontlight']);

clf;
plot(X*pixel_size_um/1000, Ld,'.k');
grid on;
title('Bothlight luminance');
xlabel('X position [mm]');
ylabel('Luminance [a.u.]');
FormatAxesEx(gcf,gca,plot_fmt, [file_header '_mat_QA_luminance_bothlight']);


