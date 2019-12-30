%% This is to load all the subjects images then produce the Eigenvectors
%function ChannelEigenValues (channel)
channels = {'O1','O2'}; %what channels will be used for feature vectors
for s = 1:11
    file_path = 'E:\KDD\2nd Semester\Dissertation\Datasets\EEG_Spectrogram_CrossVal\';
    
    
    class_filename = '_class_labels';
    xchnl = length(channels);
    var = 0.99; %set threshold for Eigenvalues variance
    
    var_test_labels = cell(xchnl,1);
    var_test_images = cell(xchnl,1);
    test_class_labels = [];
    images = [];
    
    cross = string(s); %specify which test cross validation files you want to load
    cross_val = s; %specifiy what Subject Number to saved filename as
    %% Adding file and image matrices variables
    for z = 1:xchnl %building test file names for loading variables
        test_label_filename = 'test_';
        test_image_filename = 'test_crossval_image_matrix_';
        var_test_images{z,1} = strcat(test_image_filename,channels{z});
        var_test_labels{z,1} = strcat(test_label_filename,channels{z},class_filename);
    end
    %% Loading images and labels from the test cross validation data variables to add images together
    for tst_images = 1:xchnl%loading test images .mat files with specific variables by channel
        file = strcat(file_path,'Images_test_cross_validation_',cross,'.mat');
        fprintf('Loading test images/labels file %s for cross validation %s and channel %s \n',file,cross)
        fprintf('Loading channels %s\n',channels{tst_images})
        load(file,var_test_labels{tst_images},var_test_images{tst_images});
        %fprintf('Images and labels loaded for channel %s \n', channel)
                
    end
    %building images combining all channels and their associated
    %labels
    images1 = eval(var_test_images{1});
    images2 = eval(var_test_images{2});
    
    test_class_labels1 = eval(var_test_labels{1});
    test_class_labels2 = eval(var_test_labels{2});
    %% Perform Equal Size Sampling of T=0 and T=1 images1
    T1=[];
    T0=[];
    T1 = sum(test_class_labels1(:) == 1);
    T0 = sum(test_class_labels1(:) == -1);
    
    Diff = abs(T1-T0);
    
    if T1 < T0
        [I] = test_class_labels1(:) == -1;
        
    else
        [I] = test_class_labels1(:) == 1;
    end
    x = 1;
    
    while Diff > 0
        if I(x) == 1
            images1(:,:,x) = [];
            test_class_labels1(x) = [];
            Diff = Diff -1;
            I(x) = [];
            % x = x+1;
        else
            x = x+1;
        end
    end
    %% Perform Equal Size Sampling of T=0 and T=1 images2
    T1=[];
    T0=[];
    T1 = sum(test_class_labels2(:) == 1);
    T0 = sum(test_class_labels2(:) == -1);
    
    Diff = abs(T1-T0);
    
    if T1 < T0
        [I] = test_class_labels2(:) == -1;
        
    else
        [I] = test_class_labels2(:) == 1;
    end
    x = 1;
    
    while Diff > 0
        if I(x) == 1
            images2(:,:,x) = [];
            test_class_labels2(x) = [];
            Diff = Diff -1;
            I(x) = [];
            % x = x+1;
        else
            x = x+1;
        end
    end
    %% Take the mean of the images across channels
    images = images1 + images2;
    images(:,1 : 102,:)=[];%Crop image keeping time range 0 to -250ms removing outliers
    %both channel labels are the same for a subject so there is no need to combine them both
    test_class_labels = test_class_labels1; 
    %% Randomly Sample T=0 and T=1 images to build equal number of test and train images
    num_images = length(images(1,1,:));
    equalSampSize = num_images/2;
    
    Selrandom = randperm(num_images, equalSampSize); %randomly select images for test and train split
    train_image_matrix = zeros(581,513,equalSampSize);
    %populate train image matrices from randomly selected images
    train_image_matrix = images(:,:,Selrandom);
    train_class_labels = test_class_labels(Selrandom);
    %remove the randomly selected images that were moved to trn_image_matrix
    images(:,:,Selrandom) = [];
    test_class_labels(Selrandom) = [];
    
    %% Create Eigenvectors and Eigenvalues
    Eigen_Vectors (images,train_image_matrix,cross_val,test_class_labels, train_class_labels,var);
end