
MainFolder = 'E:\calibration\simuSphere';
SubFolder = '\test1';
savepath = strcat(MainFolder,SubFolder);
safemkdir(savepath);
psf = load('D:\Projects\psfs\psf_M20_NA50_fml2100_z100_dz500_init1_aber.mat');
psf = psf.psf;
Nnum = 15;
conSize = 1815;
Xguess = single(zeros(conSize,conSize,101));

for i=1:101
    Xguess(:,:,i) = imread([MainFolder,'\sphere.tif'],i);
end

HXguess = single(zeros(conSize,conSize,15,15));
Xguess_image_363 = uint16(zeros(363,363,225));
Xguess_image = single(zeros(conSize,conSize,225));
for u_2=1:Nnum
        for v_2=1:Nnum            
           psf_uv=single(squeeze(psf(:,:,u_2,v_2,:)));
           forwardFUN = @(Xguess1) forwardProjectACC( psf_uv, Xguess);
           HXguess(:,:,u_2,v_2)=forwardFUN(Xguess);      
           index = (u_2 - 1 ) * Nnum + v_2;
           Xguess_image(:,:,index) = HXguess(:,:,u_2,v_2);
           Xguess_image_363(:,:,index) = uint16(imresize(Xguess_image(:,:,index),[363,363]));
        end
end
for z=1:225
    Xguess_z = Xguess_image(:,:,z);
    Xguess_image_up_z =  Xguess_image_363(:,:,z);
    Xguess_z(Xguess_z<1e-5) = 1e-5;
    Xguess_image_up_z(Xguess_image_up_z<1e-5) = 1e-5;   
end
imwriteTFSK(gather(Xguess_image),[MainFolder,SubFolder,'\blur_image.tif']);
for zz=1:size(Xguess_image_363,3)
    if zz == 1
        imwrite(Xguess_image_363(:,:,1),[MainFolder,SubFolder,'\blur_image_363.tif']);
    else
        imwrite(Xguess_image_363(:,:,zz),[MainFolder,SubFolder,'\blur_image_363.tif'],'WriteMode','append');
    end
end
