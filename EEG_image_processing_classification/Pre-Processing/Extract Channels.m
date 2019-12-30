Channel_idx_train_O1 = (5:8:length(train_image_matrix(1,1,:)));
Channel_idx_test_O1 = (5:8:length(test_image_matrix(1,1,:)));
Channel_idx_train_class_labels_O1 = (5:8:length(train_class_labels(:)));
Channel_idx_test_class_labels_O1 = (5:8:length(test_class_labels(:)));

Channel_idx_train_O2 = (6:8:length(train_image_matrix(1,1,:)));
Channel_idx_test_O2 = (6:8:length(test_image_matrix(1,1,:)));
Channel_idx_train_class_labels_O2 = (6:8:length(train_class_labels(:)));
Channel_idx_test_class_labels_O2 = (6:8:length(test_class_labels(:)));

test_O1_image_matrix = [];
for i = 1:length(Channel_idx_test_O1(:))
    test_O1_image_matrix = cat(3,test_O1_image_matrix, test_image_matrix(:,:,Channel_idx_test_O1(i))); 
end
test_O2_image_matrix = [];
for i = 1:length(Channel_idx_test_O2(:))
    test_O2_image_matrix = cat(3,test_O2_image_matrix, test_image_matrix(:,:,Channel_idx_test_O2(i))); 
end

test_O1_class_labels = [];
for z = 1:length(Channel_idx_test_class_labels_O1)
    test_O1_class_labels = vertcat(test_O1_class_labels,test_class_labels(Channel_idx_test_class_labels_O1(z)));
end

test_O2_class_labels = [];
for z = 1:length(Channel_idx_test_class_labels_O2)
    test_O2_class_labels = vertcat(test_O2_class_labels,test_class_labels(Channel_idx_test_class_labels_O2(z)));
end



Train block
train_O1_image_matrix = zeros(581,615,length(Channel_idx_train_O1(:)));
train_count = length(Channel_idx_train_O1(:));

for i = 1:train_count
    %train_O1_image_matrix = cat(3,train_O1_image_matrix, train_image_matrix(:,:,Channel_idx_train_O1(i))); 
    train_O1_image_matrix(:,:,i) = train_image_matrix(:,:,Channel_idx_train_O1(i));
end

train_O2_image_matrix = zeros(581,615,length(Channel_idx_train_O1(:)));
for i = 1:train_count
    train_O2_image_matrix = cat(3,train_O2_image_matrix, train_image_matrix(:,:,Channel_idx_train_O2(i))); 
end

train_label_count = length(Channel_idx_train_class_labels_O1);
train_O1_class_labels = [];
for z = 1:train_label_count
    train_O1_class_labels = vertcat(train_O1_class_labels,train_class_labels(Channel_idx_train_class_labels_O1(z)));
end

train_O2_class_labels = [];
for z = 1:train_label_count
    train_O2_class_labels = vertcat(train_O2_class_labels,train_class_labels(Channel_idx_train_class_labels_O2(z)));
end

