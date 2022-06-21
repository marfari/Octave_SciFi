function generate_tex_report(dirname, mat_name, filename, version)

current_dir = pwd;
cd (dirname);

file = fopen('mat_nr.tex','w');
fprintf(file,'%s \\\\ {\\tiny scripts ver. %s}',mat_name, version);
fclose(file);

try
  delete('report.tex', 'report.pdf');
catch
end_try_catch

%copyfile([current_dir '/' filename '.tex'],'.','f');
copyfile([current_dir '/' filename '.tex'],'./report.tex','f');

%delete([filename '.pdf']);
%system(['C:/texlive/2015/bin/win32/pdflatex.exe -synctex=1 -interaction=nonstopmode ' filename '.tex']);
%delete([filename '.aux'], [filename '.synctex.gz'], [filename '.log'], [filename '.tex']);
if ispc()
  [status output] = system('pdflatex.exe -synctex=1 -interaction=nonstopmode report.tex');
else
  [status output] = system('pdflatex -synctex=1 -interaction=nonstopmode report.tex');
end;
disp(sprintf('  Latex exitted with status 0x%x',status));
try
  delete('report.aux', 'report.synctex.gz', 'report.log', '*.tex');
%, 'report.tex', 'mat_nr.txt');
catch
end_try_catch

cd (current_dir);
