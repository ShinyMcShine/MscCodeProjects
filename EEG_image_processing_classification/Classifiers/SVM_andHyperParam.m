%% Perform Hyperparam for each Subject Top Eigenvalue
% Set the channel you would like to load Eigenvalues from and it will go
% through each test subject from RSVP dataset and perform SVM classifcation
% with 10 cross validation of model
AccList = struct('Subject',{'2','3','4','6','8','9','10','11','12','13','14'},...
    'CVAcc',[],'KernelScale',[],'BoxConstraint',[],'PredLabels',[],'PredScores',[],'PC',[]);
channel ='O1O2'; %specify which channel to train the SVM fromm and for saving the .mat under this channel 
PC=9; %Can you chase which PC value you want
%Training Each Subject and Channel 
%path = 'U:\KDD\2nd Semester\Dissertation\Datasets\Eigen_Features\PerSubj_RandomImages_99var\ES\Per Channel\';
%Training Each Subjects and Channel mean
path = 'U:\KDD\2nd Semester\Dissertation\Datasets\Eigen_Features\PerSubj_RandomImages_99var\ES\MeanChannels\';

for i = 1:11
    file = strcat(path,'Eigen Features_Sub',AccList(i).Subject,'_',channel,'.mat');
    fprintf('Loading file.....\n%s\n',file)
    load(file);
    num = length(Eigenvalues(1,:));
    SVMModel = fitcsvm(Eigenvalues(1:PC,:)',Labels,...
        'KernelFunction','rbf','OptimizeHyperparameters','auto');
    SV = SVMModel.SupportVectors;
    CVSVMModel = crossval(SVMModel);
    [Lab,Sc] = kfoldPredict(CVSVMModel);
    Acc = sum(Lab == Labels)/num;
    
    AccList(i).CVAcc = Acc;
    AccList(i).KernelScale =  SVMModel.KernelParameters.Scale;
    AccList(i).BoxConstraint = SVMModel.BoxConstraints;
    AccList(i).PredLabels= Lab;
    AccList(i).PredScores= Sc;
    AccList(i).PC = PC;
    %Setting up the file name for saving and path
    %modelfolder = strcat('SVM Linear Top',string(PC),'EV');%if I was training Linear kernel
    modelfolder = strcat('SVM RBF Top',string(PC),'EV');%if I was training RBF kernel
    folder = strcat('U:\KDD\2nd Semester\Dissertation\LearnedModels\',modelfolder,'\MeanChannelandSubj\');
    svfile = char(strcat(folder,'TrainedModel_SVM_Sub',AccList(i).Subject,'PC',string(PC),'_',channel));
    save(svfile,'SVMModel','CVSVMModel','SV','Lab','Sc')
end
%Saving accuracy results of each subject
Accfile=char(strcat(folder,'AccuracyResults_EachSub_Channel',channel));
save(Accfile,'AccList')
%% Perform Hyperparam for all Subjects Top Eigenvalue For the first round of presentation combining the images
AccList = struct('Subject',{'AllSub'},...
    'CVAcc',[],'KernelScale',[],'BoxConstraint',[],'PredLabels',[],'PredScores',[]);
Subject = {'02','03','04','06','08','09','10','11','12','13','14'};
PC=9;
channel ='O1O2';
%For Each Channel
%path = 'U:\KDD\2nd Semester\Dissertation\Datasets\Eigen_Features\AllSubj_RandomImages_99var\ES\Per Channel\';
%For Mean Channel
path = 'U:\KDD\2nd Semester\Dissertation\Datasets\Eigen_Features\AllSubj_RandomImages_99var\ES\MeanChannels\';

%For loop was for combining Channels with Eigenvalue calculated per subject
% for i = 1:11
%     file = strcat(path,'Eigen Features_Sub',Subject{i},'_Rand_ES','.mat');
%     fprintf('Loading file.....\n%s\n',file)
%     load(file);
%     Eigenvalues = Eigenvalues(1:20,:);
%     EV = [EV Eigenvalues];
%     class = vertcat(class,Labels);
% end

file = strcat(path,'Eigen Features_AllSub_',channel,'.mat');
fprintf('Loading file.....\n%s\n',file)
load(file);

num = length(Eigenvalues);
%Used to test the holdout method before training 20%
% holdout = uint8(length(Eigenvalues(1,:))/20); %Holdout for validation
% validate = Eigenvalues(:,1:holdout);
% holdoutlabels = uint8(length(Labels(:,1))/20); %Holdout for validation
% validatelabels = Labels(1:holdoutlabels,1);
% holdoutlabels = single(holdoutlabels); %becuase Matlab told me so
% Labels = Labels(holdoutlabels+1 : end,1);
% Eigenvalues(:,1:holdout) = [];

SVMModel = fitcsvm(Eigenvalues(1:PC,:)',Labels,...
    'KernelFunction','rbf','OptimizeHyperparameters','auto');
SV = SVMModel.SupportVectors;
CVSVMModel = crossval(SVMModel);
[Lab,Sc] = kfoldPredict(CVSVMModel);
Acc = sum(Lab == Labels)/num;

AccList.CVAcc = Acc;
AccList.KernelScale =  SVMModel.KernelParameters.Scale;
AccList.BoxConstraint = SVMModel.BoxConstraints;
AccList.PredLabels= Lab;
AccList.PredScores= Sc;

%Setting up the file name for saving and path
%modelfolder = strcat('SVM Linear Top',string(PC),'EV');%if I was training Linear kernel
modelfolder = strcat('SVM RBF Top',string(PC),'EV');%if I was training RBF kernel
%folder = strcat('U:\KDD\2nd Semester\Dissertation\LearnedModels\',modelfolder,'\EachChannelandSubj\');
folder = strcat('U:\KDD\2nd Semester\Dissertation\LearnedModels\',modelfolder,'\MeanChannelandSubj\');
svfile = char(strcat(folder,'TrainedModel_SVM_AllSub','PC',string(PC),'_',channel));
save(svfile,'SVMModel','CVSVMModel','SV','Lab','Sc','holdout','validatelabels')

Accfile=char(strcat(folder,'AccuracyResults_AllSub_Channel',channel));
save(Accfile,'AccList')
%% Test AllSubj Leanred model against each subject
AccList = struct('Subject',{'2','3','4','6','8','9','10','11','12','13','14'}...
   ,'Acc',[]);
PC = 9;
channel = 'O1O2';

%Training Each Subject and Channel
%path = 'U:\KDD\2nd Semester\Dissertation\Datasets\Eigen_Features\PerSubj_RandomImages_99var\ES\Per Channel\';
Training Each Subjects and Channel mean
path = 'U:\KDD\2nd Semester\Dissertation\Datasets\Eigen_Features\PerSubj_RandomImages_99var\ES\MeanChannels\';

for i = 1:11
    file = strcat(path,'Eigen Features_Sub',AccList(i).Subject,'_',channel,'.mat');
    fprintf('Loading file.....\n%s\n',file)
    load(file);
    num = length(Eigenvalues(1,:));
    %Used  for holdout method
%     num = length(validate(1,:));
%     [label, score] =predict(SVMModel,validate(1:PC,:)');
%     Acc = sum(label == validatelabels)/num;
    [label, score] =predict(SVMModel,Eigenvalues(1:PC,:)');    
    Acc = sum(label == Labels)/num;
    AccList(i).Acc = Acc;
end
%Setting up the file name for saving and path
%modelfolder = strcat('SVM Linear Top',string(PC),'EV');%if I was training Linear kernel
modelfolder = strcat('SVM RBF Top',string(PC),'EV');%if I was training RBF kernel
folder = strcat('U:\KDD\2nd Semester\Dissertation\LearnedModels\',modelfolder,'\MeanChannelandSubj\');
%folder = strcat('U:\KDD\2nd Semester\Dissertation\LearnedModels\',modelfolder,'\EachChannelandSubj\');
svfile = char(strcat(folder,'AccuracyValidationResults_AllSub_','PC',string(PC),'_',channel));
    
save(svfile,'AccList','label','score')