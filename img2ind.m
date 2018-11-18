function ind = img2ind(img)
    % Converts an RGB image into a indexed image, using the image itself as
    % the colormap.
    
    s=size(img); 
    ind=reshape(1:s(1)*s(2),s(1),s(2));
    
return;
