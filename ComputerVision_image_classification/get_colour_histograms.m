function [colhists_graph_feat] = get_colour_histograms (img_paths)
    %Testing experiments
    % three tests for 16,32,64 bins for each colour space

    bins = 16; %specify the number of bins to
    clrspace = "hsv"; % what kind of colour space for the histogram 'rgb', 'hsv', 'rg', 'rb', 'gb', 'gray'
    
    % Number of histograms for each image - used to preallocate memory for
    % feature vectors    
    switch clrspace
        case 'hsv'
            num_hists = 3;
        case 'rgb'
            num_hists = 3;
        case 'rg'            
            num_hists = 2;
        case 'rb'
            num_hists = 2;
        case 'gb'
            num_hists = 2;
        case 'cc'
            num_hists = 2;
        case 'gray'
            num_hists = 1;
    end
    colhists_graph_feat = zeros(size(img_paths, 1),bins*num_hists);

    for idx = 1:size(img_paths)

        img = imread(char(img_paths(idx)));
        if clrspace == "hsv"          
            img = rgb2hsv(img);
        elseif clrspace == "gray"
            %Convert to grayscale using equal weights
            img = double(img); %because RGB it needs to be coverted to double
            gray = zeros(size(img,1),size(img,2));
            gray(:,:) = (img(:,:,1)+ img(:,:,2) + img(:,:,3)) ./3;
            img = gray ./ 255;
        elseif clrspace == "cc" %rg colour Chromaticity colour space
            img = double(img);
            %divide each channel by the sum of the RGB channels for each
            %pixel, and remove the third (blue) dimension from the img matrix
            img = img./(sum(img,3)+eps);
            img (:,:,3) = [];            
        else            
            img = double(img); %because RGB it needs to be coverted to double
            img = img ./ 255; %normalize data to range 0-1 by dividing into 255
        end

        %Remove rgb component if applicable
        switch clrspace
            case 'rg'            
                img(:,:,3) = [];
            case 'rb'
                img(:,:,2) = [];
            case 'gb'
                img(:,:,1) = [];
        end
        
        hists = zeros(bins, num_hists);
        
        % Divide colour space based upon the number of bins specified
        imquant = round(img * (bins-1)) + 1; 
        
        for j = 1:size(imquant,1) %search through each row
            for k = 1:size(imquant,2) %search through each column
                for h = 1:size(hists, 2) %search through each dimension
                    hists((imquant(j,k,h)),h) = hists((imquant(j,k,h)),h) + 1;
                end
            end
        end
        %Create feature vector from historgram hists 
        feature = hists(:);
        %Normalise vector for scale invariance
        feature = feature ./ (size(img,1) * size(img, 2));
        %Add to features
        colhists_graph_feat (idx,:) = feature;
    end    
end