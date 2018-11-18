function img2 = ind2img(ind,img)
    %Converts an indexed image into an RGB image, using 'img' as a colormap
    
    for i=3:-1:1, temp=img(:,:,i); img2(:,:,i)=temp(ind); end

return