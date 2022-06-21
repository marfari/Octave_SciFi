function Format = WideAxesFormat()
%Zwraca struktur� ze standardowym formatowaniem wykresu

Format.paperorientation = 'landscape';
Format.papersize = [11.0 8.5];
Format.paperposition = [0.25 0 0.5 1];

Format.AxesFontName = 'Times New Roman';
Format.AxesFontSize = 16;
Format.AxesLineWidth = 1;

Format.TextsFontName = 'Times New Roman';
Format.TextsFontSize = 14;

Format.LabelFontName = 'Times New Roman';
Format.LabelFontSize = 16;

Format.TitleFontName = 'Times New Roman';
Format.TitleFontSize = 16;

Format.LegendFontName = 'Times New Roman';
Format.LegendFontSize = 14;
%Format.LegendScale = [-0.05 +0.045 1.4 1];   %Dwa pierwsze parametry to przesuni�cie legendy, dwa drugie to skalowanie
Format.LegendScale = [0 0 1 1];

Format.PlotLineWidth = 2;

Format.OutputMode = 'pdf'; %Może być png, pdf, eps, epsc...
Format.FileExtension = 'pdf';