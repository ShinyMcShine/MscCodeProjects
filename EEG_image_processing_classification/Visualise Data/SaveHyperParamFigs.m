%% For Each Subject to Save Figures
PC =9;
Channel = 'O1O2';
%Setting up the file name for saving and path
%modelfolder = strcat('LinearTop',string(PC),'EV');%if I was testing Linear kernel
modelfolder = strcat('RBFtop',string(PC),'EV');%if I was testing RBF kernel
%ChannelMean
FolderName = char(strcat('U:\KDD\2nd Semester\Dissertation\Figures\Model Train\',modelfolder,'\MeanChannels'));
%Each Channel
%FolderName = char(strcat('U:\KDD\2nd Semester\Dissertation\Figures\Model Train\',modelfolder,'\EachChannelSub'));

FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
if strcmp(Channel,'O1')
    %For Channel O1 Each Subject
    Filelist=struct('figname',{'Sub14_O1_FuncModelMean','Sub14_O1_MinObj_vs_NumFunEval'...
        ,'Sub13_O1_FuncModelMean','Sub13_O1_MinObj_vs_NumFunEval','Sub12_O1_FuncModelMean','Sub12_O1_MinObj_vs_NumFunEval'...
        ,'Sub11_O1_FuncModelMean','Sub11_O1_MinObj_vs_NumFunEval','Sub10_O1_FuncModelMean','Sub10_O1_MinObj_vs_NumFunEval'...
        ,'Sub9_O1_FuncModelMean','Sub9_O1_MinObj_vs_NumFunEval','Sub8_O1_FuncModelMean','Sub8_O1_MinObj_vs_NumFunEval'...
        ,'Sub6_O1_FuncModelMean','Sub6_O1_MinObj_vs_NumFunEval','Sub4_O1_FuncModelMean','Sub4_O1_MinObj_vs_NumFunEval'...
        ,'Sub3_O1_FuncModelMean','Sub3_O1_MinObj_vs_NumFunEval','Sub2_O1_FuncModelMean','Sub2_O1_MinObj_vs_NumFunEval'});
end
if strcmp(Channel,'O2')
    %For Channel O2 Each Subject
    Filelist=struct('figname',{'Sub14_O2_FuncModelMean','Sub14_O2_MinObj_vs_NumFunEval'...
        ,'Sub13_O2_FuncModelMean','Sub13_O2_MinObj_vs_NumFunEval','Sub12_O2_FuncModelMean','Sub12_O2_MinObj_vs_NumFunEval'...
        ,'Sub11_O2_FuncModelMean','Sub11_O2_MinObj_vs_NumFunEval','Sub10_O2_FuncModelMean','Sub10_O2_MinObj_vs_NumFunEval'...
        ,'Sub9_O2_FuncModelMean','Sub9_O2_MinObj_vs_NumFunEval','Sub8_O2_FuncModelMean','Sub8_O2_MinObj_vs_NumFunEval'...
        ,'Sub6_O2_FuncModelMean','Sub6_O2_MinObj_vs_NumFunEval','Sub4_O2_FuncModelMean','Sub4_O2_MinObj_vs_NumFunEval'...
        ,'Sub3_O2_FuncModelMean','Sub3_O2_MinObj_vs_NumFunEval','Sub2_O2_FuncModelMean','Sub2_O2_MinObj_vs_NumFunEval'});
end
if strcmp(Channel,'O1O2')
    %For MeanChannels O1 and O2 Each Subject
    Filelist=struct('figname',{'Sub14_O1O2_FuncModelMean','Sub14_O1O2_MinObj_vs_NumFunEval'...
        ,'Sub13_O1O2_FuncModelMean','Sub13_O1O2_MinObj_vs_NumFunEval','Sub12_O1O2_FuncModelMean','Sub12_O1O2_MinObj_vs_NumFunEval'...
        ,'Sub11_O1O2_FuncModelMean','Sub11_O1O2_MinObj_vs_NumFunEval','Sub10_O1O2_FuncModelMean','Sub10_O1O2_MinObj_vs_NumFunEval'...
        ,'Sub9_O1O2_FuncModelMean','Sub9_O1O2_MinObj_vs_NumFunEval','Sub8_O1O2_FuncModelMean','Sub8_O1O2_MinObj_vs_NumFunEval'...
        ,'Sub6_O1O2_FuncModelMean','Sub6_O1O2_MinObj_vs_NumFunEval','Sub4_O1O2_FuncModelMean','Sub4_O1O2_MinObj_vs_NumFunEval'...
        ,'Sub3_O1O2_FuncModelMean','Sub3_O1O2_MinObj_vs_NumFunEval','Sub2_O1O2_FuncModelMean','Sub2_O1O2_MinObj_vs_NumFunEval'});
end


for iFig = 1:length(FigList)
    FigHandle = FigList(iFig);
    %FigName   = get(FigHandle, 'Name');
    FigName = Filelist(iFig).figname;
    savefig(FigHandle, fullfile(FolderName,[FigName , '.fig']));
end
%% For All Subjects to Save Figures
PC =9;
Channel = 'O1O2';
%Setting up the file name for saving and path
%modelfolder = strcat('LinearTop',string(PC),'EV');%if I was testing Linear kernel
modelfolder = strcat('RBFtop',string(PC),'EV');%if I was testing RBF kernel
%ChannelMean
FolderName = char(strcat('U:\KDD\2nd Semester\Dissertation\Figures\Model Train\',modelfolder,'\MeanChannels'));
%Each Channel
%FolderName = char(strcat('U:\KDD\2nd Semester\Dissertation\Figures\Model Train\',modelfolder,'\EachChannelSub'));

FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
if strcmp(Channel,'O1')
    %For Channel O1 Each Subject
    Filelist=struct('figname',{'AllSub_O1_FuncModelMean','AllSub_O1_MinObj_vs_NumFunEval'});
end
if strcmp(Channel,'O2')
    %For Channel O2 Each Subject
    Filelist=struct('figname',{'AllSub_O2_FuncModelMean','AllSub_O2_MinObj_vs_NumFunEval'});
end
if strcmp(Channel,'O1O2')
    %For MeanChannels O1 and O2 Each Subject
    Filelist=struct('figname',{'AllSub_O1O2_FuncModelMean','AllSub_O1O2_MinObj_vs_NumFunEval'});
end


for iFig = 1:length(FigList)
    FigHandle = FigList(iFig);
    
    FigName = Filelist(iFig).figname;
    savefig(FigHandle, fullfile(FolderName,[FigName , '.fig']));
end