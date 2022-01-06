clc;
clear;

%ps = 139;%2*NA/lambda*微透镜直径/Nnum/M/OSR*ns
ns = 631;%psfwavstack的xy大小,如2048
ps = 143;%2*0.45/(520*1e-9)*(100*1e-6)/15/20/3*ns;
mm = linspace(-1,1,ps);
nn = linspace(-1,1,ps);
mn = [mm;nn];

a1=rand([1 12]);
save('init_zernike\a1.mat','a1');

phase1=Copy_of_SH(a1,mn);
tmp = angle(exp(1i.* phase1));
tmp = (tmp-min(tmp(:)))./(max(tmp(:))-min(tmp(:)));
imwrite(tmp,'init_zernike\phaseadd_init1.png','png');

aber_phase=zeros(ns,ns);

aber_phase((ns-ps+2)/2:(ns+ps)/2,(ns-ps+2)/2:(ns+ps)/2) = phase1;
save('init_zernike/aber_phase_init1.mat','aber_phase');


[x2,y2] = meshgrid(-(ps-1)/2:(ps-1)/2,-(ps-1)/2:(ps-1)/2);
mask = x2.^2+y2.^2<=((ps-1)/2)^2;
