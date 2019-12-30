function Eigen_Vectors (test_image_matrix,train_image_matrix,cross_val,test_class_labels, train_class_labels, var)
%% Flatten test and train images as vector M*N x 1 vector
%train_image_matrix = double(train_image_matrix);
%test_image_matrix = double(test_image_matrix);
Labels = vertcat(train_class_labels, test_class_labels);
% Train images
flat_train_image_matrix = reshape(train_image_matrix,(length(train_image_matrix(:,1,1)) * length(train_image_matrix(1,:,1))),length(train_image_matrix(1,1,:)));
%flat_train_image_matrix = double(flat_train_image_matrix); %covert to double for mean calculation
% Test images
flat_test_image_matrix = reshape(test_image_matrix,(length(test_image_matrix(:,1,1)) * length(test_image_matrix(1,:,1))),length(test_image_matrix(1,1,:)));
%flat_test_image_matrix = double(flat_test_image_matrix); %covert to double for mean calculation

Img_Matrix = [flat_train_image_matrix flat_test_image_matrix];
%% Calculate the average vector of all images
Meancntr_eeg_spectro = mean(Img_Matrix,2);
%% find the mean spectrogram subtracting each image vector by the average vector
%building an column array covariance matrix of mean spectrograms (N^2 x M matrix)
A = Img_Matrix - Meancntr_eeg_spectro;
%% Compute covariant matrix

cov_matrix = A' * A;
%produce the eigenvectors and diagnoal eigenvalues through eig function
[V,d] = eig(cov_matrix);
%% Compute eigenvalues based on centered spectrogram (Phi)
% Train images
U = A * V;
%extract the index of D from the diagonal matrix from largest to smallest
[~, I] = sort(diag(d),'descend');
U = U(:,I); %sort eigenvalues from largest to smallest 
%normalise the matrix as the values were as large as e+8 using min-max normlisation
U = U./sqrt(sum(U.^2)); %normalising the matrix from range 0-1
PCs = U' * A; %calculate the weights using mean spectrogram and eigenvalues.
variance = sort(diag(d)/sum(d(:)),'descend'); %calculating the variance
%% Find the number of weights needed to explain variane based on variable
threshold = var;
% % Train images
thr = 0;
t = 1;
while thr < threshold
    thr = sum(variance(1 : t));
    t= t+1;    
end
num_eignval = t;
%% Extract an n number of weight values based on num_wghts since both the training and test features need to have the same size
% this will be the new representation of feature vector
Eigenvalues = PCs(1:num_eignval,:);
%% Save variables to .mat
filename = strcat('Eigen Features_',string(cross_val)); % Used if using LFV and RFV tests
save(filename,'Eigenvalues','Labels','num_eignval','variance')