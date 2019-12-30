function vocab = build_hog_vocab(img_paths,vocab_size)
buildEachTime = true; % make false to cache for different sized clusters without recomputing
if exist('vocabs/precluster-hog.mat', 'file') && buildEachTime == false
    fprintf('Using precomputed features\n')
    load('vocabs/precluster-hog.mat');
else
    features = [];
    for idx = 1:size(img_paths)
            if mod(idx, 25) == 0
                fprintf('%i \n', idx);
            end
        img = imread(char(img_paths(idx)));
        imfeats = extract_hog_features(img)';
        %Split back into cells
        imfeats2 = reshape(imfeats', 9, []);
        features = [features imfeats2];
    end
    features = single(features);    
    save('vocabs/precluster-hog.mat', 'features')
end
    fprintf('Performing k means clustering for HOG Vocabulary');
    [vocab assignments] = vl_kmeans(features, vocab_size);
   %Normalise vocab to histograms
   for i=1:size(vocab, 2)
       vocab(:,i) = vocab(:,i) ./ sum(vocab(:,i));
   end    
end

