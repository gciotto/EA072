clear all;format long;format compact;
load('wineq.txt');
[nl,nc] = size(wineq);
for i=1:nc,
    v_max = max(wineq(:,i));
    wineq(:,i) = wineq(:,i)./v_max;
end
X = wineq(:,1:nc-1);
S = wineq(:,nc);
save wineq X S;
