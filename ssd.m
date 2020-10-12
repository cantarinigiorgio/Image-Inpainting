function [ssdout] = ssd(Ip,patch,toFill)
    %This function return the SSD(sum of squared difference)
    %in case of RGB images compute the mean of the difference of each
    %channel and then return the mean of the three values
    
    Ip=double(Ip);
    patch=double(patch);
    ssdout = 0;

    
    if(size(Ip,3)==3)
        C = zeros(1,3);
        
        for k=1:3
                X = (patch(:,:,k)-Ip(:,:,k)).^2;
                X(logical(toFill))=0;
                ssd = sum(X(:));
                C(1,k) = ssd;
            
        end

        ssdout = mean(C);

    end
    
end

