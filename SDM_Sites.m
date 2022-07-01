function [Sites] = SDM_Sites(Sites, Planes, Bulk)
%This function calculates the Site occupancies of alpha 
%based on A-plane compositions, and occupancies of beta
%based on alpha site and bulk compositions

Alpha = Sites(:,1);
Beta = Sites(:,2);
Beta_raw = Beta;

for i=1:2:length(Alpha)
    J = Planes.^2;
    Alpha(i) = Planes(i,1)/sum(Planes(1:2:end,1));
    Alpha(i+1) = sqrt(Alpha(i).^2  .* ((J(i+1,1)/J(i,1)) + (sum(J(2:2:end,1))/(sum(Planes(1:2:end,1)).^2))));
end


for i=1:2:length(Bulk)
    if Bulk(i) - 0.75 .* Alpha(i) < 0
        Beta_raw(i) = 0;
    else
        Beta_raw(i) = Bulk(i) - 0.75 .* Alpha(i);
    end
    Beta_raw(i+1) = sqrt(Bulk(i+1).^2 + ((9/16) .* Alpha(i+1).^2));
end


for i=1:2:length(Beta)
    J = Beta_raw.^2;
    Beta(i) = Beta_raw(i)/sum(Beta_raw(1:2:end));
    Beta(i+1) = sqrt(Beta(i).^2 .* ((J(i+1)/J(i)) + ((sum(J(2:2:end)))/(sum(Beta_raw(1:2:end)).^2))));
end

Beta(isnan(Beta))=0;

Sites = [Alpha Beta];