function [RelPlot] = SDM_RelPrefPlot(SDM_name, Elements, Pref, SitePref)
%This function generates a plot of the relative site occupancies
% of the investigated elements and plots them with respect to their 
% bulk composition
SDM_name = extractBefore(SDM_name, '-v0');
FSize = 20;
LWidth = 2;

El = categorical(Elements(1:2:end));
Er = Elements(2:2:end);

ElPref = SitePref(1:2:end,:);
ElErr = SitePref(2:2:end,:);

RelPlot = figure;
hold on

b = bar(El,ElPref,'stacked','Linewidth', LWidth);
b(1).FaceColor = [.8 .2 .1]; %red, alpha sites
b(2).FaceColor = [.1 .5 .7]; %blue, beta sites
errorbar(El,ElPref(:,1),ElErr(:,2),ElErr(:,1),'black','Linewidth', LWidth,'linestyle','none');
title(SDM_name)
fill([0 length(El)+0.5 length(El)+0.5 0],[0 0 0.05 0.05],'black')
fill([0 length(El)+0.5 length(El)+0.5 0],[0.95 0.95 1 1],'black')
yyaxis left
ylabel('Relative {\alpha} site preference (%)')
ylim([0 1])
yyaxis right
axis ij
ylabel('Relative {\beta} site preference (%)')
ylim([0 1])
legend(b(1:2),'On {\alpha} sites','On {\beta} sites')
ax = gca;
set(gca,'FontSize', FSize, 'Linewidth', LWidth)
pbaspect([2 1 1])

