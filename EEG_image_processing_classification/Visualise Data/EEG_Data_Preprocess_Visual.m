%% Visualise the data for all annotations
figure
EEG_Data.cfg.layout = 'butterfly';
ft_databrowser(EEG_Data.cfg);
%% View each channel for each trial defined.
cfg          = [];
cfg.method   = 'trial';
data_clean   = ft_rejectvisual(cfg, EEG_Data_Trial);

%% Visualise a specifiy annotation
figure
%plot(EEG_Data.time{11}, EEG_Data.trial{11}(1,:));% the : is all of the channels you can specify
plot(EEG_Data_Trial.time{28}, EEG_Data_Trial.trial{28});% the : is all of the channels you can specify
ylabel('Voltage(uV)')
xlabel('Pre/Post Stim (Seconds)')
legend('EEG PO8','EEG PO7','EEG P8','EEG P7','EEG O1','EEG O2','EEG PO3','EEG PO4')
%hold on
%% Loading defined events and extracts only T=1 events
trigger = extractfield(EEG_Data.cfg.event,'value');
            channels = EEG_Data.cfg.channel;
            trigger_idx = find(startsWith(trigger,'T=1'));
            ImgMatrix = zeros(581,615,length(trigger_idx)*8);
            Img_idx = 0;
            cfg.trials       = trigger_idx; %index location for all T=1 stimuli triggers
            EEG_Data_Trial = ft_preprocessing(cfg,EEG_Data);
%% Compare Original T=1 EEG Spectrogram and Cropped Image after removal of outliers
random = randperm(312,312);
crop = ImgMatrix(:,:,random(1:4));
crop(:,1:102,:) = [];
figure
subplot(3,3,1)
ft_plot_matrix(ImgMatrix(:,:,random(1)),'width', 300, 'height', 30, 'hpos', 100);
title('Original Image T=1')
subplot(3,3,2)
ft_plot_matrix(crop(:,:,1),'width', 250, 'height', 30, 'hpos', 122);
title('Cropped Image T=1')
subplot(3,3,3)
ft_plot_matrix(ImgMatrix(:,:,random(2)),'width', 300, 'height', 30, 'hpos', 100);
title('Original Image T=1')
subplot(3,3,4)
ft_plot_matrix(crop(:,:,2),'width', 250, 'height', 30, 'hpos', 122);
title('Cropped Image T=1')
subplot(3,3,5)
ft_plot_matrix(ImgMatrix(:,:,random(3)),'width', 300, 'height', 30, 'hpos', 100);
title('Original Image T=1')
subplot(3,3,6)
ft_plot_matrix(crop(:,:,3),'width', 250, 'height', 30, 'hpos', 122);
title('Cropped Image T=1')
subplot(3,3,7)
ft_plot_matrix(ImgMatrix(:,:,random(4)),'width', 300, 'height', 30, 'hpos', 100);
title('Original Image T=1')
subplot(3,3,8)
ft_plot_matrix(crop(:,:,4),'width', 250, 'height', 30, 'hpos', 122);
title('Cropped Image T=1')

%ft_plot_matrix(crop(:,:,1),'width', 250, 'height', 30, 'hpos', 122);

%% Compare Original T=0 EEG Spectrogram and Cropped Image after removal of outliers
random = randperm(312,312);
crop = ImgMatrix(:,:,random(1:4));
crop(:,1:102,:) = [];
figure
subplot(3,3,1)
ft_plot_matrix(ImgMatrix(:,:,random(1)),'width', 300, 'height', 30, 'hpos', 100);
title('Original Image T=0')
subplot(3,3,2)
ft_plot_matrix(crop(:,:,1),'width', 250, 'height', 30, 'hpos', 122);
title('Cropped Image T=0')
subplot(3,3,3)
ft_plot_matrix(ImgMatrix(:,:,random(2)),'width', 300, 'height', 30, 'hpos', 100);
title('Original Image T=0')
subplot(3,3,4)
ft_plot_matrix(crop(:,:,2),'width', 250, 'height', 30, 'hpos', 122);
title('Cropped Image T=0')
subplot(3,3,5)
ft_plot_matrix(ImgMatrix(:,:,random(3)),'width', 300, 'height', 30, 'hpos', 100);
title('Original Image T=0')
subplot(3,3,6)
ft_plot_matrix(crop(:,:,3),'width', 250, 'height', 30, 'hpos', 122);
title('Cropped Image T=0')
subplot(3,3,7)
ft_plot_matrix(ImgMatrix(:,:,random(4)),'width', 300, 'height', 30, 'hpos', 100);
title('Original Image T=0')
subplot(3,3,8)
ft_plot_matrix(crop(:,:,4),'width', 250, 'height', 30, 'hpos', 122);
title('Cropped Image T=0')