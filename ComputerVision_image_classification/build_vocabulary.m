% Based on James Hays, Brown University

%This function will sample SIFT descriptors from the training images,
%cluster them with kmeans, and then return the cluster centers.

function vocab = build_vocabulary( image_paths, vocab_size, colour)
% The inputs are images, a N x 1 cell array of image paths and the size of 
% the vocabulary.
stepsize = 10;
magnif = 3; %magnification factor
binsize = 6; %For 4x4 sift kernal, binsize be the number of binsize is 5 pixels within a kernal block
scale = binsize/magnif;
SIFT_feat_matrix = []; 
num_images=size(image_paths,1);

if nargin < 3  || strcmp(colour, 'grey') == 1 %if no colour default to grayscale vocab collection
    for idx = 1:num_images

        if mod(idx, 25) == 0
            fprintf('%i \n', idx);
        end
        img = imread(char(image_paths(idx)));

        %converting from rgb to greyscale for vl_dsift
        %convert values to single datatype for vl_dsift
        img = single(rgb2gray(img));

      %gather the locations of center X,Y cordinates used for spatial pyramid
      %collecting SIFT featers of image based upon vocab_size magnif
      %the size is how big your kernal is going to be and also determine the
      %centeriod of the kernal pixel cordinate where the locations are for each
      %sift feature centroid = XMIN + 3/2 * binsize
      %XMIN is 1 because in matlab the pixel starts at 1 and not 0
      [~, SIFT_feat] = vl_dsift(vl_imsmooth(img, sqrt(scale)^2 - .25),'size',binsize,'step', stepsize,'fast');
        %fprintf('Collecting features\n')

        SIFT_feat_matrix = [SIFT_feat_matrix,SIFT_feat];
    end
else
    switch colour
        case 'hsv-sift'        
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

                [~, H_SIFT_features] = vl_dsift(vl_imsmooth(H, sqrt(scale)^2 - .25), 'size',binsize,'step', stepsize,'fast');
                [~, S_SIFT_features] = vl_dsift(vl_imsmooth(S, sqrt(scale)^2 - .25), 'size',binsize,'step', stepsize,'fast');
                [~, V_SIFT_features] = vl_dsift(vl_imsmooth(V, sqrt(scale)^2 - .25), 'size',binsize,'step', stepsize,'fast');
                sift_feat = [H_SIFT_features; S_SIFT_features; V_SIFT_features];
                SIFT_feat_matrix = [SIFT_feat_matrix, sift_feat];
            end 
        case 'transformed'
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

                SIFT_feat_matrix = [SIFT_feat_matrix, sift_feat];
            end
        case 'opponent-sift'
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

                SIFT_feat_matrix = [SIFT_feat_matrix, sift_feat];
            end
            
        case 'w-sift'
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
                SIFT_feat_matrix = [SIFT_feat_matrix, sift_feat];
            end
            
            
        case 'rg-sift'
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

                SIFT_feat_matrix = [SIFT_feat_matrix, sift_feat];
            end
    end
end

fprintf('Building vocab: clustering features \n');
  
[centers, ~] = vl_kmeans(single(SIFT_feat_matrix), vocab_size);
vocab = centers;   
end

