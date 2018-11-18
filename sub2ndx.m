function N = sub2ndx(rows,cols,nTotalRows)
    %Converts the (rows,cols) subscript-style indices to Matlab index-style
    %indices
    
    X = rows(ones(length(cols),1),:);
    Y = cols(:,ones(1,length(rows)));
    N = X+(Y-1)*nTotalRows;
return;

