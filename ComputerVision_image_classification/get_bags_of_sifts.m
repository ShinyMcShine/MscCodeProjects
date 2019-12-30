function image_feats = get_bags_of_sifts(image_paths, colour)
% image_paths is an N x 1 cell array of strings where each string is an
% image path on the file system.

% This function assumes that 'vocab.mat' exists and contains an N x 128
% matrix 'vocab' where each row is a kmeans centroid or visual word. This
% matrix is saved to disk rather than passed in a parameter to avoid
% recomputing the vocabulary every time at significant expense.

%Parameters
num_images=size(image_paths,1);
magnif = 3; %magnification factor
binsize = 3;
scale = binsize/magnif; %scale used for spatial smoothing of image
stepsize = 10;

if nargin < 2 || strcmp(colour, 'grey') == 1 %if no colour default to grayscale vocab collection
    load('vocabs/vocab.mat')
    % image_feats is an N x d matrix, where d is the dimensionality of the
    % feature representation. In this case, d will equal the number of clusters
    % or equivalently the number of entries in each image's histogram.
    image_feats = zeros(size(image_paths,1),size(vocab,2));
    for idx = 1:num_images
        %img = imread(image_paths);
        img = imread(char(image_paths(idx)));
        %image(img) ;
        %converting from rgb to greyscale for vl_dsift
        %convert values to single datatype for vl_dsift
        img = single(rgb2gray(img));
        %        img = single(rgb2hsv(img));
        
        %gather the locations of center X,Y cordinates used for spatial pyramid
        %collecting SIFT featers of image based upon vocab_size magnif
        %the size is how big your kernal is going to be and also determine the
        %centeroid of the kernal pixel cordinate where the locations are for each
        %sift feature centroid = XMIN + 3/2 * binsize
        %XMIN is 1 because in matlab the pixel starts at 1 and not 0
        [locations, SIFT_features] = vl_dsift(vl_imsmooth(img,...
            sqrt(scale)^2 - .25),...
            'size',binsize,'step', stepsize,'fast');
        SIFT_features = single(SIFT_features);
        
        D = vl_alldist2(SIFT_features,vocab);%return the distances between two points from both matricies
        
        [minimal, i] = min(D, [], 2); %extracting the each minimal value from the 2nd dimension
        centroid_hist = zeros(size(vocab,2),1); %preallocating histogram for collecting centroids
        for x = 1:size(i,1)
            %populating centroid into the bin corredponding to the index of
            % minimal centroid found
            centroid_hist (i(x,1),1) = centroid_hist (i(x,1),1) +1;
        end
        centroid_hist = centroid_hist ./ sum(centroid_hist); %normalise histogram to a sum of one
        %reshaping the image_feats to a 1500 X d where d is the binsize of
        %centroids from vocab.mat file
        image_feats(idx,:) = reshape (centroid_hist(:),[1,size(centroid_hist(:,1))]);
    end
    
else
    switch colour
        case 'hsv-sift'
            load('vocabs/vocab.mat')            
            % image_feats is an N x d matrix, where d is the dimensionality of the
            % feature representation. In this case, d will equal the number of clusters
            % or equivalently the number of entries in each image's histogram.
            image_feats = zeros(size(image_paths,1),size(vocab,2));
            for idx = 1:num_images
                if mod(idx, 25) == 0
                    fprintf('%i \n', idx);
                end
                img = imread(char(image_paths(idx)));
                %image(img) ;
                img = single(rgb2hsv(img)); %convert to hsv colour space
                
                H = img(:,:,1);
                S = img(:,:,2);
                V = img(:,:,3);
                
                %gather the locations of center X,Y cordinates used for spatial pyramid
                %collecting SIFT featers of image based upon vocab_size magnif
                %the size is how big your kernal is going to be and also determine the
                %centeriod of the kernal pixel cordinate where the locations are for each
                %sift feature centroid = XMIN + 3/2 * binsize
                %XMIN is 1 because in matlab the pixel starts at 1 and not 0
                [locations, H_SIFT_features] = vl_dsift(vl_imsmooth(H,...
                    sqrt(scale)^2 - .25),...
                    'size',binsize,'step', stepsize,'fast');
                [locations, S_SIFT_features] = vl_dsift(vl_imsmooth(S,...
                    sqrt(scale)^2 - .25),...
                    'size',binsize,'step', stepsize,'fast');
                [locations, V_SIFT_features] = vl_dsift(vl_imsmooth(V,...
                    sqrt(scale)^2 - .25),...
                    'size',binsize,'step', stepsize,'fast');
                
                sift_feat = [H_SIFT_features; S_SIFT_features; V_SIFT_features];
                D = vl_alldist2(single(sift_feat),vocab);    
                
                [minimal, i] = min(D, [], 2); %extracting the each minimal value from the 2nd dimension
                centroid_hist = zeros(size(vocab,2),1); %preallocating histogram for collecting centroids
                num_centroids = size(i,1);
                for x = 1:num_centroids
                    %populating centroid into the bin corredponding to the index of
                    % minimal centroid found
                    centroid_hist (i(x,1),1) = centroid_hist (i(x,1),1) +1;
                end
                centroid_hist = centroid_hist ./ sum(centroid_hist); %normalise histogram to a sum of one
                %reshaping the image_feats to a 1500 X d where d is the binsize of
                %centroids from vocab.mat file
                image_feats(idx,:) = reshape (centroid_hist(:),[1,size(centroid_hist(:,1))]);            
            end
        case 'transformed'
            load('vocabs/vocab.mat')
            for idx = 1:num_images
                if mod(idx, 25) == 0
                    fprintf('%i \n', idx);
                end
                img = imread(char(image_paths(idx)));
                img = single(img);
                
                R = img(:,:,1);
                G = img(:,:,2);
                B = img(:,:,3);
                
                r_mean = mean(R(:));
                r_std = std(R(:));
                
                g_mean = mean(G(:));
                g_std = std(G(:));
                
                b_mean = mean(B(:));
                b_std = std(B(:));
                
                r_trans = (img(:,:,1) - r_mean) ./ r_std;
                g_trans = (img(:,:,2) - g_mean) ./ g_std;
                b_trans = (img(:,:,3) - b_mean) ./ b_std;
                
                [~, r_feats] = vl_dsift(vl_imsmooth(r_trans, sqrt(scale)^2 - .25),'size',binsize,'step', stepsize,'fast');
                [~, g_feats] = vl_dsift(vl_imsmooth(g_trans, sqrt(scale)^2 - .25),'size',binsize,'step', stepsize,'fast');
                [~, b_feats] = vl_dsift(vl_imsmooth(b_trans, sqrt(scale)^2 - .25),'size',binsize,'step', stepsize,'fast');
                
                sift_feat = [r_feats; g_feats; b_feats];
                D = vl_alldist2(single(sift_feat),vocab);
                
                [minimal, i] = min(D, [], 2); %extracting the each minimal value from the 2nd dimension
                centroid_hist = zeros(size(vocab,2),1); %preallocating histogram for collecting centroids
                num_centroids = size(i,1);
                for x = 1:num_centroids
                    %populating centroid into the bin corredponding to the index of
                    % minimal centroid found
                    centroid_hist (i(x,1),1) = centroid_hist (i(x,1),1) +1;
                end
                centroid_hist = centroid_hist ./ sum(centroid_hist); %normalise histogram to a sum of one
                %reshaping the image_feats to a 1500 X d where d is the binsize of
                %centroids from vocab.mat file
                image_feats(idx,:) = reshape (centroid_hist(:),[1,size(centroid_hist(:,1))]);
            end    
        case 'opponent-sift'
            load('vocabs/vocab.mat')
            for idx = 1:num_images
                if mod(idx, 25) == 0
                    fprintf('%i \n', idx);
                end
                img = imread(char(image_paths(idx)));
                img = single(img);
                
                R = img(:,:,1);
                G = img(:,:,2);
                B = img(:,:,3);

                o1 = (R - G) ./ sqrt(2);
                o2 = (R + G - (2.*B)) ./ sqrt(6);
                o3 = (R + G + B) ./ sqrt(3);

                [~, o1_feats] = vl_dsift(vl_imsmooth(o1, sqrt(scale)^2 - .25),'size',binsize,'step', stepsize,'fast');
                [~, o2_feats] = vl_dsift(vl_imsmooth(o2, sqrt(scale)^2 - .25),'size',binsize,'step', stepsize,'fast');
                [~, o3_feats] = vl_dsift(vl_imsmooth(o3, sqrt(scale)^2 - .25),'size',binsize,'step', stepsize,'fast');

                sift_feat = [o1_feats; o2_feats; o3_feats];
                
                sift_feat = [r_feats; g_feats; b_feats];
                D = vl_alldist2(single(sift_feat),vocab);
                
                [minimal, i] = min(D, [], 2); %extracting the each minimal value from the 2nd dimension
                centroid_hist = zeros(size(vocab,2),1); %preallocating histogram for collecting centroids
                num_centroids = size(i,1);
                for x = 1:num_centroids
                    %populating centroid into the bin corredponding to the index of
                    % minimal centroid found
                    centroid_hist (i(x,1),1) = centroid_hist (i(x,1),1) +1;
                end
                centroid_hist = centroid_hist ./ sum(centroid_hist); %normalise histogram to a sum of one
                %reshaping the image_feats to a 1500 X d where d is the binsize of
                %centroids from vocab.mat file
                image_feats(idx,:) = reshape (centroid_hist(:),[1,size(centroid_hist(:,1))]);
            end    
        case 'w-sift'
            load('vocabs/vocab.mat')
            for idx = 1:num_images
                if mod(idx, 25) == 0
                    fprintf('%i \n', idx);
                end
                img = imread(char(image_paths(idx)));
                img = single(img);
                
                R = img(:,:,1);
                G = img(:,:,2);
                B = img(:,:,3);

                o1 = (R - G) ./ sqrt(2);
                o2 = (R + G - (2.*B)) ./ sqrt(6);
                o3 = (R + G + B) ./ sqrt(3);
                
                w1 = o1./o3;
                w2 = o2./o3;
                
                w1(isnan(w1)) = 0;
                w2(isnan(w2)) = 0;
                            
                [~, w1_feats] = vl_dsift(vl_imsmooth(w1, sqrt(scale)^2 - .25),'size',binsize,'step', stepsize,'fast');
                [~, w2_feats] = vl_dsift(vl_imsmooth(w2, sqrt(scale)^2 - .25),'size',binsize,'step', stepsize,'fast');
                
                sift_feat = [w1_feats; w2_feats];
                D = vl_alldist2(single(sift_feat),vocab);
                
                [minimal, i] = min(D, [], 2); %extracting the each minimal value from the 2nd dimension
                centroid_hist = zeros(size(vocab,2),1); %preallocating histogram for collecting centroids
                num_centroids = size(i,1);
                for x = 1:num_centroids
                    %populating centroid into the bin corredponding to the index of
                    % minimal centroid found
                    centroid_hist (i(x,1),1) = centroid_hist (i(x,1),1) +1;
                end
                centroid_hist = centroid_hist ./ sum(centroid_hist); %normalise histogram to a sum of one
                %reshaping the image_feats to a 1500 X d where d is the binsize of
                %centroids from vocab.mat file
                image_feats(idx,:) = reshape (centroid_hist(:),[1,size(centroid_hist(:,1))]);
            end    
            case 'rg-sift'
            load('vocabs/vocab.mat')
            for idx = 1:num_images
                if mod(idx, 25) == 0
                    fprintf('%i \n', idx);
                end
                img = imread(char(image_paths(idx)));
                img = single(img);
                
                R = img(:,:,1);
                G = img(:,:,2);
                B = img(:,:,3);
                
                r = R ./ (R + G + B);
                g = G ./ (R + G + B);
                
                
                r(isnan(r)) = 0;
                g(isnan(g)) = 0;
                
                
                [~, r_feats] = vl_dsift(vl_imsmooth(r, sqrt(scale)^2 - .25),'size',binsize,'step', stepsize,'fast');
                [~, g_feats] = vl_dsift(vl_imsmooth(g, sqrt(scale)^2 - .25),'size',binsize,'step', stepsize,'fast');

                sift_feat = [r_feats; g_feats];
                
                D = vl_alldist2(single(sift_feat),vocab);
                
                [minimal, i] = min(D, [], 2); %extracting the each minimal value from the 2nd dimension
                centroid_hist = zeros(size(vocab,2),1); %preallocating histogram for collecting centroids
                num_centroids = size(i,1);
                for x = 1:num_centroids
                    %populating centroid into the bin corredponding to the index of
                    % minimal centroid found
                    centroid_hist (i(x,1),1) = centroid_hist (i(x,1),1) +1;
                end
                centroid_hist = centroid_hist ./ sum(centroid_hist); %normalise histogram to a sum of one
                %reshaping the image_feats to a 1500 X d where d is the binsize of
                %centroids from vocab.mat file
                image_feats(idx,:) = reshape (centroid_hist(:),[1,size(centroid_hist(:,1))]);
        end    
    end
    
end
end