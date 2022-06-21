%Inicjalizacja środowiska oktawy, żeby chciały chodzić skrypty

try
  pkg load signal
  pkg load optim
  pkg load splines
catch
  octave_install_packages
  pkg load signal
  pkg load optim
  pkg load splines
 end_try_catch

more off
graphics_toolkit gnuplot