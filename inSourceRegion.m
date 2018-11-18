function [isinsourceregion] = inSourceRegion(j,J,i,I,sourceRegion)
    %Return 1 true if patch is in sourceRegion
    %return 0 if patch is outside or touch targetregion
    
    isinsourceregion = 1;
    for k = j:J
        for z = i:I
            if(sourceRegion(k,z)==0)
                    isinsourceregion = 0;
            end
        end
    end            
end

