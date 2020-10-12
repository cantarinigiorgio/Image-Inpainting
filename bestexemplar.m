function Hq = bestexemplar(img,Ip,toFill,sourceRegion,rows,cols)
    % Scans over the entire image (with a sliding window)
    % for the exemplar with the lowest error.
    
    m=size(Ip,1);
    mm=size(img,1);
    n=size(Ip,2);
    nn=size(img,2);

    %rows cols indexes of patch with maximum priority
% 	mn=m*n;
% 	mmnn=mm*nn;

	patchErr=0.0;
% 	err=0.0;
	bestErr=1000000000.0;
	best = zeros(1,4);%1x4 vector that will contain the coordinates of the most similar patch Iq

	%foreach patch 
	N=nn-n+1;%300-9+1
	M=mm-m+1;%300-9+1
  
	Ip = rgb2lab(Ip);
	img = rgb2lab(img);

	%sliding window over the image
	for j = 1:M %1:282 ROWS
        J=j+m-1;
        for i = 1:N %1:282 COLS
            I = i+n-1;
        
            %check that sliding window is inside source region and outside Ip
            if(inSourceRegion(j,J,i,I,sourceRegion) && outsideIp(rows,cols,j,J,i,I))

                patchErr = ssd(Ip,img(j:J,i:I,:),toFill);

                if (patchErr <= bestErr) %Update
                    bestErr = patchErr;
                    best(1,1) = j; best(1,2) = J;
                    best(1,3) = i; best(1,4) = I;
            
                end

            end
        end
    
	end

    Hq = sub2ndx(best(1):best(2),(best(3):best(4))',mm);

return;
