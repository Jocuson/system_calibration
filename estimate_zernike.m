clc;
clear;

load('D:\Projects\Code_calibration\shift_map_init4.mat');
shift_kernel = squeeze(shift_map1);
Nnum = 15;
[Sx,Sy]=meshgrid([-fix(Nnum/2):fix(Nnum/2)],[-fix(Nnum/2):fix(Nnum/2)]);
mask = (Sx.^2+Sy.^2)<=7^2;
shift_kernel(:,:,1) = shift_kernel(:,:,1).*mask;
shift_kernel(:,:,2) = shift_kernel(:,:,2).*mask;

waveShape = -shift_kernel;
% waveShape = -shift;
waveShape(abs(waveShape)>50) = 0;
[Nnum,~] = size(waveShape);
r_actual = 14.0;
expand = 5;
waveShape_expand = zeros(expand*Nnum,expand*Nnum,2);
for idu = 1:Nnum
    for idv = 1:Nnum
        waveShape_expand((idu-1)*expand+1:idu*expand,(idv-1)*expand+1:idv*expand,1) = waveShape(idu,idv,1);
        waveShape_expand((idu-1)*expand+1:idu*expand,(idv-1)*expand+1:idv*expand,2) = waveShape(idu,idv,2);
    end
end
[xx,yy] = meshgrid(-(expand*size(waveShape,1)-1)/2:(expand*size(waveShape,1)-1)/2,...
    -(expand*size(waveShape,1)-1)/2:(expand*size(waveShape,1)-1)/2);
mask = xx.^2+yy.^2<=((expand*r_actual/2).^2);
waveShape_expand = waveShape_expand.*mask;
waveShape_expand = waveShape_expand((end+1)/2-round(expand*r_actual/2):(end+1)/2+round(expand*r_actual/2),...
    (end+1)/2-round(expand*r_actual/2):(end+1)/2+round(expand*r_actual/2),:);

ps = 143;
ns = 631;

[x1,y1] = meshgrid(1:size(waveShape_expand,1),1:size(waveShape_expand,2));
[x2,y2] = meshgrid(linspace(1,size(waveShape_expand,1),ps),linspace(1,size(waveShape_expand,1),ps));

calcu_dephase = zeros(ps,ps,2);
calcu_dephase(:,:,1)  = interp2(x1,y1,waveShape_expand(:,:,1),x2,y2,'nearest');
calcu_dephase(:,:,2)  = interp2(x1,y1,waveShape_expand(:,:,2),x2,y2,'nearest');

maxIte = 1000;
calcu_phase = intercircle_zy(calcu_dephase,maxIte);

% 加载之前随便生成的aber_phase，计算后面用的系数，直接用polyfit(,,1)取第一项，或者保存下来用curve fitting线性拟合
% load('mats/aber_phase_init.mat');
% p = polyfit(calcu_phase,aber_phase((ns-ps+2)/2:(ns+ps)/2,(ns-ps+2)/2:(ns+ps)/2),1);
% aber_phase1 = aber_phase((ns-ps+2)/2:(ns+ps)/2,(ns-ps+2)/2:(ns+ps)/2);
% save('mats/aber_phase1.mat','aber_phase1');
% save('mats/calcu_phase.mat','calcu_phase');

[rr,cc] = size(calcu_phase);
ra = (rr-1)/2;
[xx,yy]=meshgrid([-ra:ra],[-ra:ra]);
mask = xx.^2+yy.^2<=(ra^2);
kvalue = linspace(0.05,1,20);
% for i=1:length(kvalue)
    calcu_phase_k = 1 *calcu_phase.*mask; %随便给个系数，原来代码里面的aber_phase，然后算出来一个calcu_phase，这个系数设为aber_phase/calcu_phase

    x=linspace(-1,1,size(calcu_phase_k,1));
    y=linspace(-1,1,size(calcu_phase_k,2));
    xy=[x;y];
    a1=lsqcurvefit('Copy_of_SH',zeros(1,12),xy,calcu_phase_k);
    %a1(4) = 0; %如果对焦不好，把这个系数置0
    savepath = ['D:\Projects\genePSF\mats\','0.112'];
    mkdir(savepath);
    save([savepath,'/zernike_para.mat'],'a1');
    % % % %

    ps = 143;%2*NA/lambda*微透镜直径/Nnum/M/OSR*ns
    ns = 631;%psfwavstack的xy大小,如721
    mm = linspace(-1,1,ps);
    nn = linspace(-1,1,ps);
    mn = [mm;nn];

    phase1=Copy_2_of_SH(a1,mn);
    tmp = angle(exp(1i.* phase1));
    tmp = (tmp-min(tmp(:)))./(max(tmp(:))-min(tmp(:)));
    imwrite(tmp,[savepath,'/phaseadd.png'],'png');

    aber_phase=zeros(ns,ns);
    aber_phase((ns-ps+2)/2:(ns+ps)/2,(ns-ps+2)/2:(ns+ps)/2) = phase1;
    save([savepath,'/aber_phase.mat'],'aber_phase');

%     [x2,y2] = meshgrid(-(ps-1)/2:(ps-1)/2,-(ps-1)/2:(ps-1)/2);
%     mask = x2.^2+y2.^2<=((ps-1)/2)^2;
% end
