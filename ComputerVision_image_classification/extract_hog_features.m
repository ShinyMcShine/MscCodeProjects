function feature = extract_hog_features(img)

    feature = [];
    img = rgb2gray(img);
    if size(img,3) == 1        
        %Compute gradients - pad arrays to avoid large edge gradients
        xGrad = conv2(padarray(img,[0 1], 'replicate'), [-1 0 1], 'valid');
        yGrad = conv2(padarray(img,[1 0], 'replicate'), [-1; 0; 1], 'valid');

        %Conv to polar coords
        mag = sqrt((xGrad.^2) + (yGrad.^2));
        ang = atand(yGrad./xGrad) + 90;
        ang(isnan(ang))=0;
        mag(isnan(mag))=0;     
    else
        %For each channel, choose greatest magnitude
        for channel = 1:size(img,3)            
            %Compute gradients - pad arrays to avoid large edge gradients
            xGrad = conv2(padarray(img(:,:,channel),[0 1], 'replicate'), [-1 0 1], 'valid');
            yGrad = conv2(padarray(img(:,:,channel),[1 0], 'replicate'), [-1; 0; 1], 'valid');

            %Conv to polar coords
            mags(:,:,channel) = sqrt((xGrad.^2) + (yGrad.^2));
            angs(:,:,channel) = atand(yGrad./xGrad) + 90;
        end            
        angs(isnan(angs))=0;
        mags(isnan(mags))=0;     
        
        for channel = 1:size(img,3)            
            for i=1:size(img,1)
                for j=1:size(img,2)
                    [maxMag idx] = max(mags(i,j,:));
                    mag(i,j) = maxMag;
                    ang(i,j) = angs(i,j,idx);
                end
            end
            
        end  
    end
        
        
    
    
    
    %split into cells
    cellsize=8;
    
    numcellsx = floor(size(img,1)/cellsize);
    numcellsy = floor(size(img,2)/cellsize);
    offsetx = floor(rem(size(img,1),cellsize)/2);
    offsety = floor(rem(size(img,2),cellsize)/2);
    
    cells_mag = cell([numcellsx numcellsy]);
    cells_ang = cell([numcellsx numcellsy]);
    
    for i=1:numcellsx
        for j=1:numcellsy
            start_x = ((i-1)*cellsize)+1 + offsetx;
            end_x = start_x + (cellsize-1);            
            start_y = ((j-1)*cellsize)+1 + offsety;
            end_y= start_y + (cellsize-1);
            
            cell_mag = mag(start_x:end_x,start_y:end_y);
            cell_ang = ang(start_x:end_x,start_y:end_y);
            
            cells_mag{i,j} = cell_mag;
            cells_ang{i,j} = cell_ang;
        end
    end
    
    %Calculate histograms
    numbins = 9;
    cells_hist = cell([numcellsx numcellsy]);
    
    for i=1:numcellsx
        for j=1:numcellsy
            magCell = cell2mat(cells_mag(i,j));
            angCell = cell2mat(cells_ang(i,j));
            
            
            hist = zeros(numbins,1);
            binsize = 180/numbins;
            
            for x = 1:size(angCell,1)
                for y = 1:size(angCell,2)
                    angle = mod(angCell(x,y), 180);;
                    magni = magCell(x,y);
                    
                    % Calculate bin membership
                    bin1 = mod(floor(angle/binsize), numbins) + 1;
                    bin2 = mod(bin1, numbins) + 1;
                    
                    min = (bin1 - 1) * binsize;                
                    upperProp = (angle - min) / binsize;
                    lowerProp = 1 - upperProp;

                    hist(bin1) = hist(bin1) + (magni * lowerProp);
                    hist(bin2) = hist(bin2) + (magni * upperProp);
                end
            end      
            cells_hist{i,j} = hist;
        end
    end
    
    %Normalise blocks
    blocksize = 2;
    
    stop_x = numcellsx - (blocksize-1);
    stop_y = numcellsy - (blocksize-1);
    
    for i=1:stop_x
        for j=1:stop_y
            %get block
            blockcells = cells_hist(i:i+(blocksize-1), j:j+(blocksize - 1));
            blockcells2 = blockcells';
            blockcells2 = cell2mat(blockcells2(:));
            
            %L2 norm
            e = 0.001;
            norm = sqrt(sum(blockcells2.^2) + e^2);
            
            %Normalise
            blockcells2 = blockcells2./norm;
            
            %add to features;
            feature = [feature; blockcells2];
        end
    end
    feature = single(feature);
    
end

