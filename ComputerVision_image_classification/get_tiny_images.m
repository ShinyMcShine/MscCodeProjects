function features = get_tiny_images(image_paths)
    % Parameters for testing different variation of algorithm
    greyscale = false; % Produce feature vector containing all 3 colour channels or just greyscale
    normalise = true; % Normalise to 0 mean, 1 s.d.
    crop = false;
    width = 4;
    height = 4;
    
    
    
    if greyscale
        channels = 1;
    else
        channels = 3;
    end
        
    % Initialise feature vectors
    features = zeros(size(image_paths,1), width * height * channels);
    
    %Process each image
    for i=1:size(image_paths)
        img = imread(char(image_paths(i)));
        img = rgb2hsv(img);
        %Resize image
        %If cropping image, scale according to smallest dimension, then
        %crop other dimension, else just resize both
        if crop
            if size(img, 1) >= size(img,2)
                cropImg=imresize(img,[NaN,height]);
                [imgWidth,imgHeight,channels] = size(cropImg);
                %Crop to central square
                x1 = round((imgWidth - width)/2);
                x2 = x1 + width;
                cropImg=cropImg(x1 + 1:x2,1:height,:);
               
            else
                cropImg=imresize(img,[width,NaN]);
                [imgWidth,imgHeight, channels] = size(cropImg);
                %Crop to central square
                y1 = round((imgHeight - height)/2);
                y2 = y1 + width;
                cropImg=cropImg(1:width,y1 + 1:y2,:);
            end
        else
            cropImg = imresize(img, [width, height]);
        end
        
        %Convert to greyscale (if applic), reshape and ad
        if greyscale
            cropImg = double(cropImg);
            finalImg = (cropImg(:,:,1) + cropImg(:,:,2) + cropImg(:,:,3)) ./ 3;
            finalImg = uint8(finalImg);
        else
            finalImg = cropImg;
        end
        
        
        imgFeatures = double(finalImg(:));
        
        %Perform normalisation (if applic)
        if normalise
            %Calc means
            m = mean(imgFeatures);
            sd = std(imgFeatures);
            imgFeatures = (imgFeatures - m)./sd;
        end
        
        %Reshape, add to features
        features(i,:) = imgFeatures;
    end
        
        
    
end

