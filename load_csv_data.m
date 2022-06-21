function [data lights] = load_csv_data(directory)
%Funkcja �aduje komplet danych z plik�w .csv z podanego katalogu


	%�adujemy dane w��kien na obrazkach
data = load_fibre_csv_data(directory);

lights.backlight_present = 0;
lights.frontlight_present = 0;
lights.bothlight_present = 0;
lights.nolight_present = 0;

if length(data.frontlight)
  lights.frontlight_present = 1;
end;
if length(data.backlight)
  lights.backlight_present = 1;
end;
if length(data.bothlight)
  lights.bothlight_present = 1;
end;
if length(data.nolight)
  lights.nolight_present = 1;
end;






