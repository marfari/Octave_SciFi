function results = search_directory_for_data(dirname)
%Funkcja, która przeszukuje katalog w poszukiwaniu danych)
%Dla szybkości zakładamy, że poprawny katalog nie zawiera poprawnych podkatalogów.
%Jeśli ma być inaczej, zamienić else oznaczony gwiazdką na end i wywalić ostatniego enda.

disp(['Searching dir: ' dirname]);

contents = dir(dirname);

results = [];

own_result = check_directory(dirname);
if ~isempty(own_result)
  own_result.name = dirname;
  results = [results own_result];
else  % * <- gwiazdka;)
  for i=find([contents.isdir] == 1)
    if (~strcmp(contents(i).name,'.')) && (~strcmp(contents(i).name,'..'))
      returned_data = search_directory_for_data([dirname '/' contents(i).name]);
      results = [results returned_data];
    end;
  end;
end;




