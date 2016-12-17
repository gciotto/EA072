clear all;format long;format compact;
load('sunspot.txt');
[nl,nc] = size(sunspot);
d = [];
for i=1:nl,
    d = [d;sunspot(i,2:13)'];
end
save sunspot d;
