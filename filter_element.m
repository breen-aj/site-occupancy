function [x_A, y_A, z_A, m_A] = filter_element(x, y, z, m, rng_file, ion_name)
%this function filters out an ion of interest from APT data
% x1, y1, z1, m1 are the atoms from a .pos file 
%rng_file is the name of the range file for the corresponding data
%ion_filter is the name of the ion you wish to filter 


%read range file
[nelements, nranges, range, range_ids,range_names, element_colours] = readrange_rng05(rng_file);

index_A = find(contains(range_names,ion_name));

if index_A >1 
    for i = 1: length(index_A)
        if strlength(range_names{index_A(i)}) == strlength(ion_name)
            index_keep = i;
            break
        end
    end
index_A = index_A(index_keep);
end



ranges_A  = range_ids(:,index_A) == 1;
ranges_A = find(ranges_A);

remove = zeros(length(ranges_A),1);
for i = 1:length(ranges_A)
    if sum(range_ids(ranges_A(i),:)) > 1
        remove(i) = 1;
    end
end

remove = logical(remove);
ranges_A(remove) = [];

x_A = [];
y_A = [];
z_A = [];
m_A = [];

for i = 1:length(ranges_A)
    %filter z
    
    ion_filter_x = x(m > range(ranges_A(i), 1) & m < range(ranges_A(i), 2));
    ion_filter_y = y(m > range(ranges_A(i), 1) & m < range(ranges_A(i), 2));
    ion_filter_z = z(m > range(ranges_A(i), 1) & m < range(ranges_A(i), 2));
    ion_filter_m = m(m > range(ranges_A(i), 1) & m < range(ranges_A(i), 2));
    
    x_A = [x_A ion_filter_x];
    y_A = [y_A ion_filter_y];
    z_A = [z_A ion_filter_z];
    m_A = [m_A ion_filter_m];
    
end

end

