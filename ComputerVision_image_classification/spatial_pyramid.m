function image_feats = spatial_pyramid(image_paths, vocab_size, numLevels, colourmodel)

load('vocabs/vocab-spatial.mat');
stepsize = 10;
maxLevel = numLevels - 1; %Levels start from 0
image_feats = [];
magnif = 3; %magnification factor
binsize = 3; %multiplier for 4x4 sift kernal ie binsize is 5 kernal size will be 20 by 20
scale = binsize/magnif; %scale used for spatial smoothing of image
    for idx = 1:size(image_paths)
        if mod(idx, 25) == 0
            fprintf('%i \n', idx);
        end        
        %Read image
        img = imread(char(image_paths(idx)));
        %img = single(img);
        %Transform colour channels if applic
        switch colourmodel
            case 'transformed'
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
                [locations, b_feats] = vl_dsift(vl_imsmooth(b_trans, sqrt(scale)^2 - .25),'size',binsize,'step', stepsize,'fast');

                SIFT_features = [r_feats; g_feats; b_feats];
            case 'opponent-sift'
                img = single(img);
                
                R = img(:,:,1);
                G = img(:,:,2);
                B = img(:,:,3);

                o1 = (R - G) ./ sqrt(2);
                o2 = (R + G - (2.*B)) ./ sqrt(6);
                o3 = (R + G + B) ./ sqrt(3);

                [~, o1_feats] = vl_dsift(vl_imsmooth(o1, sqrt(scale)^2 - .25),'size',binsize,'step', stepsize,'fast');
                [~, o2_feats] = vl_dsift(vl_imsmooth(o2, sqrt(scale)^2 - .25),'size',binsize,'step', stepsize,'fast');
                [locations, o3_feats] = vl_dsift(vl_imsmooth(o3, sqrt(scale)^2 - .25),'size',binsize,'step', stepsize,'fast');

                SIFT_features = [o1_feats; o2_feats; o3_feats];      

            case 'hsv-sift'
                img = single(rgb2hsv(img)); %convert to hsv colour space

                H = img(:,:,1);
                S = img(:,:,2);
                V = img(:,:,3);

                [~, H_SIFT_features] = vl_dsift(vl_imsmooth(H,...
                    sqrt(scale)^2 - .25),...
                    'size',binsize,'step', stepsize,'fast');
                [~, S_SIFT_features] = vl_dsift(vl_imsmooth(S,...
                    sqrt(scale)^2 - .25),...
                    'size',binsize,'step', stepsize,'fast');
                [locations, V_SIFT_features] = vl_dsift(vl_imsmooth(V,...
                    sqrt(scale)^2 - .25),...
                    'size',binsize,'step', stepsize,'fast');
                SIFT_features = [H_SIFT_features; S_SIFT_features; V_SIFT_features];
            case 'w-sift'
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
                [locations, w2_feats] = vl_dsift(vl_imsmooth(w2, sqrt(scale)^2 - .25),'size',binsize,'step', stepsize,'fast');

                SIFT_features = [w1_feats; w2_feats];
            case 'rg-sift'
                img = single(img);
                R = img(:,:,1);
                G = img(:,:,2);
                B = img(:,:,3);

                r = R ./ (R + G + B);
                g = G ./ (R + G + B);
                
                r(isnan(r)) = 0;
                g(isnan(g)) = 0;
                
                [~, r_feats] = vl_dsift(vl_imsmooth(r, sqrt(scale)^2 - .25),'size',binsize,'step', stepsize,'fast');
                [locations, g_feats] = vl_dsift(vl_imsmooth(g, sqrt(scale)^2 - .25),'size',binsize,'step', stepsize,'fast');

                SIFT_features = [r_feats; g_feats];
            case 'grey'
                img = single(rgb2gray(img));        
                %Calculate sift features for image
                [locations, SIFT_features] = vl_dsift(vl_imsmooth(img, sqrt(scale)^2 - .25), 'size',binsize,'step', stepsize,'fast');
        end

        SIFT_features = single(SIFT_features);
        %Precompute distances for each feature;
        D = vl_alldist2(SIFT_features,vocab);
        [minimal, i] = min(D, [], 2);
        
        %Round locations to nearest pixel
        locations = round(locations);
        
        %Calculate histograms for highest level (lower levels will be
        %aggregates of these)
        %Number of cells in each dimension
        numCellsEachDim = 2^(numLevels - 1);
        denseHistCells = zeros(vocab_size, numCellsEachDim, numCellsEachDim);
        %Increment of x and y dimension for each successive cell
        incX = floor(size(img,1) / numCellsEachDim);
        incY = floor(size(img,2) / numCellsEachDim);
        feature = [];
        %Calc hists for each cell
        for x=1:numCellsEachDim            
            for y=1:numCellsEachDim
                start_x = (x-1) * incX;
                end_x = start_x + incX;                
                start_y = (y-1) * incY;
                end_y = start_y + incY;
                
                %TODO more efficient filtering of features for each cell
                for sftIdx = 1:size(locations, 2)
                    loc = locations(:, sftIdx);           
                    %If feature is in this cell...
                    if (loc(2) >= start_x && loc(2) < end_x ...
                            && loc(1) >= start_y && loc(1) < end_y)
                        %Increment closest histogram
                        bin = i(sftIdx);
                        denseHistCells(bin,x,y) = denseHistCells(bin, x,y) + 1;
                    end
                end
                %Normalize histogram
                denseHistCells(:,x,y) = denseHistCells(:,x,y) ./ sum(denseHistCells(:,x,y));
                %Calc weighting of highest level
                weight = 0.5;
                histFeat = weight .* (denseHistCells(:,x,y)');
                feature = [feature, histFeat];
            end
        end
        
        histCells = denseHistCells;
        %Aggregate calculated cells 
        numOldCellsPerDim = 2;
        for l=maxLevel - 1: -1 : 0
            %New cells twice the size as previous, so half as many
            newHistCells = zeros(vocab_size, size(histCells,2)/2, size(histCells,3)/2);
            for x=1:size(newHistCells,2)            
                for y=1:size(newHistCells,2) 
                    start = 2*x - 1;
                    %Aggregate cells
                    newHist = histCells(:,start, start) + histCells(:,start, start+1)...
                        + histCells(:, start+1, start) + histCells(:, start+1, start + 1);
                    %Normalise
                    newHist = newHist ./ sum(newHist);
                    newHistCells(:,x,y) = newHist;
                    
                    weight = 1 / 2^(maxLevel - l + 1);
                    histFeat = weight .* (newHistCells(:,x,y)');
                    feature = [feature, histFeat];
                end
            end
            histCells = newHistCells;
        end
    image_feats(idx, :) = feature;
    end
end

