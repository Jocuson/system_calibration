function z=Copy_of_SH(c,data)
x=data(1,:);
y=data(2,:);
[X,Y]=meshgrid(x,y);
[theta,r]=cart2pol(X,Y);
idx=r<=1;
zz=zeros(size(X));
%mask = zeros(size(c));
%mask(7:end) = 1;
%c = c.*mask;

b = c(1:1);
a = c(2:end);
%a = c;
% a=c;

% zz(idx) = a*zernfun(4,0,r(idx),theta(idx));
% 
zz(idx)=b(1)*zernfun(2,0,r(idx),theta(idx))+...
a(1)*zernfun(2,2,r(idx),theta(idx))+a(2)*zernfun(2,-2,r(idx),theta(idx))+a(3)*zernfun(3,1,r(idx),theta(idx))+...
a(4)*zernfun(3,-1,r(idx),theta(idx))+a(5)*zernfun(3,3,r(idx),theta(idx))+a(6)*zernfun(3,-3,r(idx),theta(idx))+...
a(7)*zernfun(4,0,r(idx),theta(idx))+a(8)*zernfun(4,2,r(idx),theta(idx))+a(9)*zernfun(4,-2,r(idx),theta(idx))+...
a(10)*zernfun(4,4,r(idx),theta(idx))+a(11)*zernfun(4,-4,r(idx),theta(idx));


z=zz;