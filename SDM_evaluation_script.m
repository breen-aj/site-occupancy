%% This script extracts Planar composition, site composition, ordering
% parameter, and relative elemental site prefrernce from SDMs.
%
% Authors: F. Theska(1,*), A. Breen(2,*), B. Lim(2), S.P. Ringer(2), S. Primig(1)
% (1) School of Materials Science & Engineering, UNSW Sydney, Australia
% (2) School of Aerospace, Mechanical & Mechatronic Engineering, and
% Australian Centre for Microscopy & Microanalysis, The University of
% Sydney, Australia
%
% * first authors
% Date: 01/03/2022


%% Read-in bulk chemical composition and defining matrices to be populated
% Elements  ... Element names & standard errors
% Bulk      ... Bulk chemical composition in absolute atomic fraction, e.g. [at.%]/100
% Pref      ... Qualitative site preference for element and standard error
%               A ... alpha site preference, B ... beta site preference
% Planes    ... To be populated, areas under the SDM peaks
% Sites     ... To be populated, composition of sites
% OrderPara ... To be populated, Ordering parameter
% SitePref  ... To be populated, Element-specific relative site preference

Elements = ["Ni"; "Ni error"; "Al"; "Al error"; "Ti"; "Ti error"; "Co"; "Co error"; "Cr"; "Cr error"; "Ta"; "Ta error"; "W"; "W error"; "Mo"; "Mo error"];
Bulk = [0.7054;	0.00419; 0.132; 0.00148; 0.08259; 0.00135; 0.03318; 0.00136; 0.02575; 0.0012; 0.00942; 0.0011; 0.0082; 0.00113; 0.00347; 0.00023];
Pref = ["A"; "A"; "B"; "B"; "B"; "B"; "A"; "A"; "B"; "B"; "B"; "B"; "B"; "B"; "B"; "B"];
Planes = zeros(length(Elements),2);
Sites = zeros(length(Elements),2);
OrderPara = zeros(2,1);
SitePref = zeros(length(Elements),2);


%% Importing x-y coordinates from SMDs directly or openened from .fig
% Cropping the name for easier identification in summary table.
% Important: These steps must be repeated for each element of interest!

SDM_name = extractAfter(get(gcf, 'FileName'), 'MATLAB\');
Ele_name = extractBetween(get(gcf, 'FileName'), 'Al-', '.fig');
line_obj_handles = findobj(gca,'type','line');
handle = line_obj_handles(1);

% Reading x and y data from line or scatter plot
x = get(handle, 'XData');
y = get(handle, 'YData');

% SDM Peak fitting function crops the SDM close to the center region, fits
% two Gaussian curves to two peaks for the deconvolution, and populates the
% areas under the peaks in Planes.
% d ... Plane spacing is required for tolerance
%d = 0.36; %for {200} planes
d = 0.25; %for {220} planes


% Important: Manual selection of desired center peak required!
% 
% A ... Areas under the peaks
% w ... Peak widths 
% xc ... Peak center locations on x-axis 
% (See Manuscript Equation (1) for Gaussian curve)
[A w xc] = SDM_Peakfit(x, y, SDM_name,d);
Planes(strcmp(Elements,Ele_name),:) = A(1,:);
Planes(strcmp(Elements,Ele_name + " error"),:) = A(2,:);
pause(2);
close all


%% Sorting measured areas under the peaks according to preferences
% e.g. Ni alpha (A) preference, max Ni +/- stdev sort into A plane
Planes = SDM_Sort(Planes, Pref);


% Calculating alpha and beta site compositions
% The site matrix will contain:
% First column ... alpha sites
% (See Manuscript Equations (2) & (7))
% Second column ... beta sites
% (See Manuscript Equation (3) & (8))

Sites = SDM_Sites(Sites, Planes, Bulk);


% This provides the alternative approach to calculate beta site
% compositions without prior knowledge of bulk composition
% This has not been implemented yet.
%Sites = SDM_Sites_alt(Planes);


% Calculating the Ordering parameter 
% Based on alpha and beta site compositions, and bulk chemical composition.
% First entry is the ordering parameter, second entry the standard error.
% (See Manuscript Equations (4) & (9)

OrderPara = SDM_Order(OrderPara, Sites, Pref, Bulk);


% Calculating element-specific relative site preferences
% Element distribution towards alpha and beta sites with respect to
% availability in the bulk.
% A summary table is created and the relative element-specific site
% preferences plotted according to Manuscript Fig. 10b.
% First column ... Element preference to alpha sites
% (See Manuscript Equations (5) & (10))
% Second column ... Element preference to beta sites
% (See Manuscript Equations (6) & (11))

SitePref = SDM_SitePref(SitePref, Sites, Pref, Bulk);

Summary = table(Elements, Bulk, Pref, Planes, Sites, SitePref);
Summary = renamevars(Summary,["Planes","Sites","SitePref"],["Plane compositions (A|B)","Site Occupancies (a|b)","Site Preferences (a|b)"]);

RelPlot = SDM_RelPrefPlot(SDM_name, Elements, Pref, SitePref);
