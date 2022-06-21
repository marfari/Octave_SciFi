function D = mean_fibre_distance(fibres)
%Find mean distance between fibres.
%Take just some data from the middle of the mat

	%Tworzymy tablic� wsp��rz�dnych w��kien
%input_data = view.master_fibre_data;
X = [fibres.x];
Y = [fibres.y];
center = mean(X);
range = (max(X)-min(X))*0.05;
I = find ((X > (center-range)) & (X < (center+range)));
X = X(I);
Y = Y(I);

XY = [X; Y];

	%Wyliczamy odleg�o�ci ka�dy-do-ka�dego
distances = myDist(XY);
distances = reshape(distances,1,size(distances,1)*size(distances,2));

[counts I] = hist(distances,[0:1:500]);

filter = 1+cos([-pi:pi/10:pi]);
filter_length = length(filter);


counts = conv(counts,filter);
counts(1:floor(filter_length/2)+1) = [];
counts = counts(1:length(I));

%figure(2);
%plot(I, counts);

%[peaks, locations] = findpeaks(counts);
[peaks, locations] = myFindPeaks(counts',0.2*max(counts(1:floor(end/2))), 10);

threshold = peaks(1)*0.5;
found_nrs = find((peaks > threshold) & (locations > 10));

found_location = locations(found_nrs(1));

D = I(found_location);



