function [isoutsideIp] = outsideIp(rows,cols,j,J,i,I)
    %Return 1 true if the sliding window is outside Ip
    %return 0 false if the sliding window is inside Ip and so it has not to be
    %verified(is inside = touch or contain)
    
    isoutsideIp = 1;
    if((ismember(j,rows) || ismember(J,rows)) && ((ismember(i,cols) || ismember(I,cols))))
        isoutsideIp = 0;
    end
 
end

