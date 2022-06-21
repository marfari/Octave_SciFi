%This is a script for stand-alone processing
%Robert's software uses function 'main'

octave_init;

%addpath('C:/texlive/2015/bin/win32/');

config = prepare_config();

[config.data_directory nr_selected] = load_helper('.');

if nr_selected
  config.mat_name = '';
  fibres = do_everything(config);
end;