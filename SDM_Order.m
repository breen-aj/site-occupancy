function [OrderPara] = SDM_Order(OrderPara, Sites, Pref, Bulk)
%This function calculates the Ordering parameter based on
% the alpha and beta site occupancies and bulk composition
% Alpha sites first

J = 0;
K = 0;
L = 0;
M = 0;

for i=1:2:length(Pref)
    if Pref(i) == 'A'
        J = J + Sites(i,1);
        K = K + Bulk(i,1);
        L = L + Sites(i+1,1);
        M = M + Bulk(i+1,1);
    end
    Alpha_order = 0.75 .* ((J - K)/(1 - K));
    Alpha_error = ((J - K)/(1 - K)).^2 .* (((L.^2 + M.^2)/(J - K).^2) + ((M.^2)/((1 - K).^2)));
end


% Beta sites next
J = 0;
K = 0;
L = 0;
M = 0;

for i=1:2:length(Pref)
    if Pref(i) == 'B'
        J = J + Sites(i,2);
        K = K + Bulk(i,1);
        L = L + Sites(i+1,2);
        M = M + Bulk(i+1,1);
    end
    Beta_order = 0.25 .* ((J - K)/(1 - K));
    Beta_error = ((J - K)/(1 - K)).^2 .* (((L.^2 + M.^2)/(J - K).^2) + ((M.^2)/((1 - K).^2)));
end


% Finalizing
OrderPara = [(Alpha_order + Beta_order) ; (sqrt((9/16 .* Alpha_error) + (1/16 .* Beta_error)))];