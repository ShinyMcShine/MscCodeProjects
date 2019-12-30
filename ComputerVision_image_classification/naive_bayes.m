%Multinominal naive bayes classifier
function predicted_categories = naive_bayes(train_image_feats, train_labels, test_image_feats)
    %Split training data by category
    labels = sort(unique(train_labels)); %Findgroups will list category arrays in alphabetical order
    groups = findgroups(train_labels);
    fun = @(arr) {arr};
    training_splits = splitapply(fun, train_image_feats, groups);
    %Index of category in groups is corresponding index to training set in
    %training_splits.
    
    %Compute likelihood of encountering a value in each bin for each
    %category, p(x|C)
    likelihoods = zeros(numel(labels), size(train_image_feats, 2));
    for i=1:size(training_splits,1)
        catFeats = cell2mat(training_splits(i));
        catHist = zeros(1,size(catFeats,2));
        for f=1:size(catFeats,1)
            feat = catFeats(f,:);
            catHist = catHist + feat;
        end
        elementsInHist = numel(catHist(catHist~=0));
        histSize = numel(catHist);
        %Apply laplace smoothing to account for 0s in likelihoods
        catHist = (catHist + 1) ./ (elementsInHist + histSize);
        likelihoods(i,:) = catHist;
        
    end
    %Normalize probability distribution
    %likelihoods = likelihoods ./ sum(likelihoods);
    
    
    %Calcuate prediction
    for i=1:size(test_image_feats,1)
        feat = test_image_feats(i,:);
        feat = feat(:);
        
        probs = zeros(size(training_splits,1), 1);
        for cat=1:size(likelihoods, 1)
            prob = 0;
            %Calculate probabilities using log-likelihood
            for attr=1:numel(feat)
                if feat(attr) > 0
                    prob_attr = feat(attr) * log(likelihoods(cat,attr));
                    prob = prob + prob_attr ;
                end
            end
            probs(cat) = prob;
        end        
        [~, idx] = max(probs);
        category = labels(idx); %Prediction
        predicted_categories(i) = category;
    end
    
    predicted_categories = predicted_categories';
   
end