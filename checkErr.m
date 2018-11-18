function checkErr(mask,psz)
    %Check some error: if mask is a matrix and if it is valid and that
    %patch size is odd
    
    if ~ismatrix(mask); error('Invalid mask'); end
    if sum(sum(mask~=0 & mask~=1))>0; error('Invalid mask'); end
    if mod(psz,2)==0; error('Patch size psz must be odd.'); end

end

