function [firstWeb,firstPhone]=minHash(tWeb,tPhone)

n=length(tWeb);
theta = randperm(n);
[~, firstWeb] = max(tWeb(theta(1:n)));
n=length(tPhone);
%theta = randperm(n);
[~, firstPhone] = max(tPhone(theta(1:n)));


if firstWeb>255
    firstWeb=255;
else
   
end

if firstPhone>255
    firstPhone=255;
else
   
end



% if firstWeb>255
%     firstWeb=ones(1,8);
% else
%     firstWeb=dec2bin(firstWeb);
%     firstWeb=num2str(firstWeb)-'0';
%     firstWeb=padarray(firstWeb,[0 8-length(firstWeb)],'pre');
% end
% 
% if firstPhone>255
%     firstPhone=ones(1,8);
% else
%     firstPhone=dec2bin(firstPhone);
%     firstPhone=num2str(firstPhone)-'0';
%     firstPhone=padarray(firstPhone,[0 8-length(firstPhone)],'pre');
% end

end
