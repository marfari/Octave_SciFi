function fibres = correct_luminance(fibres)
%Simple luminance correction

L = [fibres.luminance];

mean_luminance = mean(L);

for i=1:length(fibres)
  fibres(i).luminance = fibres(i).luminance / mean_luminance;
end

