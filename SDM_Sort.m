function [Planes_out] = SDM_Sort(Planes_in, Pref)
%This function sorts measured peaks, major vs. minor
% and sorts them according to pre-defined preference
% e.g. Ni alpha site (A) preference, will be sorted so that 
% max of Planes for Ni +/- stdev sits in A planes column

for i=1:2:length(Planes_in)
    if Pref{i} == "A"
        Max = max(Planes_in(i,:));
        Min = min(Planes_in(i,:));
        Planes_in(i,:) = [Max Min];
    elseif Pref{i} == "B"
        Max = max(Planes_in(i,:));
        Min = min(Planes_in(i,:));
        Planes_in(i,:) = [Min Max]; 
    else
        fprintf("Site preference not recognized please double-check Pref's")     
    end
end

Planes_out = Planes_in;