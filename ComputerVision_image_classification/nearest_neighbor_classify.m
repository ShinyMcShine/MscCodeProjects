function predicted_categories = nearest_neighbor_classify(train_image_feats, train_labels, test_image_feats)
    %Parameters for k and the distance metric to use
    % distance_metric can be one of
    % 'euclidean', 'cityblock', 'minkowski' etc.
    k = 19;
    fprintf('Using k-value of %s \n',string(k))
    distance_metric = 'cityblock';
    
    
    %Calculate euclidean distance between each test point and each training
    %point - in result matrix, each column represents test point and each
    %row the distance between that point and a training point
    distances = pdist2(train_image_feats, test_image_feats, distance_metric);
    
    %Sort each column by distance - indices returns the original positions
    %of each element, for use when matching with training labels
    [sorted, indices] = sort(distances,1);
    
    %Take first k rows...
    Idx = indices(1:k, :);
    
    %Substitute with training label
    for i=1:size(Idx,1)
        for j=1:size(Idx,2)
            nearest_categories(i,j) = train_labels(Idx(i,j));
        end
    end
    
    %Conversion to categorical rrquired as Matlab can't do columnwise mode
    %calculation for cells
    nearest_categories = categorical(nearest_categories);
    
    %Take modal value for each column, convert result back to cell array
    predicted_categories = cellstr(mode(nearest_categories,1))';
    
    
end

