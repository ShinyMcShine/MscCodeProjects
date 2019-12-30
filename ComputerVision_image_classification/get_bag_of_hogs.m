function image_feats = get_bag_of_hogs(img_paths)
    load('vocabs/hog_vocab.mat')  
    vocab = vocab';  
    numimgs = size(img_paths,1)
    for idx = 1:numimgs
            if mod(idx, 25) == 0
                fprintf('%i \n', idx);
            end
        img = imread(char(img_paths(idx)));
        img = rgb2hsv(img);
        imfeats = extract_hog_features(img);
        imfeats2 = reshape(imfeats', 9, [])'; %back into cells
        
        hist = zeros(size(vocab, 1),1);
        
        %Find closest centroid for each feature
        for c=1:size(imfeats2,1)
            feature = imfeats2(c,:);
            
           %Get hist intersection score for each word
           scores = zeros(size(vocab, 1), 1);
           for w=1:size(vocab, 1)
               word = vocab(w,:);
               word = word(:);
               
               scores(w) = histogram_intersection(feature, word);               
           end
           %Highest score = greatest intersection
           [maxInter, maxIdx] = max(scores);
           hist(maxIdx) = hist(maxIdx) + 1;   
        end
        
        
        %Normalise histogram
        hist  = hist ./ sum(hist);
        
        image_feats(idx,:)= hist;
        
        %Supplement with colour histogram
        
    end
end


function score = histogram_intersection(h1, h2)
    score = 0;
    for i=1:numel(h1)
        score = score + min(h1(i), h2(i));
    end    
end

