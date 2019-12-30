function mat_file_list = EDF_preprocess_definetrials (EEGfiles, EEGfile_names,prestim,poststim)

num_files = length(EEGfiles);
mat_file_list = {};
for i = 1:num_files
    %%pre-process based on EEGfiles list and define channle list and file name for each experiment
    session = char(strcat(extractBefore(EEGfile_names{i},'.edf'),'.mat')); %file name to be saved as .mat and remove .edf
    cfg            = []; %Create config structure
    cfg.dataset    = EEGfiles{i}; % i.e. 'S2/Session 1/rsvp_5Hz_02a.edf';
    cfg.channel    = 1:8; %{'EEG PO8';'EEG PO7';'EEG P8';'EEG P7';'EEG O1';'EEG O2';'EEG PO3';'EEG PO4'};
    ft_preprocessing(cfg);
    %% Extract events from experiment and store in cfg structure and parameters for ft_definetrial
    cfg.event = ft_read_event(cfg.dataset, 'detectflank', []);%extract triggers from data
    %% Defining trial paramenters from given experiment
    eventtype = getfield(cfg.event, 'type');%defining the type of trigger i.e. annotation
    %trigger = extractfield(cfg.event,'value');
    %trigger_idx = find(startsWith(trigger,'T='));
    cfg.headerfile   = EEGfiles; % example 'U:/KDD/2nd Semester/Dissertation/example dataset/S2/Session 1/rsvp_5Hz_02a.edf';
    %cfg.trials       = trigger_idx;
    cfg.datafile     = EEGfiles; % example'U:/KDD/2nd Semester/Dissertation/example dataset/S2/Session 1/rsvp_5Hz_02a.edf';
    cfg.trialdef.eventtype  = eventtype; % example'annotation';
    cfg.trialdef.prestim    = prestim; % in seconds before stimuli
    cfg.trialdef.poststim   = poststim; % in seconds after stimuli
    
    cfg = ft_definetrial(cfg); %define trials
    
    cfg.baselinewindow = [-inf 0]; %removes data before the 0 second when trial begins
    cfg.demean         = 'yes'; %allows the adjustment of a new baseline
    
    EEG_Data = ft_preprocessing(cfg); %pre-process data with the given attributes above
    
    save(session, 'EEG_Data', 'cfg'); %save preprocessed and trial data into a mat file per subject and per experiment
    mat_file_list{end + 1} = session;
end

%Visualise the data
%data.cfg.layout = 'vertical';
%  ft_databrowser(EEG_Data.cfg);
%  figure
%  plot(EEG_Data.time{11}, EEG_Data.trial{11}(1,:));% the : is all of the channels you can specify
