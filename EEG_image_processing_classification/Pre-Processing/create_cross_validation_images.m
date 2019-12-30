function  create_cross_validation_images (cross_val, k, data_path)
%% Using the cross_val structure I've created from cross_validation.m to extract images from each channel

%function [test_image_matrix,train_image_matrix, test_class_labels, train_class_labels] = create_cross_validation_images (cross_val, k, data_path)

x =string(k); %used for text output messages
names = fieldnames(cross_val); %stores names of fields from cross_val

fileID = fopen(strcat('image list cross validation_',x,'_build output.txt'),'w'); %opens text output file

%populate list of files for testing from cross_val structure based on
%supplied k value
test_files = cross_val.(char(names(k))); %sets the list of test file names from cross_val structure

%test_class_labels = []; %creating empty list for test class labels to match with correspoinding images

test_PO8_class_labels  = [];
test_PO7_class_labels  = [];
test_P8_class_labels   = [];
test_P7_class_labels   = [];
test_O1_class_labels   = [];
test_O2_class_labels   = [];
test_PO3_class_labels  = [];
test_PO4_class_labels  = [];

train_PO8_class_labels  = [];
train_PO7_class_labels  = [];
train_P8_class_labels   = [];
train_P7_class_labels   = [];
train_O1_class_labels   = [];
train_O2_class_labels   = [];
train_PO3_class_labels  = [];
train_PO4_class_labels  = [];

%populate list of files for training files and using 11 due to the
%structure of cross_val each corresponding test train file index location
train_files = cross_val.(char(names(k+11)));
%train_class_labels = [];

num_test_files = length(test_files); %used for for loop
num_train_files = length(train_files); %used for for loop

% test_image_matrix = []; %initalizing matrix for test images
% train_image_matrix = []; %initalizing matrix for train images

test_crossval_image_matrix_PO8 = [];
test_crossval_image_matrix_PO7 = [];
test_crossval_image_matrix_P8  = [];
test_crossval_image_matrix_P7  = [];
test_crossval_image_matrix_O1  = [];
test_crossval_image_matrix_O2  = [];
test_crossval_image_matrix_PO3 = [];
test_crossval_image_matrix_PO4 = [];

train_crossval_image_matrix_PO8 = [];
train_crossval_image_matrix_PO7 = [];
train_crossval_image_matrix_P8  = [];
train_crossval_image_matrix_P7  = [];
train_crossval_image_matrix_O1  = [];
train_crossval_image_matrix_O2  = [];
train_crossval_image_matrix_PO3 = [];
train_crossval_image_matrix_PO4 = [];

%% Building testing images
for i = 1:num_test_files
    %loading test file to create image matrices and test labels
    load (strcat(data_path,test_files(i)));
    fprintf(fileID, 'Loading file %s ......\n',test_files(i));
    fprintf(fileID,'File loaded!\n');
    fprintf(fileID,'extracting files from %s \n', char(names(k)));
    num_images = length(ImgMatrix(1,1,:));
    
    
    
    %Populate with index locations for each channel for test image data
    Channel_idx_PO8 = (1:8:num_images);
    Channel_idx_PO7 = (2:8:num_images);
    Channel_idx_P8 =  (3:8:num_images);
    Channel_idx_P7 =  (4:8:num_images);
    Channel_idx_O1 =  (5:8:num_images);
    Channel_idx_O2 =  (6:8:num_images);
    Channel_idx_PO3 = (7:8:num_images);
    Channel_idx_PO4 = (8:8:num_images);
    
    %This could be any of the Channel_idx_test_channelbecause for this data
    %they are all the same size so one was selected to representat the
    %count of images per channel extracted
    test_count = length(Channel_idx_PO8(:));
    
    
    test_PO8_image_matrix = zeros(581,615,length(Channel_idx_PO8(:)));
    test_PO7_image_matrix = zeros(581,615,length(Channel_idx_PO7(:)));
    test_P8_image_matrix = zeros(581,615,length(Channel_idx_P8(:)));
    test_P7_image_matrix = zeros(581,615,length(Channel_idx_P7(:)));
    test_O1_image_matrix = zeros(581,615,length(Channel_idx_O1(:)));
    test_O2_image_matrix = zeros(581,615,length(Channel_idx_O2(:)));
    test_PO3_image_matrix = zeros(581,615,length(Channel_idx_PO3(:)));
    test_PO4_image_matrix = zeros(581,615,length(Channel_idx_PO4(:)));
    
    
    for q = 1:test_count%extract all P08 channels
        test_PO8_image_matrix(:,:,q) = ImgMatrix(:,:,Channel_idx_PO8(q));
    end
    
    test_crossval_image_matrix_PO8 = cat(3,test_crossval_image_matrix_PO8, test_PO8_image_matrix); %build image matrix
    
    for q = 1:test_count %extract all P07 channels
        test_PO7_image_matrix(:,:,q) = ImgMatrix(:,:,Channel_idx_PO7(q));
    end
    
    test_crossval_image_matrix_PO7 = cat(3,test_crossval_image_matrix_PO7, test_PO7_image_matrix); %build image matrix
    
    for q = 1:test_count %extract all P8 channels
        test_P8_image_matrix(:,:,q) = ImgMatrix(:,:,Channel_idx_P8(q));
    end
    
    test_crossval_image_matrix_P8 = cat(3,test_crossval_image_matrix_P8, test_P8_image_matrix); %build image matrix
    
    for q = 1:test_count %extract all P7 channels
        test_P7_image_matrix(:,:,q) = ImgMatrix(:,:,Channel_idx_P7(q));
    end
    
    test_crossval_image_matrix_P7 = cat(3,test_crossval_image_matrix_P7, test_P7_image_matrix); %build image matrix
    
    for q = 1:test_count %extract all O1 channels
        test_O1_image_matrix(:,:,q) = ImgMatrix(:,:,Channel_idx_O1(q));
    end
    
    test_crossval_image_matrix_O1 = cat(3,test_crossval_image_matrix_O1, test_O1_image_matrix); %build image matrix
    
    for q = 1:test_count %extract all O2 channels
        test_O2_image_matrix(:,:,q) = ImgMatrix(:,:,Channel_idx_O2(q));
    end
    
    test_crossval_image_matrix_O2 = cat(3,test_crossval_image_matrix_O2, test_O2_image_matrix); %build image matrix
    
    for q = 1:test_count %extract all PO3 channels
        test_PO3_image_matrix(:,:,q) = ImgMatrix(:,:,Channel_idx_PO3(q));
    end
    
    test_crossval_image_matrix_PO3 = cat(3,test_crossval_image_matrix_PO3, test_PO3_image_matrix); %build image matrix
    
    for q = 1:test_count %extract all PO4 channels
        test_PO4_image_matrix(:,:,q) = ImgMatrix(:,:,Channel_idx_PO4(q));
    end
    
    test_crossval_image_matrix_PO4 = cat(3,test_crossval_image_matrix_PO4, test_PO4_image_matrix); %build image matrix
    
    %test_image_matrix = cat(3,test_image_matrix, ImgMatrix); %build image matrix
    
    
    if contains(test_files(i), 'T1') == 1
        %if the images came from T=1 file then assign 1 to the test class
        %labels
        test_PO8_class_labels = vertcat(test_PO8_class_labels,ones(length(test_PO8_image_matrix(1,1,:)),1));
        test_PO7_class_labels = vertcat(test_PO7_class_labels,ones(length(test_PO7_image_matrix(1,1,:)),1));
        test_P8_class_labels  = vertcat(test_P8_class_labels,ones(length(test_P8_image_matrix(1,1,:)),1));
        test_P7_class_labels  = vertcat(test_P7_class_labels,ones(length(test_P7_image_matrix(1,1,:)),1));
        test_O1_class_labels  = vertcat(test_O1_class_labels,ones(length(test_O1_image_matrix(1,1,:)),1));
        test_O2_class_labels  = vertcat(test_O2_class_labels,ones(length(test_O2_image_matrix(1,1,:)),1));
        test_PO3_class_labels = vertcat(test_PO3_class_labels,ones(length(test_PO3_image_matrix(1,1,:)),1));
        test_PO4_class_labels = vertcat(test_PO4_class_labels,ones(length(test_PO4_image_matrix(1,1,:)),1));
    else
        %if the images came from T=0 file then assign -1 to the test class
        %labels
        test_PO8_class_labels = vertcat(test_PO8_class_labels,ones(length(test_PO8_image_matrix(1,1,:)),1)*-1);
        test_PO7_class_labels = vertcat(test_PO7_class_labels,ones(length(test_PO7_image_matrix(1,1,:)),1)*-1);
        test_P8_class_labels  = vertcat(test_P8_class_labels,ones(length(test_P8_image_matrix(1,1,:)),1)*-1);
        test_P7_class_labels  = vertcat(test_P7_class_labels,ones(length(test_P7_image_matrix(1,1,:)),1)*-1);
        test_O1_class_labels  = vertcat(test_O1_class_labels,ones(length(test_O1_image_matrix(1,1,:)),1)*-1);
        test_O2_class_labels  = vertcat(test_O2_class_labels,ones(length(test_O2_image_matrix(1,1,:)),1)*-1);
        test_PO3_class_labels = vertcat(test_PO3_class_labels,ones(length(test_PO3_image_matrix(1,1,:)),1)*-1);
        test_PO4_class_labels = vertcat(test_PO4_class_labels,ones(length(test_PO4_image_matrix(1,1,:)),1)*-1);
        %test_class_labels = vertcat(test_class_labels,(ones(length(ImgMatrix(1,1,:)),1)*-1));
    end
end

%% Building training images
for z = 1:num_train_files
    %loading test file to create image matrix and test labels
    load (strcat(data_path,train_files(z)));
    fprintf(fileID, 'Loading file %s ......\n',train_files(z))
    fprintf(fileID,'File loaded!\n')
    fprintf(fileID,'extracting files from %s \n', char(names(k+11)));
    num_images = length(ImgMatrix(1,1,:));
    
    %Populate with index locations for each channel for test image data
    Channel_idx_PO8 = (1:8:num_images);
    Channel_idx_PO7 = (2:8:num_images);
    Channel_idx_P8 =  (3:8:num_images);
    Channel_idx_P7 =  (4:8:num_images);
    Channel_idx_O1 =  (5:8:num_images);
    Channel_idx_O2 =  (6:8:num_images);
    Channel_idx_PO3 = (7:8:num_images);
    Channel_idx_PO4 = (8:8:num_images);
    
    train_count = length(Channel_idx_PO8(:));
    
    
    train_PO8_image_matrix = zeros(581,615,length(Channel_idx_PO8(:)));
    train_PO7_image_matrix = zeros(581,615,length(Channel_idx_PO7(:)));
    train_P8_image_matrix = zeros(581,615,length(Channel_idx_P8(:)));
    train_P7_image_matrix = zeros(581,615,length(Channel_idx_P7(:)));
    train_O1_image_matrix = zeros(581,615,length(Channel_idx_O1(:)));
    train_O2_image_matrix = zeros(581,615,length(Channel_idx_O2(:)));
    train_PO3_image_matrix = zeros(581,615,length(Channel_idx_PO3(:)));
    train_PO4_image_matrix = zeros(581,615,length(Channel_idx_PO4(:)));
    
    for q = 1:train_count%extract all P08 channels
        train_PO8_image_matrix(:,:,q) = ImgMatrix(:,:,Channel_idx_PO8(q));
    end
    
    train_crossval_image_matrix_PO8 = cat(3,train_crossval_image_matrix_PO8, train_PO8_image_matrix); %build image matrix
    
    for q = 1:train_count %extract all P07 channels
        train_PO7_image_matrix(:,:,q) = ImgMatrix(:,:,Channel_idx_PO7(q));
    end
    
    train_crossval_image_matrix_PO7 = cat(3,train_crossval_image_matrix_PO7, train_PO7_image_matrix); %build image matrix
    
    for q = 1:train_count %extract all P8 channels
        train_P8_image_matrix(:,:,q) = ImgMatrix(:,:,Channel_idx_P8(q));
    end
    
    train_crossval_image_matrix_P8 = cat(3,train_crossval_image_matrix_P8, train_P8_image_matrix); %build image matrix
    
    for q = 1:train_count %extract all P7 channels
        train_P7_image_matrix(:,:,q) = ImgMatrix(:,:,Channel_idx_P7(q));
    end
    
    train_crossval_image_matrix_P7 = cat(3,train_crossval_image_matrix_P7, train_P7_image_matrix); %build image matrix
    
    for q = 1:train_count %extract all O1 channels
        train_O1_image_matrix(:,:,q) = ImgMatrix(:,:,Channel_idx_O1(q));
    end
    
    train_crossval_image_matrix_O1 = cat(3,train_crossval_image_matrix_O1, train_O1_image_matrix); %build image matrix
    
    for q = 1:train_count %extract all O2 channels
        train_O2_image_matrix(:,:,q) = ImgMatrix(:,:,Channel_idx_O2(q));
    end
    
    train_crossval_image_matrix_O2 = cat(3,train_crossval_image_matrix_O2, train_O2_image_matrix); %build image matrix
    
    for q = 1:train_count %extract all PO3 channels
        train_PO3_image_matrix(:,:,q) = ImgMatrix(:,:,Channel_idx_PO3(q));
    end
    
    train_crossval_image_matrix_PO3 = cat(3,train_crossval_image_matrix_PO3, train_PO3_image_matrix); %build image matrix
    
    for q = 1:train_count %extract all PO4 channels
        train_PO4_image_matrix(:,:,q) = ImgMatrix(:,:,Channel_idx_PO4(q));
    end
    
    train_crossval_image_matrix_PO4 = cat(3,train_crossval_image_matrix_PO4, train_PO4_image_matrix); %build image matrix
    
    %train_image_matrix = cat(3,train_image_matrix, ImgMatrix); %build image matrix
    
    if contains(train_files(z), 'T1') == 1
        %if the images came from T=1 file then assign 1 to the train class
        %labels
        train_PO8_class_labels = vertcat(train_PO8_class_labels,ones(length(train_PO8_image_matrix(1,1,:)),1));
        train_PO7_class_labels = vertcat(train_PO7_class_labels,ones(length(train_PO7_image_matrix(1,1,:)),1));
        train_P8_class_labels  = vertcat(train_P8_class_labels,ones(length(train_P8_image_matrix(1,1,:)),1));
        train_P7_class_labels  = vertcat(train_P7_class_labels,ones(length(train_P7_image_matrix(1,1,:)),1));
        train_O1_class_labels  = vertcat(train_O1_class_labels,ones(length(train_O1_image_matrix(1,1,:)),1));
        train_O2_class_labels  = vertcat(train_O2_class_labels,ones(length(train_O2_image_matrix(1,1,:)),1));
        train_PO3_class_labels = vertcat(train_PO3_class_labels,ones(length(train_PO3_image_matrix(1,1,:)),1));
        train_PO4_class_labels = vertcat(train_PO4_class_labels,ones(length(train_PO4_image_matrix(1,1,:)),1));
    else
        %if the images came from T=0 file then assign -1 to the train class
        %labels
        train_PO8_class_labels = vertcat(train_PO8_class_labels,ones(length(train_PO8_image_matrix(1,1,:)),1)*-1);
        train_PO7_class_labels = vertcat(train_PO7_class_labels,ones(length(train_PO7_image_matrix(1,1,:)),1)*-1);
        train_P8_class_labels  = vertcat(train_P8_class_labels,ones(length(train_P8_image_matrix(1,1,:)),1)*-1);
        train_P7_class_labels  = vertcat(train_P7_class_labels,ones(length(train_P7_image_matrix(1,1,:)),1)*-1);
        train_O1_class_labels  = vertcat(train_O1_class_labels,ones(length(train_O1_image_matrix(1,1,:)),1)*-1);
        train_O2_class_labels  = vertcat(train_O2_class_labels,ones(length(train_O2_image_matrix(1,1,:)),1)*-1);
        train_PO3_class_labels = vertcat(train_PO3_class_labels,ones(length(train_PO3_image_matrix(1,1,:)),1)*-1);
        train_PO4_class_labels = vertcat(train_PO4_class_labels,ones(length(train_PO4_image_matrix(1,1,:)),1)*-1);
    end
    
end


%% Covert labels and matrix from double to single
train_PO8_class_labels = single(train_PO8_class_labels);
train_PO7_class_labels = single(train_PO7_class_labels);
train_P8_class_labels  = single(train_P8_class_labels);
train_P7_class_labels  = single(train_P7_class_labels);
train_O1_class_labels  = single(train_O1_class_labels);
train_O2_class_labels  = single(train_O2_class_labels);
train_PO3_class_labels = single(train_PO3_class_labels);
train_PO4_class_labels = single(train_PO4_class_labels);

test_PO8_class_labels = single(test_PO8_class_labels);
test_PO7_class_labels = single(test_PO7_class_labels);
test_P8_class_labels  = single(test_P8_class_labels);
test_P7_class_labels  = single(test_P7_class_labels);
test_O1_class_labels  = single(test_O1_class_labels);
test_O2_class_labels  = single(test_O2_class_labels);
test_PO3_class_labels = single(test_PO3_class_labels);
test_PO4_class_labels = single(test_PO4_class_labels);

test_crossval_image_matrix_PO8  = single(test_crossval_image_matrix_PO8);
test_crossval_image_matrix_PO7  = single(test_crossval_image_matrix_PO7);
test_crossval_image_matrix_P8   = single(test_crossval_image_matrix_P8);
test_crossval_image_matrix_P7   = single(test_crossval_image_matrix_P7);
test_crossval_image_matrix_O1   = single(test_crossval_image_matrix_O1);
test_crossval_image_matrix_O2   = single(test_crossval_image_matrix_O2);
test_crossval_image_matrix_PO3  = single(test_crossval_image_matrix_PO3);
test_crossval_image_matrix_PO4  = single(test_crossval_image_matrix_PO4);

train_crossval_image_matrix_PO8 = single(train_crossval_image_matrix_PO8);
train_crossval_image_matrix_PO7 = single(train_crossval_image_matrix_PO7);
train_crossval_image_matrix_P8  = single(train_crossval_image_matrix_P8);
train_crossval_image_matrix_P7  = single(train_crossval_image_matrix_P7);
train_crossval_image_matrix_O1  = single(train_crossval_image_matrix_O1);
train_crossval_image_matrix_O2  = single(train_crossval_image_matrix_O2);
train_crossval_image_matrix_PO3 = single(train_crossval_image_matrix_PO3);
train_crossval_image_matrix_PO4 = single(train_crossval_image_matrix_PO4);

%% savefile
filename1 = strcat('Images_train_cross_validation_',x);
fprintf(fileID,'Saving file.......%s\n',filename1)
save(filename1, 'train_PO8_class_labels','train_PO7_class_labels','train_P8_class_labels',...
    'train_P7_class_labels','train_O1_class_labels','train_O2_class_labels','train_PO3_class_labels',...
    'train_PO4_class_labels','train_crossval_image_matrix_PO8','train_crossval_image_matrix_PO7',...
    'train_crossval_image_matrix_P8','train_crossval_image_matrix_P7','train_crossval_image_matrix_O1',...
    'train_crossval_image_matrix_O2','train_crossval_image_matrix_PO3','train_crossval_image_matrix_PO4','-v7.3')

filename2 = strcat('Images_test_cross_validation_',x);

fprintf(fileID,'Saving file.......%s\n',filename2)

save(filename2,'test_PO8_class_labels','test_PO7_class_labels','test_P8_class_labels',...
    'test_P7_class_labels','test_O1_class_labels','test_O2_class_labels','test_PO3_class_labels',...
    'test_PO4_class_labels','test_crossval_image_matrix_PO8','test_crossval_image_matrix_PO7',...
    'test_crossval_image_matrix_P8','test_crossval_image_matrix_P7','test_crossval_image_matrix_O1',...
    'test_crossval_image_matrix_O2','test_crossval_image_matrix_PO3','test_crossval_image_matrix_PO4','-v7.3')

fprintf(fileID,'Files saved!')
fclose(fileID);