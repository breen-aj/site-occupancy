function FDM01( detx, dety,  RES, sm, fsize, SaveFileName)
%This function plots a field desorption map of inputted detector
%co-ordinates. Note slices ~ 1-2 million atoms usually show clearest FDM

%detx - inputted X co-ordinates
%dety - inputted Y co-ordinates
%RES - the number of bins in SDM along each axis, usually ~ 280
%col - colour profile for FDM e.g. 'jet', 'default', 'autumn' 
%sm - smooth SDM? (1 = yes, 0 = no)
%fsize - font size, usually ~ 30
%SaveFileName - file name of outputted FDM. Note figure saved in .tif, .eps
%takes too long to save


%note - good conditions were observed for RES = 280, 200 slices, ~2 million
%atoms per slice. Have slices overlap for smoother transistion.

%Authors: Breen A
%(andrew.breen@sydney.edu.au), 2015
%Australian Centre for Microscopy and Microanalysis (ACMM), The University of Sydney 
%tested in MATLAB R2020a 

% BSD 2-Clause License
% 
% Copyright (c) 2015, Breen A
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 
% 1. Redistributions of source code must retain the above copyright notice, this
%    list of conditions and the following disclaimer.
% 
% 2. Redistributions in binary form must reproduce the above copyright notice,
%    this list of conditions and the following disclaimer in the documentation
%    and/or other materials provided with the distribution.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


%% calculating bin centers for FDM

mi = min(min(detx),min(dety));
mx = max(max(detx),max(dety));

ctr{1} = linspace(mi,mx,RES);
ctr{2} = ctr{1};

%% plot the FDM

fig_dim_x = 12.68;
fig_dim_y = 14.35;

%fig = figure('position', [1,1,900, 900]);
fig = figure('Units', 'centimeters');
fig.Position = [5,5,fig_dim_x, fig_dim_y];

FDM = hist3([dety; detx]',ctr); % note: for the hist3 function, Y must be in the first column and X in the second column
    
if sm == 1
    %FDM = smoothn(FDM,'robust');
    FDM = smoothn(FDM, 0.1);
end 
    
    surf(meshgrid(ctr{1}), meshgrid(ctr{1})', FDM)
    %colormap 'hot'
    %colormap jet
    %colormap gray
    colormap inferno
    shading interp
    view(2)
    axis square
    grid off
    colorbar off
    xlabel('X position (mm)','fontsize',fsize)
    ylabel('Y position (mm)','fontsize',fsize)
    ax1 = gca;
    %set(ax1,'XColor','k','YColor','k','fontsize',fsize,'linewidth', 2, 'box','on', 'xtick', -30:5:30,'ytick', -330:5:30)
    set(ax1,'XColor','k','YColor','k','fontsize',fsize,'linewidth', 2, 'box','on');
    
    %axis off
    %xlim([min(detx) max(detx)])
    %ylim([min(dety) max(dety)])
    xlim([min(detx) max(detx)])
    ylim([min(dety) max(dety)])
    set(gcf, 'PaperPositionMode','auto');
    set(gcf, 'InvertHardCopy', 'off');
    set(gcf, 'color', 'white');
    axis off
    %set(gca, 'position', [0 0 1 1], 'units', 'normalized');
    %axis normal
    %axis equal
    f = getframe(gcf);       
    %imwrite(f.cdata,SaveFileName ,'jpg');
    %export_fig SaveFileName '-eps'
    export_fig(SaveFileName, '-jpg', '-r500');
end

