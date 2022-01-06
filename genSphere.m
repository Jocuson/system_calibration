clear;
img = uint16(zeros(1815,1815,101));
y=915;
x=915;
r=[1:24:200];
r1 = [1     9    17    25    33    41    49    57    65    73    81    89    97   105   113   121   129   137   145   153   161   169   177   185   193];
for z=1:25
    for i=1:1815
        for j=1:1815
            if abs(sqrt((i-y)^2 + (j-x)^2)) <= r1(z)
                img(i,j,z+25) = 1000;
            end
        end
    end
end
for z=[25:-1:1]
    for i=1:1815
        for j=1:1815
            if abs(sqrt((i-y)^2 + (j-x)^2)) <= r1(z)
                img(i,j,77-z) = 1000;
            end
        end
    end
end

for i=1:1815
    for j=1:1815
            if abs(sqrt((i-y)^2 + (j-x)^2)) <= 200
                img(i,j,51) = 1000;
            end
    end
end

for zz=1:size(img,3)
    if zz==1
        imwrite(img(:,:,1),'sphere.tif');
    else
        imwrite(img(:,:,zz),'sphere.tif','writemode','append');
    end
end


