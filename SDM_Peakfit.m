function [A, w, xc] = SDM_Peakfit(x, y, SDM_name, d)
% This function takes x (nm) and y (counts) information from SDMS
% and fits no_peaks (N) in the region of interest (x_min to x_max)
% output is A (area under curve), w (width of curve), xc (curve center)
% The current iteration uses Gaussian curve fitting.
% Setting boundary conditions: Region of interest and # of peaks.
% Tolerance of 1/2 plane spacing usually works well.
msgbox('Pls select center of first lattice plane, press Enter, select center of second lattice plane, press Enter');
[xp(1) yp(1)] = ginput;
[xp(2) yp(2)] = ginput;
xc = mean(xp);
tol = d/2;

y = y(x >= xc-tol & x <= xc+tol)';
x = x(x >= xc-tol & x <= xc+tol)';

plot(x, y);
title(SDM_name)
xlabel("z' (nm)")
ylabel("counts (-)")
xlim([xc-tol xc+tol])


% Setting up boundaries and starting points for Gaussian peak fit:
% 1st & 2nd: Boundaries for area under the peak
% 3rd & 4th: Boundaries for peak width
% 5th & 6th: Boundaries for peak center locations
LowBnd = [0, 0, 0.02, 0.02, min(x), min(x)];
UpBnd = [1e6, 1e6, 0.12, 0.12, max(x), max(x)];
StPt = [1e2, 1e2, 0.07, 0.07, xp(1), xp(2)];


% Performing the Gaussian peak fitting:
% a ... Area under the peak
% b ... Peak width
% c ... Peak center
GaussEqn = '((a1/(b1*sqrt(pi/2)))*exp(-2*((x-c1)^2)/(b1^2))) + ((a2/(b2*sqrt(pi/2)))*exp(-2*((x-c2)^2)/(b2^2)))';
GaussFit = fit(x, y, GaussEqn, 'Exclude', min(x) < x < max(x), 'Robust', 'LAR', 'Lower', LowBnd, 'Upper', UpBnd, 'StartPoint', StPt);


% Plotting the results and handing out averages and standard deviations.
plot(GaussFit, x, y);
title(SDM_name)
xlabel("z' (nm)")
ylabel("counts (-)")
xlim([min(x) max(x)])

CI = confint(GaussFit,0.68);
A = [GaussFit.a1 GaussFit.a2; diff(CI(:,1))/4 diff(CI(:,2))/4];
w = [GaussFit.b1 GaussFit.b2; diff(CI(:,3))/4 diff(CI(:,4))/4];
xc = [GaussFit.c1 GaussFit.c2; diff(CI(:,5))/4 diff(CI(:,6))/4];

