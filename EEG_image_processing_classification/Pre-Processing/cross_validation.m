function [cross_val] = cross_validation (data_path, subjt_categories)
%% Build list of image file names to build cross validation lists for each
% subject being left out
image_files_dir = dir( fullfile(data_path, '*.mat'));
image_file_names = extractfield(image_files_dir,'name');
image_file_names = string(image_file_names');
num_cat = length(subjt_categories);
subjt_categories = string(subjt_categories);
%Create cross validation struct to save the files names to each
%test_image_filesX corresponds to the same train_image_filesX
cross_val = struct('test_image_files_1',[] ,'test_image_files_2',[] ,'test_image_files_3',[]...
    ,'test_image_files_4',[],'test_image_files_5',[],'test_image_files_6',[],'test_image_files_7',[]...
    ,'test_image_files_8',[],'test_image_files_9',[],'test_image_files_10',[],'test_image_files_11',[]...
    ,'train_image_files_1',[],'train_image_files_2',[],'train_image_files_3',[],'train_image_files_4',[]...
    ,'train_image_files_5',[],'train_image_files_6',[],'train_image_files_7',[],'train_image_files_8',[]...
    ,'train_image_files_9',[],'train_image_files_10',[],'train_image_files_11',[]);
%test and train fields are used to populate the cross validation structure
test_fields = {'test_image_files_1','test_image_files_2','test_image_files_3'...
    ,'test_image_files_4','test_image_files_5','test_image_files_6','test_image_files_7'...
    ,'test_image_files_8','test_image_files_9','test_image_files_10','test_image_files_11'};

train_fields = {'train_image_files_1','train_image_files_2','train_image_files_3','train_image_files_4'...
    ,'train_image_files_5','train_image_files_6','train_image_files_7','train_image_files_8'...
    ,'train_image_files_9','train_image_files_10','train_image_files_11'};
%% these loops will build a list of test and train .mat files used for
% cross validation, the test images will contain one subject's EEG
% spectrograms while they train images will be all other subjects
n=0; %begin idx for each subject test
test_image_files = []; %create empty list
for i = test_fields %this loop will populate all the test images contain only one subjects EEG spectrograms
    n=n+1; %increment by one
    test_image_files = image_file_names(contains(image_file_names,subjt_categories(n))); %pop the first two elements
    test_image_files = [test_image_files image_file_names(contains(image_file_names,subjt_categories(n+1)))]; %collect first files based on subject test (XXa)
    n=n+1; %increment by one
    cross_val.(char(i)) = test_image_files;
    cross_val.(char(i)) = reshape(cross_val.(char(i)),[],1);
end
left_in_subjt_categories = subjt_categories; %copy list of subjects tests

for i = train_fields
    list = [];
    atest = left_in_subjt_categories(1); %save the frist XXa test
    btest = left_in_subjt_categories(2); %save the first XXb test
    left_in_subjt_categories = left_in_subjt_categories(3:end); %pop the first two elements to remove them from the list
    num_subj = length(left_in_subjt_categories); %set for the number of iterations
    n=0; %begin idx for each subject test
    train_image_files = []; %set empty field
    for d = 1:num_subj %for each element in left_in_subjt_categories we need to populate the list of train files to load
        list = image_file_names(contains(image_file_names,left_in_subjt_categories(d))); %save matching list of subject
        train_image_files = vertcat (train_image_files, list); %vertically add the files names to train images list
    end
    cross_val.(char(i)) = train_image_files; %add the complete list to the desired struct of train images
    left_in_subjt_categories = horzcat(left_in_subjt_categories,atest,btest); %put XXa and XXb removed at the end of the list
end