%this script computes high fidelity species specific (SS) spatial
%distribution maps from atom probe data.

%Author: Andrew Breen (andrew.breen@sydney.edu.au), 2021
%written and tested in MATLAB R2020a

close all
clc
clear all

%% user inputs
fsize = 12; %the font size

%% read the epos
pos_name = 'R18_59377-v01.epos';
[dx,dy,~,~,~,m,~,vdc,vp,~,~] = readepos(pos_name);


%% region of interest

%radius of ROI (mm)
R = 4;

% %zmin and zmax of ROI
% 
% zmin = min(z);
% zmax = max(z);

%ion number limits
s1 = 4e6;
s2 = 5e6;

%centre of ROI (on detetector)
%P1
h = 5.024;
k = 9.559; 

dx02 = dx(s1:s2);
dy02 = dy(s1:s2);
m02 = m(s1:s2);
vdc02 = vdc(s1:s2);
vp02 = vp(s1:s2);

%plot the resulting FDM of slice

FDM01( dx02, dy02,  280, 0, fsize, 'test.jpg')
hold on
ss = scatter3(h,k, 1e99,'p', 'filled'); 
ss.SizeData = 200;
ss.CData = [1, 0, 0];

l1 = (dx02-h).^2 + (dy02-k).^2 < R.^2;
dx03 = dx02(l1);
dy03 = dy02(l1);
m03 = m02(l1);
vdc03 = vdc02(l1);
vp03 = vp02(l1);



%% reconstruct the ROI

% example values for R18_59377 (In738)
kf = 3.84;
ICF= 1.59; 
avgDens = 91.4; %Ni
Fevap =  35; %V/nm Ni (from miller textbook)
flightLength = 90; %mm 
detEff = 0.57;

[x, y, z, m, R_start, R_end] = atomProbeRecon06(dx03, dy03, m03, h, k, vdc03+vp03, kf, ICF, avgDens, Fevap, flightLength, detEff);


%% compute SDM for particular species
s_A = 'Ni';
s_B = 'W';
%filter
[x_A, y_A, z_A, m_A] = filter_element(x, y, z, m, 'R18_59377_new.rng', s_A);
[x_B, y_B, z_B, m_B] = filter_element(x, y, z, m, 'R18_59377_new.rng', s_B);

%SDM extents
edges = -1:0.002:1;
SDM_bins_start = edges(1);
SDM_bins_end = edges(end);
bins = length(edges)-1;

sdm = zeros(1, bins);
sdm2 = zeros(1, bins);


if strcmp(s_A, s_B)
     parfor j = 1:length(z_A)
            dz = z_B - z_A(j);
            dz(j) = [];
            k = dz > SDM_bins_start & dz < SDM_bins_end;
            sdm = sdm + histcounts(dz(k), edges);
     end
else
    parfor j = 1:length(z_A)
            dz = z_B - z_A(j);
            %dz(j) = [];
            k = dz > SDM_bins_start & dz < SDM_bins_end;
            sdm = sdm + histcounts(dz(k), edges);
    end
end

%% plot SDM (unmodified)

fig_dim_x = 9;
fig_dim_y = 9;


%fig = figure('position', [1,1,900, 900]);
fig2 = figure('Units', 'centimeters');
fig2.Position = [5,5,fig_dim_x, fig_dim_y];

centres = edges+(edges(2)-edges(1))/2;
centres(end) = [];

plot(centres, sdm, 'linewidth', 1.5, 'color', 'b');


set(gca,'XColor','k','YColor','k','fontsize',fsize,'linewidth', 2, 'box','on');

xlim([SDM_bins_start SDM_bins_end]);

ylim([min(sdm)*0.8 max(sdm)*1.2]);

xlabel('z'' (nm)', 'fontsize', fsize);
ylabel('counts', 'fontsize', fsize);

set(gcf, 'PaperPositionMode','auto');
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'color', 'white');

legend( [s_A ' - ' s_B]);

export_fig([s_A '_' s_B  'SDM' pos_name], '-png', '-r500','-nocrop')






