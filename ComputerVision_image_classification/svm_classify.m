% Based on James Hays, Brown University

%This function will train a linear SVM for every category (i.e. one vs all)
%and then use the learned linear classifiers to predict the category of
%every test image. Every test feature will be evaluated with all 15 SVMs
%and the most confident SVM will "win". Confidence, or distance from the
%margin, is W*X + B where '*' is the inner product or dot product and W and
%B are the learned hyperplane parameters.

function predicted_categories = svm_classify(train_image_feats, train_labels, test_image_feats)

%unique() is used to get the category list from the observed training
%category list. 'categories' will not be in the same order as in coursework_starter,
%because unique() sorts them. This shouldn't really matter, though.

categories = unique(train_labels); %creating  ground truth labels for each category
num_categories = length(categories); %suming the total number of categories
lambda = 0.00001;

X = train_image_feats'; %transpose matrix as vl_svmtrain reads by column instead of row
svm_w = zeros(length(test_image_feats(1,:)),num_categories);
svm_b = zeros(1,num_categories);
predicted_categories = [];
%create a SVM model for each category and store them into SVMmodels
for j = 1:num_categories
    catgry_match = strcmp(train_labels, categories(j));
    catgry_match = double(catgry_match); %convert to double required for vl_smtrain
    
    n =1;
    while n <= length(catgry_match)
        if catgry_match(n) == 0
            catgry_match(n) = catgry_match(n) + (-1);
        end
        n=n+1;
    end   
    y = catgry_match'; %transpose matrix per vl_smtrain reads by column instead of row    
    [w b] = vl_svmtrain(X, y , lambda);
    svm_w(:,1) = [];
    svm_w = [svm_w, w];
    svm_b(:,1) = [];
    svm_b = [svm_b, b];
    %[W B] = vl_svmtrain(train_image_feats, catgry_match, lambda);
    %SVMmodels{j} = fitcsvm(train_image_feats,catgry_match,'ClassNames',[false true],'Standardize',...
    %    true, 'KernelFunction','rbf','BoxConstraint',1);% Create a SVM for each class label
end
%creating binary labels for ground truths
%ground_truth = zeros(1,15);

%for i = 1:size(svm_w( 1,:)) %loop through svm results from each image
    
scores_mat = svm_w' * test_image_feats' + svm_b' ; 
   %Scores(:,i) = scores(:,2); % Second column contains positive-class scores
[MaxScore idx] = max(scores_mat,[],1);    
%end

for i = 1:length(MaxScore(1,:))
    predicted_categories = [predicted_categories categories(idx(i))];
end

predicted_categories = predicted_categories';

% image_feats is an N x d matrix, where d is the dimensionality of the
%  feature representation.
% train_labels is an N x 1 cell array, where each entry is a string
%  indicating the ground truth category for each training image.
% test_image_feats is an M x d matrix, where d is the dimensionality of the
%  feature representation. You can assume M = N unless you've modified the
%  starter code.
% predicted_categories is an M x 1 cell array, where each entry is a string
%  indicating the predicted category for each test image.

%{
Useful functions:
 matching_indices = strcmp(string, cell_array_of_strings)
 
  This can tell you which indices in train_labels match a particular
  category. This is useful for creating the binary labels for each SVM
  training task.

[W B] = vl_svmtrain(features, labels, LAMBDA)
  http://www.vlfeat.org/matlab/vl_svmtrain.html

  This function trains linear svms based on training examples, binary
  labels (-1 or 1), and LAMBDA which regularizes the linear classifier
  by encouraging W to be of small magnitude. LAMBDA is a very important
  parameter! You might need to experiment with a wide range of values for
  LAMBDA, e.g. 0.00001, 0.0001, 0.001, 0.01, 0.1, 1, 10.

  Matlab has a built in SVM, see 'help svmtrain', which is more general,
  but it obfuscates the learned SVM parameters in the case of the linear
  model. This makes it hard to compute "confidences" which are needed for
  one-vs-all classification.

%}

