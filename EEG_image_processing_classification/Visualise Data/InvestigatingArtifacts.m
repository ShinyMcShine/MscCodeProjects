num_files = length(EEGfiles);
for i = 1:num_files
session = char(strcat(extractBefore(EEGfile_names{i},'.edf'),'.mat')); %file name to be saved as .mat and remove .edf
    cfg            = []; %Create config structure
    cfg.dataset    = EEGfiles{i}; %'S2/Session 1/rsvp_5Hz_02a.edf';
    cfg.channel    = 1:8; %{'EEG PO8';'EEG PO7';'EEG P8';'EEG P7';'EEG O1';'EEG O2';'EEG PO3';'EEG PO4'};
    data = ft_preprocessing(cfg);

rejectedArt_data = ft_rejectartifact(cfg,data);
end