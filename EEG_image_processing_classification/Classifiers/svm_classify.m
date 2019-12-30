%function predicted_categories = svm_classify(lambda,train_image_matrix,test_image_matrix,train_class_labels)
%function [predicted_categories, test_class_labels] = svm_classify(lambda,channels,xval,file_path)
function [predicted_categories, test_class_labels] = svm_classify(lambda,xval,train_feat_vectors,test_feat_vectors,train_class_labels,test_class_labels)
cross_val = xval;
for cross_val = 1:xval
    fileID = fopen(strcat('svm prediction for cross validation_',string(cross_val),'_and lambda_',string(lambda),'.txt'),'w');
    
    %% Calling function to extract, load, build test/train images and labels for cross validation structure I created and perofrm Equal Sampling
    %[test_class_labels, train_class_labels, test_image_matrix, train_image_matrix] = load_train_test_cross_validation (channels,cross_val,file_path);
    %[test_class_labels, train_class_labels, test_image_matrix, train_image_matrix] = Equal_Sampling (channels,cross_val,file_path);
    %fprintf(fileID,'train/test labels and image matrices have been created\n');
    %% Calculate the Eigenvectors and values based from image matrices
    %fprintf(fileID,'Calculating Eigenvectors and values for features from images.\n');
    %[train_feat_vectors, test_feat_vectors] = Eigen_Vectors (test_image_matrix,train_image_matrix,cross_val,test_class_labels, train_class_labels);
    %fprintf(fileID,'Eigenvectors and values features collected.\n');
    %% Preparing feature vector and categories for SVM
    categories = unique(train_class_labels); %Pull the class labels for each category
    num_categories = length(categories); %suming the total number of categories
    %lambda = 0.001;
    %% Buld feature vector if it does not exist
    if exist ('train_feat_vectors', 'var') == 0 && exist ('test_feat_vectors', 'var') == 0
        train_feat_vectors = [];
        test_feat_vectors = [];
        
        
        %A for loop that was used load each train file from my
        %cross_validation sturcture
        % for i = 1:length(train_filenames)
        %     filename = strcat(data_path,train_filenames{i});
        %     load (filename)
        
        %Create feature vector of train images by column
        feat_vectors = []; %empty list for train feature vector creation
        for xchnl = 1:length(train_image_matrix(1,1,:))
            X = reshape(train_image_matrix(:,:,xchnl), [], 1); %flatten matrix to into a column vector
            feat_vectors (:,xchnl) = X; %add the column vector to feature vector matrix
        end
        train_feat_vectors = [train_feat_vectors  feat_vectors]; %add feature vector to train feature vector
        fprintf(fileID,'Train feature vectors created\n');
        % end
        
        %A for loop that was used load each test file from my
        %cross_validation sturcture
        % for i = 1:length(test_filenames)
        %     filename = strcat(data_path,test_filenames{i});
        %     load (filename)
        
        % Create feature vector of train images by column
        feat_vectors = []; %empty list for test feature vector creation
        for xchnl = 1:length(test_image_matrix(1,1,:))
            Y = reshape(test_image_matrix(:,:,xchnl), [], 1); %flatten matrix to into a column vector
            feat_vectors (:,xchnl) = Y; %add the column vector to feature vector matrix
        end
        test_feat_vectors = [test_feat_vectors  feat_vectors]; %add feature vector to test feature vector
        % end
        fprintf(fileID,'Test feature vectors created\n');
    end
    %% Prepare variables for smv classifer Sections were commented out for various tests with Eigenvalues
    X = train_feat_vectors((1:3),:); %Set first 3 feature vectors to X for svm model
    %X = train_feat_vectors; %Set feature vectors to X for svm model
    svm_w = zeros(length(test_feat_vectors((1:3),1)),num_categories); %preallocate size of svm PC
    %svm_w = zeros(length(test_feat_vectors(:,1)),num_categories);
    
    %%preallocate size of svm PC
    svm_b = zeros(1,num_categories); %pre-allocate size for bias values
    %predicted_categories = zeros(length(test_feat_vectors(1,:)),xval);
    predicted_categories = [];
    
    %transpose matrix per vl_smtrain reads by column instead of row
    fprintf(fileID, 'Running smv classifier with lambda %u\n', lambda);
    y = double(train_class_labels'); %assign labels to y for svmtrain function to produce weights and bias values
    [w b] = vl_svmtrain(X, y , lambda); %produce weights and bias from training images
    svm_w(:,1) = []; %removes the first column
    svm_w = [svm_w, w]; %concat the weights to the svm_w matrix
    svm_b(:,1) = []; %remove the first colum
    svm_b = [svm_b, b]; %concat the bias to svm_b vector
    
    
    fprintf(fileID, 'Calculating scores\n');
    %scores_mat = svm_w' * test_feat_vectors + svm_b' ;
    scores_mat = svm_w' * test_feat_vectors((1:3),:) + svm_b' ; %calulate scores based on top 3 PC
    
    [MaxScore idx] = max(scores_mat,[],1);
    %end
    fprintf(fileID, 'Building predicted categories\n');
    for i = 1:length(MaxScore(1,:))
        predicted_categories = [predicted_categories; categories(idx(i))];
    end
    fprintf(fileID, 'Saving predicted categories and test labels\n');
    %predicted_categories = vertcat(predicted_categories, var_predicted_categories);
    %predicted_categories = predicted_categories';
    filename = strcat('Predicted_Categories_crossValidation_',string(cross_val),'_and_lambda_',string(lambda),'_.mat');
    
    save(filename,'predicted_categories','test_class_labels')
    fprintf(fileID, 'Variables saved\n');
end
%predicted_categories = predicted_categories';


