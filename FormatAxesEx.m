function FormatAxesEx(FigureNo, Axes, Format, Filename)
%Funkcja formatuje wykres
%Je�li podamy nazw� pliku inn� ni� '', to zapisze obrazek do pliku
%Je�li nie chcemy wnika�, kt�ry obrazek i wykres, piszemy
%FormatAxesEx(gcf,gca,...)
%Nazw� pliku podajemy bez rozszerzenia. Zostanie utworzony plik .png
%WERSJA ANGLOJ�ZYCZNA - bez poprawiania przecink�w

F=figure(FigureNo);
%set(F,'Position',[0 0 1400 1200]);

%set(F,'paperorientation','landscape');
%set(F,'papersize',[11.0 8.5]);
%set(F, 'paperunits', 'normalized');
%set(F, 'paperposition', [0 0 1 1]);

set(F,'paperorientation',Format.paperorientation);
set(F,'papersize',Format.papersize);
set(F, 'paperunits', 'normalized');
set(F, 'paperposition', Format.paperposition);



A=Axes;
set(A,'FontName',Format.AxesFontName);
set(A,'FontSize',Format.AxesFontSize);
set(A,'LineWidth',Format.AxesLineWidth);

    %Font dla wszystkich obiekt�w testowych - dla tych poni�ej mo�e by�
    %nadpisany
Texts = findall(A,'Type','text');
for i=1:length(Texts)
    set(Texts(i),'FontName',Format.TextsFontName);
    set(Texts(i),'FontSize',Format.TextsFontSize);
end;


XL = get(A,'Xlabel');
set (XL,'FontName',Format.LabelFontName);
set(XL,'FontSize',Format.LabelFontSize);

YL = get(A,'Ylabel');
set (YL,'FontName',Format.LabelFontName);
set(YL,'FontSize',Format.LabelFontSize);

T = get(A,'Title');
set (T,'FontName',Format.TitleFontName);
set(T,'FontSize',Format.TitleFontSize);

L=legend(A);
set (L,'FontName',Format.LegendFontName);
set(L,'FontSize',Format.LegendFontSize);
    %poszerzamy troszk� legend�
LP = get(L,'Position');
if length(LP)
    set(L,'Position',[LP(1)+Format.LegendScale(1), LP(2)+Format.LegendScale(2), LP(3)*Format.LegendScale(3), LP(4)*Format.LegendScale(4)]);
end;%set(L,'xlim',[0 1.5]);

    %Grubo�� wszystkich linii
Lines = findall(A,'Type','line');
for i=1:length(Lines)
    set(Lines(i),'LineWidth',Format.PlotLineWidth);
end;

%     %Kropki na przecinki
% xlim = get(A,'XLim');
% ylim = get(A,'YLim');    
%     
% if strcmp(get(A,'Xscale'),'log') == 0
% 
%     texts = get(A,'XTickLabel');
%     ticks = get(A,'XTick');
%     set(A,'Xtick',ticks);
%     multiplier = ticks(length(ticks))/str2num(texts(length(ticks),:));
%     multiplier = round(log10(multiplier));
%     if multiplier ~= 0
%         multiplier_txt = sprintf('x 10^{%1.0f}',multiplier);
%     else
%         multiplier_txt = '';
%     end;
%     for i=1:size(texts,1)
%         dots = strfind(texts(i,:),'.');
%         if length(dots) == 1
%             texts(i,dots(1)) = ',';
%         end;
%     end;
%     set(A,'XTickLabel',texts);
%     if multiplier
%         T = text(xlim(2),ylim(1)-0.01*(ylim(2)-ylim(1)), multiplier_txt);
%         TE = get(T,'Extent');
%         TP = get(T,'Position');
%         set(T,'Position',[TP(1), TP(2)-1.5*TE(4), TP(3)]);    
%         %T = findall(A,'Type','text','String',multiplier_txt);
%         set(T,'HorizontalAlignment','Right');
%         set(T,'VerticalAlignment','Top');
%         set (T,'FontName',Format.AxesFontName);
%         set(T,'FontSize',Format.AxesFontSize);
%     end;
% 
% end;
% 
% if strcmp(get(A,'Yscale'),'log') == 0
% 
%     texts = get(A,'YTickLabel');
%     ticks = get(A,'YTick');
%     set(A,'Ytick',ticks);
%     multiplier = ticks(length(ticks))/str2num(texts(length(ticks),:));
%     multiplier = round(log10(multiplier));
%     if multiplier ~= 0
%         multiplier_txt = sprintf('x 10^{%1.0f}',multiplier);
%     else
%         multiplier_txt = '';
%     end;
%     for i=1:size(texts,1)
%         dots = strfind(texts(i,:),'.');
%         if length(dots) == 1
%             texts(i,dots(1)) = ',';
%         end;
%     end;
%     set(A,'YTickLabel',texts);
%     if multiplier
%         T = text(xlim(1),ylim(2)+0.01*(ylim(2)-ylim(1)), multiplier_txt);
%         %T = findall(A,'Type','text','String',multiplier_txt);
%         set(T,'HorizontalAlignment','Left');
%         set(T,'VerticalAlignment','Bottom');
%         set (T,'FontName',Format.AxesFontName);
%         set(T,'FontSize',Format.AxesFontSize);
%     end;
% 
% end;

    %Na koniec zapisujemy obrazek do pliku
if length(Filename) > 0
%  extension = Format.OutputMode; %Przycinamy rozszerzenie pliku do 3 liter
%  if length(extension) > 3
%    extension = extension(1:3);
%  end;
    print(F,strcat(Filename, '.', Format.FileExtension),strcat('-d', Format.OutputMode),'-r150');
end;