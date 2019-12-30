%Author: Daniel Campoy
%12/05/2019
%Preprocess EEG data from EDF+ format containing annotations
%% These steps were used for Preprocessing data, VLFeat SVM, and PCA 
%% Hyper Param with MATLAB SVM was done throuugh SVM_andHYPERParam.m
%% Step 0 Define data location and extract files and their filenames
%Data location
%data_path = 'U:/KDD/2nd Semester/Dissertation/example dataset/RSVP Aeroplane/';
%categories = {'10Hz', '5Hz', '6Hz'};
data_path = 'U:\KDD\2nd Semester\Dissertation\example dataset\RSVP Aeroplane\';
categories = {'5Hz'};
[EEGfiles, EEGfile_names] = get_EEG_data(data_path, categories);
%% Step 1 Preprocess EDF data and define their trials within for all 
prestim = 1;
poststim = 1.5;
[mat_file_list] = EDF_preprocess_definetrials (EEGfiles,EEGfile_names,prestim,poststim);
save('Trials File List', 'mat_file_list')
%% Step 2 extract EEG Spectrogram image for each experiment
data_path = 'U:\KDD\2nd Semester\Dissertation\Datasets\Aeroplane_RSVP\EEG_1s_to_1point5sec_stimuli\';
stim = 'target';
load ('EEG_Trial_Files.mat')

%For Spectrograms of 5Hz to create spectrograms for the mean of all Trials
%time_freq_EEG_AllTrials_spectrogram_5Hz(mat_file_list,stim, data_path)

%Create spectrograms of 5Hz subjects for each trial
time_freq_EEG_spectrogram(mat_file_list,stim, data_path) %For Spectrogram of 5Hz only Subjects
%% Step 3 prepare cross validation files for classifier
data_path = 'E:\KDD\2nd Semester\Dissertation\Datasets\EEG_Spectrogram\Triggers minus 50ms to 250ms\Based on new baseline function All Trials T1 and random 50 of T0\5Hz\';
subjt_categories = {'02a','02b','03a','03b','04a','04b','06a','06b','08a','08b','09a','09b','10a','10b','11a','11b','12a','12b','13a','13b','14a','14b'};
%get_EEG_Spec_data(data_path,subjt_categories,triggers) 
[cross_val] = cross_validation (data_path, subjt_categories);
save ('Cross_Validation_Files.mat', 'cross_val')
%% Step 4 Generate images and and class lables for a cross validation test
% and train set
%load('Cross Validation Files.mat')
load('Cross_Validation_Files_5Hz.mat')
data_path = 'E:\KDD\2nd Semester\Dissertation\Datasets\EEG_Spectrogram\Triggers minus 50ms to 250ms\Based on new baseline function All Trials T1 and random 50 of T0\5Hz\';
k=1;
create_cross_validation_images (cross_val, k, data_path);
%% Step 5 Supply test/train lables and image matrix to VLFeat SVM classifier
%channels is a cell-array
%image_path = 'U:\KDD\2nd Semester\Dissertation\FieldTrip\fieldtrip-20190419\fieldtrip-20190419\FT_Scripts\Pre-Processing';
%lambda = single([0.1,0.01,0.001,0.0001,0.00001,0.000001]);
addpath 'U:\KDD\2nd Semester\Dissertation\vl_feat\toolbox\' %adding VLFeat Toolbox
vl_setup
lambda = 0.01;
file_path = 'E:\KDD\2nd Semester\Dissertation\Datasets\EEG_Spectrogram_CrossVal\';
channels = {'O1','O2'}; %what channels will be used for feature vectors
xval = 1; %number of cross validations to perform
%[predicted_categories, test_class_labels] = svm_classify(lambda,channels,xval,file_path);
[predicted_categories, test_class_labels] = svm_classify(lambda,xval,train_feat_vectors,test_feat_vectors,train_class_labels,test_class_labels);%This was to test top 3 weights of Eigenvalues
%% Extract all test and train images from cross validation structure to calculate Eigenvectors and values for PCA
%file_path = '/gpfs/home/tbr18exu/Dataset/Cross_Val/'; %path from HPC
file_path = 'E:\KDD\2nd Semester\Dissertation\Datasets\EEG_Spectrogram_CrossVal\';
channels = {'O1','O2'}; %what channels will be used for feature vectors
cross_val = 'all';
[test_class_labels, train_class_labels, test_image_matrix, train_image_matrix] = load_all_train_test_cross_validation (channels,file_path);

Eigen_Vectors (test_image_matrix,train_image_matrix,cross_val,test_class_labels, train_class_labels)
%% Hyperparameter Optimisation of SVM test with PC Eigenvalues from PCA for Each Channel for All Subjects
channel ='O1'; %Choose and given channel extracted
AllSubChannelEigenValues (channel)
%% Hyperparameter Optimisation of SVM test with PC Eigenvalues from PCA for Combing Channel O1 and O2 then take the mean for All Subjects
AllSubChannelMeanEigenValues
%% Hyperparameter Optimisation of SVM test with PC Eigenvalues from PCA Combined of O1 and O2 Channel take the mean for All Subjects
All_Subject_Exp_Load_Images
%% Hyperparameter Optimisation of SVM test with PC Eigenvalues from PCA combined Channels for each LFV and RFV
BuildImages_LFV_RFV_PerSubj
%% Hyperparameter Optimisation of SVM test with PC Eigenvalues from PCA for each channel and each subject
ChannelEigenValues (channel)
%% Hyperparameter Optimisation of SVM test with PC Eigenvalues from PCA for  mean channel of O1 or O2 and each subject
ChannelMeanEigenValues