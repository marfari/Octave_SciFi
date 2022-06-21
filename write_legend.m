function write_legend(legends,colors_names,filename)

legend_f=fopen(filename,'w');
for lay=1:length(legends)
	fprintf(legend_f,"{\\protect\\tikz[baseline=-1.2ex] \\protect\\fill [%s] (0,-0.1) rectangle (0.8,0.0);}~%s\\\\",colors_names{lay},legends{lay});
end;
fclose(legend_f);

end;
