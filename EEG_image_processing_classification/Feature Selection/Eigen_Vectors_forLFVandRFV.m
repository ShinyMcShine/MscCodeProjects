function Eigen_Vectors_forLFVandRFV (test_image_matrix,cross_val,test_class_labels,var)
%% Flatten test and train images as vector M*N x 1 vector
%Coverting to Double
test_image_matrix = double(test_image_matrix);

% Test images
flat_test_image_matrix = reshape(test_image_matrix,(length(test_image_matrix(:,1,1)) * length(test_image_matrix(1,:,1))),length(test_image_matrix(1,1,:)));
flat_test_image_matrix = double(flat_test_image_matrix); %covert to double for mean calculation
num_tst_images = length(test_image_matrix(1,1,:));

%% Calculate the average vector of all images
% Test images
cntr_tst_eeg_spectro = zeros(length(flat_test_image_matrix(:,1)),1);
for cntr = 1:num_tst_images
    cntr_tst_eeg_spectro = flat_test_image_matrix(:,cntr) + cntr_tst_eeg_spectro;
end
cntr_tst_eeg_spectro = cntr_tst_eeg_spectro ./ num_tst_images;
%% find the mean spectrogram subtracting each image vector by the average vector
%building an column array covariance matrix of mean spectrograms (N^2 x M matrix)
% Test images
B = zeros(length(cntr_tst_eeg_spectro),length(test_image_matrix(1,1,:)));

for i = 1:num_tst_images
   B(:,i) = flat_test_image_matrix(:,i) - cntr_tst_eeg_spectro;
end
%% Compute covariant matrix
% Test images
cov_tst_matrix = B' * B;
%produce the eigenvectors and diagnoal eigenvalues through eig function
[W,e] = eig(cov_tst_matrix);
%% Compute eigenvalues based on centered spectrogram (Phi)
% Test images
Y = B * W;
%extract the index of D from the diagonal matrix from largest to smallest
[~, II] = sort(diag(e),'descend');
Y = Y(:,II); %sort eigenvalues from largest to smallest eigenvalues
%normalise the matrix as the values were as large as e+8 using min-max normlisation
Y = Y./sqrt(sum(Y.^2)); %normalising the matrix from range 0-1
Weights_tst = Y' * B; %calculate the weights using mean spectrogram and eigenvalues.
variance_tst = sort(diag(e)/sum(e(:)),'descend'); %calculating the variance
%% Find the number of weights needed to explain variane based on variable
threshold = var;
% Train images
% thr = 0;
% t = 1;
% while thr < 0.99
%     thr = sum(variance(1 : t));
%     t= t+1;    
% end
% num_wghts = t;
%num_wghts = 10; %This is for testing per subject to pick the 10 largest weights
% Test images
thr = 0;
t = 1;
while thr < threshold
    thr = sum(variance_tst(1 : t));
    t= t+1;    
end
num_wghts_tst = t;
%% Extract an n number of weight values based on num_wghts
% this will be the new representation of feature vector

test_feat_vectors = Weights_tst(1:num_wghts_tst,:);
%filename = strcat('Eigen Features_',string(cross_val)); Used if using
%cross validation structure created
filename = strcat('Eigen Features_LFV_RFV_',cross_val); % Used if using LFV and RFV tests
save(filename,'test_feat_vectors','test_class_labels','variance_tst')