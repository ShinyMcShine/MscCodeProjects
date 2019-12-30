%function [test_class_labels, train_class_labels, test_image_matrix, train_image_matrix] = Equal_Sampling (channels,file_path)
file_path = 'E:\KDD\2nd Semester\Dissertation\Datasets\EEG_Spectrogram_CrossVal\';
channels = {'O1','O2'}; %what channels will be used for feature vectors
xchnl = length(channels); %setting the number of channels to extract

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
%% Perform Equal Size Sampling of T=0 and T=1 images
T1 = sum(train_class_labels(:) == 1);
T0 = sum(train_class_labels(:) == -1);

Diff = abs(T1-T0);

if T1 < T0
    [I] = train_class_labels(:) == -1; %pull index locations to remove T=0 labels and images
    
else
    [I] = train_class_labels(:) == 1; %pull index locations to remove T=1 labels and images
end
x = 1;
%test_matrix = train_image_matrix;
%test_labels = train_class_labels;
while Diff > 0
    if I(x) == 1
        train_image_matrix(:,:,x) = [];
        train_class_labels(x) = [];
        Diff = Diff -1;
        I(x) = [];
       % x = x+1;
    else
        x = x+1;
        
    end
end

T1 = sum(test_class_labels(:) == 1);
T0 = sum(test_class_labels(:) == -1);

Diff = abs(T1-T0);

if T1 < T0
    [I] = test_class_labels(:) == -1;
    
else
    [I] = test_class_labels(:) == 1;
end
x = 1;
%test_matrix = test_image_matrix;
%test_labels = test_class_labels;
while Diff > 0
    if I(x) == 1
        test_image_matrix(:,:,x) = [];
        test_class_labels(x) = [];
        Diff = Diff -1;
        I(x) = [];
       % x = x+1;
    else
        x = x+1;
        
    end
end
save('Cross_Val_Equal_Sample','test_class_labels','train_class_labels'...
    ,'train_image_matrix','test_image_matrix','-v7.3')
