function [nelements, nranges, range, range_ids,range_names, element_colours] = readrange_rng05(file_name)
%% authors
%% Baptiste Gault
%% Andrew Breen
%% Anna Ceguerra
%% 3 April 2012

%% nelements is the number of ionic types
%% nranges is the number of ranges
%% range(n, :) = [minrange, maxrange]
%% range_ids(n, :) = [0, 0, ..., 1, 0...]

[data,result]=readtext(file_name,' ');
nelements=data{1};
nranges=data{1,2};

%rangelines=reshape(data, result.rows, result.max);
rangelines = data;

range = zeros(nranges, 2);
range_ids = zeros(nranges, nelements);

range_names = rangelines((nelements+1)*2, :);
empties = find(cellfun(@isempty,range_names));
range_names(empties) = [];
range_names(1) = [];

%find element colours
element_colours = zeros(nelements, 3);
start_c = 3;
for i = 1:nelements
    element_colours(i,:) = [rangelines{start_c +(i-1)*2, 2:4}];
end

j_new = 1;
for j = (nelements+1)*2+1:result.rows
    temp=rangelines(j,:);
    empties = find(cellfun(@isempty,temp));
    if length(empties) == size(rangelines, 2)
        endline = j;
        break
    end   
    temp(empties)=[];
    range(j_new, :) = [temp{2:3}];
    range_ids(j_new, :) = [temp{4:length(temp)}];
    j_new = j_new + 1;
end

nelements1 = nelements;
nranges1 = nranges;
range1 = range;
range_ids1 = range_ids;
range_names1 = range_names;
element_colours1 = element_colours;

%check to see if there is a polyatom extension of ions in file

A = exist('endline', 'var');

if A == 1
    
    rangelines = rangelines(endline+3:end, :);
    nelements=rangelines{1};
    nranges=rangelines{1,2};
    range = zeros(nranges, 2);
    range_ids = zeros(nranges, nelements);

    range_names = rangelines((nelements+1)*2, :);
    empties = find(cellfun(@isempty,range_names));
    range_names(empties) = [];
    range_names(1) = [];

    element_colours = zeros(nelements, 3);
    start_c = 3;
    for i = 1:nelements
        element_colours(i,:) = [rangelines{start_c +(i-1)*2, 2:4}];
    end
    
    j_new = 1;
    for j = (nelements+1)*2+1:size(rangelines, 1)
        temp=rangelines(j,:);
        empties = find(cellfun(@isempty,temp));
        if length(empties) == size(rangelines, 2)
            break
        end   
        temp(empties)=[];
        range(j_new, :) = [temp{2:3}];
        range_ids(j_new, :) = [temp{4:length(temp)}];
        j_new = j_new + 1;
    end
    nelements = nelements +nelements1;
    nranges = nranges + nranges1;
    range = [range1; range];
    range_ids_new = zeros(nranges, nelements);
    range_ids_new(1:size(range_ids1, 1),1:size(range_ids1, 2)) = range_ids1;
    range_ids_new((size(range_ids1, 1) +1):end,(size(range_ids1, 2) +1):end) = range_ids;
    range_ids = range_ids_new;
    range_names = [range_names1 range_names];
    element_colours = [element_colours1; element_colours];
end

end

    
    
    
