function [test_class_labels, train_class_labels, test_image_matrix, train_image_matrix] = load_train_test_cross_validation (channels,xval,file_path)
%% This function was used by svm_classify to load images before submitting to model This produces an unequal data sample of T=0 and T=1
xchnl = length(channels); %setting the number of channels to extract

cross = string(xval);
%% building variables for loading image matrices and labels
class_filename = '_class_labels';
var_test_labels = cell(xchnl,1);
var_train_labels = cell(xchnl,1);

var_test_images = cell(xchnl,1);
var_train_images = cell(xchnl,1);


test_class_labels = [];
train_class_labels = [];

test_image_matrix = [];
train_image_matrix = [];
%% Adding file and image matrices variables
for z = 1:xchnl %building test file names for loading variables
    test_label_filename = 'test_';
    test_image_filename = 'test_crossval_image_matrix_';
    var_test_images{z,1} = strcat(test_image_filename,channels{z});
    var_test_labels{z,1} = strcat(test_label_filename,channels{z},class_filename);
end


for a = 1:xchnl %building train file names for loading variables
    
    train_image_filename = 'train_crossval_image_matrix_'; %setting up naming conventions
    train_label_filename = 'train_';
    
    var_train_labels{a,1} = strcat(train_label_filename,channels{a},class_filename);
    var_train_images{a,1} = strcat(train_image_filename,channels{a});
end
%% Loading test/train images and labels based on channels
for tst_images = 1:xchnl%loading test images .mat files with specific variables by channel
    
    file = strcat(file_path,'Images_test_cross_validation_',cross,'.mat');
    fprintf('Loading test images/labels file %s for cross validation %s and channel %s \n',file,cross,channels{tst_images})
    load(file,var_test_labels{tst_images},var_test_images{tst_images});
    fprintf('Images and labels loaded for channel %s \n', channels{tst_images})
    %building test image matrix combining all channels and their associated
    %labels
    test_image_matrix = cat(3,test_image_matrix,eval(var_test_images{tst_images}));
    test_class_labels = vertcat(test_class_labels,eval(var_test_labels{tst_images}));
end


for trn_images = 1:xchnl%loading train images .mat files with specific variables by channel
    
    file = strcat(file_path,'Images_train_cross_validation_',cross,'.mat');
    fprintf('Loading train images/labels file %s for cross validation %s and channel %s \n',file,cross,channels{trn_images})
    load(file,var_train_labels{trn_images},var_train_images{trn_images});
    fprintf('Images and labels loaded for channel %s \n', channels{trn_images})
    %building train image matrix combining all channels and their associated
    %labels
    train_image_matrix = cat(3,train_image_matrix,eval(var_train_images{trn_images}));
    train_class_labels = vertcat(train_class_labels,eval(var_train_labels{trn_images}));
end
%% Cropping images to display from 0 seconds to -250 seconds
% Removing the first 102 pixels of the image
fprintf('Cropping image to 0 sec to -250 sec time slice\n')
train_image_matrix(:,1 : 102,:) = [];
test_image_matrix(:,1 : 102,:) = [];
