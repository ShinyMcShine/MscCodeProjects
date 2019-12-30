X = test_crossval_image_matrix_O1(:,:,1:50);
Y = test_crossval_image_matrix_O1(:,:,90:139);

Z = cat(3,X,Y);
figure('Name','Avg across one subject at T=1')

subplot(2,4,1)
A = sum(Z,3)./length(Z(1,1,:));
ft_plot_matrix(A);

title('O1 Avg Across T=-1')
X = test_crossval_image_matrix_O1(:,:,51:89);
Y = test_crossval_image_matrix_O1(:,:,140:176);

Z = cat(3,X,Y);

%B = sum(test_crossval_image_matrix_O2,3)./length(test_crossval_image_matrix_O2(1,1,:));
B = sum(Z,3)./length(Z(1,1,:));
subplot(2,4,2)
ft_plot_matrix(B);
title('O1 Avg Across T=1')

X = test_crossval_image_matrix_O2(:,:,1:50);
Y = test_crossval_image_matrix_O2(:,:,90:139);
Z = cat(3,X,Y);
%C = sum(P8_T1_image_matrix,3)./length(P8_T1_image_matrix(1,1,:));
C = sum(Z,3)./length(Z(1,1,:));
subplot(2,4,3)
ft_plot_matrix(C);
title('O2 Avg Across T=-1')

X = test_crossval_image_matrix_O2(:,:,51:89);
Y = test_crossval_image_matrix_O2(:,:,140:176);

Z = cat(3,X,Y);
%D = sum(P7_T1_image_matrix,3)./length(P7_T1_image_matrix(1,1,:));
D = sum(Z,3)./length(Z(1,1,:));
subplot(2,4,4)
ft_plot_matrix(D);
title('O2 Avg Across  T=1')






E = sum(O1_T1_image_matrix,3)./length(O1_T1_image_matrix(1,1,:));
subplot(2,4,5)
ft_plot_matrix(E);
title('O1 Avg Across all Subjects T=1')

F = sum(O2_T1_image_matrix,3)./length(O2_T1_image_matrix(1,1,:));
subplot(2,4,6)
ft_plot_matrix(F);
title('O2 Avg Across all Subjects T=1')

G = sum(PO3_T1_image_matrix,3)./length(PO3_T1_image_matrix(1,1,:));
subplot(2,4,7)
ft_plot_matrix(G);
title('PO3 Avg Across all Subjects T=1')

H = sum(PO4_T1_image_matrix,3)./length(PO4_T1_image_matrix(1,1,:));
subplot(2,4,8)
ft_plot_matrix(H);
title('PO4 Avg Across all Subjects T=1')

  

figure('Name','Avg across all subjects at T=0')

subplot(2,4,1)
I = sum(PO8_T0_image_matrix,3)./length(PO8_T0_image_matrix(1,1,:));
ft_plot_matrix(I);
title('PO8 Avg Across All Subjects T=0')

J = sum(PO7_T0_image_matrix,3)./length(PO7_T0_image_matrix(1,1,:));
subplot(2,4,2)
ft_plot_matrix(J);
title('PO7 Avg Across all Subjects T=0')

K = sum(P8_T0_image_matrix,3)./length(P8_T0_image_matrix(1,1,:));
subplot(2,4,3)
ft_plot_matrix(K);
title('P8 Avg Across all Subjects T=0')

L = sum(P7_T0_image_matrix,3)./length(P7_T0_image_matrix(1,1,:));
subplot(2,4,4)
ft_plot_matrix(L);
title('P7 Avg Across all Subjects T=0')

M = sum(O1_T0_image_matrix,3)./length(O1_T0_image_matrix(1,1,:));
subplot(2,4,5)
ft_plot_matrix(M);
title('O1 Avg Across all Subjects T=0')

N = sum(O2_T0_image_matrix,3)./length(O2_T0_image_matrix(1,1,:));
subplot(2,4,6)
ft_plot_matrix(N)
title('O2 Avg Across all Subjects T=0')

O = sum(PO3_T0_image_matrix,3)./length(PO3_T0_image_matrix(1,1,:));
subplot(2,4,7)
ft_plot_matrix(O);
title('PO3 Avg Across all Subjects T=0')

P = sum(PO4_T0_image_matrix,3)./length(PO4_T0_image_matrix(1,1,:));
subplot(2,4,8)
ft_plot_matrix(P);
title('PO4 Avg Across all Subjects T=0')


% size = length(PO4_T0_image_matrix(1,1,:);
% row = length(PO4_T0_image_matrix(:,1,1);
% for x = 1:sum
%     for y = 1:length(PO4_T0_image_matrix
%     end
% 
% figure
% imshow(PO4_T0_image_matrix(:,:,3));
% 
% figure
% D = sum(P7_T1_image_matrix,3)./length(P7_T1_image_matrix(1,1,:));
% subplot(2,4,4)
% 
% ft_plot_matrix(D)
% xlim([-50 250])
% title('P7 Avg Across all Subjects')