function [EEGfiles, EEGfile_names] = get_EEG_data(data_path, categories)

num_cat = length(categories); %established the number of loops to perform
EEGfiles ={}; %create empty cell array for file struct of names of EEG .edf files
EEGfile_names = {}; %Creates empty cell array for storing the names of .edf files for preprocessing
for i = 1:num_cat
    files = dir( fullfile(data_path, categories{i}, '*.edf')); %creates file struct of EEG files 
    num_files = length(files(:,1)); %counts the number of files in the file struct
    %file_names = getfield(files, 'name');
    for j=1:num_files 
        %EEGfiles{EEGfiles+1} = getfield(files,{j,1}, 'name');
        %Extracts the file path and names of the EEGfiles
        EEGfiles{end + 1} = fullfile(getfield(files,{j,1}, 'folder') ,getfield(files,{j,1}, 'name'));
        %stores the name of the each .edf file 
        EEGfile_names{end + 1} = fullfile(getfield(files,{j,1}, 'name'));

    end
end
%rearrange the layout of the file names and paths to be by row instead of column
EEGfiles = EEGfiles'; 
EEGfile_names = EEGfile_names';  
