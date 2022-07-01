function [SitePref] = SDM_SitePref(SitePref, Sites, Pref, Bulk)
%This function calculates the site preference of elemts
% with respect to their availability in the bulk and occupancies

% Alpha sites first
for i=1:2:length(SitePref)
    SitePref(i,1) = Sites(i,1)/(Bulk(i,1)/0.75);
    SitePref(i+1,1) = sqrt(9/16 .* (Sites(i,1)/Bulk(i,1)).^2 .* ((Sites(i+1,1)/Sites(i,1)).^2 + (Bulk(i+1,1)/Bulk(i,1)).^2));
end


% Beta sites next
for i=1:2:length(SitePref)
    SitePref(i,2) = Sites(i,2)/(Bulk(i,1)/0.25);
    SitePref(i+1,2) = sqrt(1/16 .* (Sites(i,2)/Bulk(i,1)).^2 .* ((Sites(i+1,2)/Sites(i,2)).^2 + (Bulk(i+1,1)/Bulk(i,1)).^2));
end


% Finalizing
SitePref(isnan(SitePref))=0;