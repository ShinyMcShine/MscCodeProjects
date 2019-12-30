file_path = 'U:\KDD\2nd Semester\Dissertation\Datasets\EEG_Spectrogram\LFVandRFV_PerSub_5Hz\';
channels = {'O1','O2'}; %what channels will be used for feature vectors
%cross = "11"; %specify which test cross validation files you want to load
subjt_categories = {'02a','02b','03a','03b','04a','04b','06a','06b','08a','08b','09a','09b','10a','10b','11a','11b','12a','12b','13a','13b','14a','14b'};
num_subj = length(subjt_categories);
var = 0.99; %set threshold for Eigenvalues variance

class_filename = '_class_labels';
%class_filename = '_class_labels';
xchnl = length(channels);

for i = 1:num_subj
    var_test_labels = cell(xchnl,1);
    var_test_images = cell(xchnl,1);
    test_class_labels = [];
    test_image_matrix = [];

    path = strcat(file_path,subjt_categories{i});
    image_files_dir = dir( fullfile(strcat(file_path,subjt_categories{i}), '*.mat'));
    image_file_names = extractfield(image_files_dir,'name');
    image_file_names = string(image_file_names');
    num_files = length(image_file_names);    
    %% Adding file and image matrices variables
    for q = 1:num_files
        if contains(image_file_names(q), 'T1') == 1
            for z = 1:xchnl %building test file names for loading variables
                test_label_filename = 'T1_test_';
                test_image_filename = 'T1_test_crossval_image_matrix_';
                var_test_images{z,1} = strcat(test_image_filename,channels{z});
                var_test_labels{z,1} = strcat(test_label_filename,channels{z},class_filename);
            end            
        else
            for z = 1:xchnl %building test file names for loading variables
                test_label_filename = 'T0_test_';
                test_image_filename = 'T0_test_crossval_image_matrix_';
                var_test_images{z,1} = strcat(test_image_filename,channels{z});
                var_test_labels{z,1} = strcat(test_label_filename,channels{z},class_filename);
            end            
        end
        %%
        file = strcat(file_path,subjt_categories{i},'\',image_file_names(q));
        for tst_images = 1:xchnl%loading test images .mat files with specific variables by channel            
            fprintf('Loading test images/labels file %s and channel %s \n',image_file_names(q),channels{tst_images})
            load(file,var_test_labels{tst_images},var_test_images{tst_images});
            fprintf('Images and labels loaded for channel %s \n', channels{tst_images})
            %building test image matrix combining all channels and their associated
            %labels
            test_image_matrix = cat(3,test_image_matrix,eval(var_test_images{tst_images}));
            test_class_labels = vertcat(test_class_labels,eval(var_test_labels{tst_images}));
        end
    end
    test_image_matrix(:,1 : 102,:) = []; %Crop image keeping time range 0 to -250ms
    cross_val = subjt_categories{i}; %specifiy what Subject Number for saved filename
    Eigen_Vectors_forLFVandRFV (test_image_matrix,cross_val,test_class_labels,var)
end

