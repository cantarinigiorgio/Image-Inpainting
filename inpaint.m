function [inpaintedImg] = inpaint(imagefilename,maskfilename,psz)

    %%%The code is based on 'Region Filling and Object Removal by Exemplar-Based Image Inpainting' by A.Criminisi*,
    %%%P.Pèrez and K.Toyama (https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/criminisi_tip2004.pdf)

    %%% Inputs: 
    %   - Img       MxN matrix representing the image(corrupted or not)
    %   - mask      MxN binary matrix which values represent source and target region(0,1) 
    %   - psz       patch size (odd scalar)(if psz=9, patch size is 9x9)
    %
    %%% Outputs:
    %   - inpaintedImg   The inpainted image; an MxNx3 matrix of doubles. 
    %%%%%   - C              MxN matrix of confidence values accumulated over all iterations.
    %%%%%   - D              MxN matrix of data term values accumulated over all iterations.
    %%%%%   - fillMovie      A Matlab movie struct depicting the fill region over time. 


    Img = imread(imagefilename);
    mask = double(imread(maskfilename)/255);
    nout=4;
   
    % Check if mask and patch size are valid
    checkErr(mask,psz);


    fillRegion = mask;

    Img = double(Img);
    auxImg = Img;
    indexes = img2ind(auxImg);
    sz = [size(auxImg,1) size(auxImg,2)];
    sourceRegion = ~fillRegion;

    % Initialize isophote values
    [Ix(:,:,3), Iy(:,:,3)] = gradient(auxImg(:,:,3));
    [Ix(:,:,2), Iy(:,:,2)] = gradient(auxImg(:,:,2));
    [Ix(:,:,1), Iy(:,:,1)] = gradient(auxImg(:,:,1));
    Ix = sum(Ix,3)/(3*255); Iy = sum(Iy,3)/(3*255);
    temp = Ix; Ix = -Iy; Iy = temp;  % Rotate gradient 90 degrees

    % Initialize confidence and data terms
    C = double(sourceRegion);
    D = repmat(-.1,sz);
    iter = 1;
    
% %     Seed 'rand' for reproducible results (good for testing)
%     rand('state',0);

    % Loop until entire fill region has been covered
    var = 1;

    while any(fillRegion(:))    %while each element is nonzero(the regione to be
                                %inpainted is filled at all)
      iteration = var
      var = var + 1;

      %Find contour(making convolution with laplacian filter we find edge) & normalized gradients of fill region
      fillRegionD = double(fillRegion);
      contour = find(conv2(fillRegionD,[1,1,1;1,-8,1;1,1,1],'same')>0);%fill front

%%%%%%%%%%%%%%%

      [Nx,Ny] = gradient(double(~fillRegion)); 
      N = [Nx(contour(:)) Ny(contour(:))];
      N = normr(N);  
      N(~isfinite(N))=0; % handle NaN and Inf

      % Compute confidences along the fill front
      for k = contour'
        Hp = getPatch(sz,k,psz);
        q = Hp(~(fillRegion(Hp))); 
        C(k) = sum(C(q))/numel(Hp);
      end

      % Compute data term
      D(contour) = abs(Ix(contour).*N(:,1)+Iy(contour).*N(:,2)) + 0.001;%
      
      % Compute patch priorities = confidence term * data term
      priorities = C(contour).* D(contour);

      % Find patch with maximum priority, Hp
      [~,ndx] = max(priorities(:));
      p = contour(ndx(1));
      [Hp,rows,cols] = getPatch(sz,p,psz);
      toFill = fillRegion(Hp);

%     imshow(uint8(auxImg));figure
%       inpaintedMovie(iter) = im2frame(uint8(auxImg));

      % Find exemplar that minimizes error, Hq
      Hq = bestexemplar(auxImg,auxImg(rows,cols,:),toFill',sourceRegion,rows,cols);%,var);

      % Update fill region
      toFill = logical(toFill);                 
      fillRegion(Hp(toFill)) = false;

      % Propagate confidence & isophote values
      C(Hp(toFill))  = C(p);
      Ix(Hp(toFill)) = Ix(Hq(toFill));
      Iy(Hp(toFill)) = Iy(Hq(toFill));

      % Copy image data from Hq to Hp
      indexes(Hp(toFill)) = indexes(Hq(toFill));
      auxImg(rows,cols,:) = ind2img(indexes(rows,cols),Img);  
      
    
      iter = iter+1;
    end

    %%TO CREATE A MOVIE http://matlab.wikia.com/wiki/FAQ#How_can_I_create_a_movie_from_my_MATLAB_figures.3F
%     inpaintedMovie(iter) = im2frame(uint8(auxImg));

%     axis off; 

%     movie(inpaintedMovie,1);
    inpaintedImg = auxImg;

end

