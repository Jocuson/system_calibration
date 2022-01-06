clc;clear;
%name = 'E:\calibration\simuSphere\test1\blur_image_363.tif';
name = 'test_No0.tif';
Nnum = 15;
reference_num = 113;
angle_R = 7;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
weight = ones(Nnum,Nnum);
for i = 1:Nnum
    for j = 1:Nnum
        if (i-round(Nnum/2))^2+(j-round(Nnum/2))^2 > angle_R^2
            weight(i,j) = 0;
        end
    end
end
map_wavshape = zeros(Nnum,Nnum,2);
map_clean = zeros(Nnum,Nnum,2);
reference = double(imread(name,reference_num));
reference = reference./max(reference(:));
Cali_stack = zeros(size(reference,1),size(reference,2),Nnum * Nnum);
[coordinate1,coordinate2]=meshgrid(1:size(reference,2),1:size(reference,1));
for i = 1:Nnum^2
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    m = ceil(i/Nnum);
    n = mod(i,Nnum);
    if n == 0
        n = Nnum;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    other_view = double(imread(name,i));
    other_view = other_view./max(other_view(:));
    [output, ~] = dftregistration(fft2(reference),fft2(other_view),20);
    map_wavshape(m,n,1)= -output(1,3);
    map_wavshape(m,n,2)= -output(1,4);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp([num2str(i),'_th view has been calibrated!']);
end
map_clean(:,:,1) = weight .* filloutliers(map_wavshape(:,:,1),'spline');
map_clean(:,:,2) = weight .* filloutliers(map_wavshape(:,:,2),'spline');
figure;
subplot(121);imshow(map_clean(:,:,1),[]);
subplot(122);imshow(map_clean(:,:,2),[]);
shift_map1 = map_clean;
save('shift_map\shift_map.mat','shift_map1');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:Nnum^2
    m = ceil(i/Nnum);
    n = mod(i,Nnum);
    if n == 0
        n = Nnum;
    end
    if weight(m,n) == 1 
        other_view = double(imread(name,i));
        other_view = other_view./max(other_view(:));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Cali_stack(:,:,i) = interp2(coordinate1,coordinate2,other_view,...
            coordinate1+map_clean(m,n,2),coordinate2+map_clean(m,n,1),'cubic',0);
    end
end
imwriteTFSK(single(Cali_stack),'shift_map/Calibrate_data.tif');