function main(dir_name, mat_name, mat_end, scripts_dir)
%Funkcja główna, wywoływana przez Roberta

cd(scripts_dir);


f_name = sprintf("%s/log.txt",dir_name);
#f_nameerr = sprintf("%s/log_err.txt",dir_name);
fout = fopen(f_name,"w");
#fouterr = fopen(f_nameerr,"w");
dup2(fout, stdout); # use new stdout
#dup2(fouterr, stderr); # use new stdout

octave_init;
config = prepare_config();

config.data_directory = dir_name;
config.mat_name = [mat_name ' ' mat_end];

[fibres] = do_everything(config);

dup2(1,fout);
fclose(fout);
#dup2(2,fouterr);
#fclose(fouterr);
