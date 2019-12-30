%% ROC Curve for all Subject models
AccList = struct('Subject',{'All'},...
    'CVAcc',[],'KernelScale',[],'BoxConstraint',[],'PredLabels',[],'PredScores',[]);
Subject = {'02','03','04','06','08','09','10','11','12','13','14'};
path = 'U:\KDD\2nd Semester\Dissertation\Datasets\Eigen_Features\PerSubj_RandomImages_99var\ES\';
%EV = [];
class = [];
for i = 1:11
    file = strcat(path,'Eigen Features_Sub',Subject{i},'_Rand_ES','.mat');
    fprintf('Loading file.....\n%s\n',file)
    load(file);
 %   Eigenvalues = Eigenvalues(1:20,:);
 %   EV = [EV Eigenvalues];
    class = vertcat(class,Labels);
end
TrainedScores = AccList.PredScores(:,2);

[X,Y] = perfcurve(class,Scores,1);
plot(X,Y)
xlabel('False positive rate')
ylabel('True positive rate')
title('ROC for Classification by SVM RBF')