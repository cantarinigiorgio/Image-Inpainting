function [Hp,rows,cols] = getPatch(sz,p,psz)
    % Returns the indices for a 9x9 patch centered at pixel p.
    % [x,y] = ind2sub(sz,p);  % 2*w+1 == the patch size
   
    w=(psz-1)/2; p=p-1; y=floor(p/sz(1))+1; p=rem(p,sz(1)); x=floor(p)+1;
    rows = max(x-w,1):min(x+w,sz(1));
    cols = (max(y-w,1):min(y+w,sz(2)))';
    Hp = sub2ndx(rows,cols,sz(1));
return;