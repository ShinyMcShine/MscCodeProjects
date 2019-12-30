function time_freq_EEG_AllTrials_spectrogram(mat_file_list, stim, data_path)
%% This for loop goes through only the 5Hz subjects Preprocessed data from mat_file_list
% for visualising all trials as a mean for a each subject
% This can be changed to do other experiments using the for loop
% configuraition below

%For loop configuration
% y= 1:length(mat_file_list) to process all experiements from all subjects
% y= 22: 42 will create spectrograms for 5Hz only
% y= 22:62 will create spectrograms for 5Hz and 6Hz only
for y = 21:42%length(mat_file_list) %temporaryly starting at six
    switch (stim)
        case 'target'
            fprintf('Loading file %s......\n',mat_file_list{y})
            load (strcat(data_path,mat_file_list{y}));
            fprintf('File loaded!\n')
            trigger = extractfield(cfg.event,'value');
            channels = EEG_Data.cfg.channel;
            trigger_idx = find(startsWith(trigger,'T=1'));
            ImgMatrix = [];
            Img_idx = 0;
            cfg.trials       = trigger_idx; %index location for all T=1 stimuli triggers
            EEG_Data_Trial = ft_preprocessing(cfg,EEG_Data);
            figure %used to create a figure of EEG Spectrograms
            %for    i = 1:length(trigger_idx) % Collect all triggers\trial
            %for    i = 1:8
            %for z = 1:length(channels) %Collect the measurements from each channel for a given trigger
                %Img_idx = 1 + Img_idx;
                cfg              = [];
                cfg.output       = 'pow'; %return power spectra
                cfg.channel      = 'all';
                cfg.method       = 'wltconvol';
                %cfg.trials       = trigger_idx; %specify index location to find event in EEG_Data_Trial.trial
                cfg.width        = 1; % 3 has shown some promise for results
                cfg.gwidth       = 4; %decreasing this has shown to fill out are of the figure
                cfg.pad          = 20; %increases resolution as the value goes up
                cfg.foilim       = [1 30]; %1 to 30 Hz range
                %cfg.toi          = -.10:0.0001:.35; %produced a full image time window from -100 ms to 350ms in 0.1ms steps
                cfg.toi          = -.05:0.00001:.250; %time window from -50 ms to 250ms in 0.01ms steps
                
                TFRwavelet = ft_freqanalysis(cfg, EEG_Data_Trial);
                %fprintf('\n Time-Freq wavelet for trigger index %u channel %s and processed %u trigger(s)\n',trigger_idx(i),channels{z},i)
                
                %Frequency baseline before creating TFR
                cfg = [];
                cfg.baseline  = 'yes';
                cfg.baselinetype = 'relchange';
                [freq] = ft_freqbaseline(cfg, TFRwavelet);
                
                cfg = [];
                %Create Image of EEG Spectrogram to output cdat matrix
                cfg.maskstyle = 'saturation';
                cfg.zlim         =  'maxmin';
                cfg.layout       = 'ordered';
                cfg.showlabels   = 'yes';
                cfg.showoutline      = 'yes';
                %subplot(2,4,z)%used to create figures of plotted channels
                [EEG_Spec] = ft_multiplotTFR(cfg, freq);
%                 subplot(2,4,z)%used to create figures of plotted channels
%                 Img = flipud(cdat); %flip the values of cdat as the original image was upside down
%                 Img_min = min(min(Img));
%                 Img_max = max(max(Img));
%                 Img = (Img-Img_min)/Img_max; %normalise the data within 0-1 a grayscale range
%                 ImgMatrix(:,:,Img_idx) = Img; %store each image matrix into a dimension from start of exp to end in chronlogical order
            %end
    
%     filename = strcat('EEG_Spec_T1_EachChannel_',mat_file_list{y});
%     ImgMatrix = single(ImgMatrix);
%     fprintf('Creating filename and saving..... %s\n', filename)
%     save(filename,'ImgMatrix','channels');
%     fprintf('File %s has been saved successfully with %u triggers\n',filename,i)
%     
    case 'notarget'
        fprintf('Loading file %s......\n',mat_file_list{y})
        load (strcat(data_path,mat_file_list{y}));
        fprintf('File loaded!\n')
        trigger = extractfield(cfg.event,'value');
        channels = EEG_Data.cfg.channel;
        trigger_idx = find(startsWith(trigger,'T=0'));
        msize = numel(trigger_idx); %set minsize for idx
        T0_random = trigger_idx(randperm(msize, 50)); %select the first 50 randomly selected indexes
        ImgMatrix = [];
        Img_idx = 0;
        cfg.trials       = T0_random; %index location for all T=0 stimuli triggers
        %trials = 1:1:50;
        EEG_Data_Trial = ft_preprocessing(cfg,EEG_Data);
        %T0_random = trigger_idx(randi(numel(trigger_idx),1,50));
        figure %used to create a figure of EEG Spectrograms
        %for i = 1:50 % Collect the first 50 triggers\trial
            
            %for z = 1:length(channels) %Collect the measurements from each channel for a given trigger
                Img_idx = 1 + Img_idx;
                cfg              = [];
                cfg.output       = 'pow'; %return power spectra
                cfg.channel      = 'all';
                cfg.method       = 'wavelet';
                %cfg.trials       = 1; %specify index location to find event in EEG_Data_Trial.trial
                cfg.width        = 1; % 3 has shown some promise for results
                cfg.gwidth       = 4; %decreasing this has shown to fill out are of the figure
                cfg.pad          = 20; %increases resolution as the value goes up
                cfg.foilim       = [1 30]; %1 to 30 Hz range
                %cfg.toi          = -.10:0.0001:.35; %produced a full image time window from -100 ms to 350ms in 0.1ms steps
                cfg.toi          = -.05:0.00001:.250; %time window from -50 ms to 250ms in 0.01ms steps
                
                TFRwavelet = ft_freqanalysis(cfg, EEG_Data_Trial);
                fprintf('\n Time-Freq wavelet for trigger index %u channel %s and processed %u trigger(s)\n',trigger_idx(i),channels{z},i)
                
                cfg = [];
                cfg.baseline  = 'yes';
                cfg.baselinetype = 'relchange';
                [freq] = ft_freqbaseline(cfg, TFRwavelet);
                
                %Create Image of EEG Spectrogram to output cdat matrix
                cfg = [];
                %cfg.baselinetype = 'relchange';
                cfg.maskstyle = 'saturation';
                cfg.zlim         =  'maxmin';
                cfg.layout       = 'ordered';
                cfg.showlabels   = 'yes';
                cfg.showoutline      = 'yes';
                %subplot(2,4,z)%used to create figures of plotted channels
                [EEG_Spec] = ft_multiplotTFR(cfg, freq);
%                 [EEG_Spec,cdat] = ft_singleplotTFR(cfg, freq); %used
%                 %to create a single plot image
%                 %subplot(2,4,z)%used to create figures of plotted channels
%                 Img = flipud(cdat); %flip the values of cdat as the original image was upside down
%                 Img_min = min(min(Img));
%                 Img_max = max(max(Img));
%                 Img = (Img-Img_min)/Img_max; %normalise the data within 0-1 a grayscale range
%                 ImgMatrix(:,:,Img_idx) = Img; %store each image matrix into a dimension from start of exp to end in chronlogical order
           % end
        %end
        %             filename = strcat('EEG_Spec_T0_EachChannel_',mat_file_list{y});
        %             ImgMatrix = single(ImgMatrix);
        %             fprintf('Creating filename and saving..... %s\n', filename)
        %             save(filename,'ImgMatrix','channels');
        %             fprintf('File %s has been saved successfully with %u triggers\n',filename,i)
        otherwise
            fprintf('Incorrect stim variable: %s , please use target or notarget.',stim)
end
end
%ft_databrowser(cfg,EEG_Data_Trial) %for troubleshooting purposes to view
%results from trial(s)