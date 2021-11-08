%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Module to read a the experiment output data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Judith Grieves
% Date:     19 November 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ReadOutput(InputFile)

    disp("**** MODULE: ReadData ***");
    InputFile='DTAccuracy2020-11-20_0658074.xlsx';

    %% read in the file(s) and show the file attributes
    disp("   ***** Starting File read");
    InputData = readtable(InputFile);  % read in the file 
    disp("   ***** Input File: " + InputFile);
    disp("   ***** Table size: " + num2str(size(InputData))); % show the new table size
    InputData(1:5,:);
    InputData.Properties.VariableNames; % show column names from file
    
    %%
    summary(InputData)
    groupsummary(InputData,'HoldoutPerc')
    
    %% plot cross validation loss & test Accuracy
    
    InputData.HoldoutPerc;
    InputData.CrossValLoss;
    %
    figure
    plot(InputData.CrossValLoss*100)
    legend('Cross Validation Loss')
    xlabel('Experiments')
    figure
    plot(InputData.TestAccuracy)
    legend('Test Acuracy')
    
    %% plot Time taken for all
    figure
    plot(InputData.timeTaken)
    ylabel('Time Taken')
    xlabel('Experiments')
    
    %% plot any2  metrics
    
    clf
    metric=InputData.TestAccuracy;
    params=InputData.minParent;
    Xlabel='minParent';
    Ylabel='TestAccuracy';
    
    for metric=metric_list
        figure
        plot(params,metric)
        xlabel(Xlabel); 
        ylabel(Ylabel); 
    end
    %% plot a metric by a grouped parameter

    clf;
    
   % params=InputData.Var3;  % a textual value - the predictor subset
   % metric=InputData.CrossValLoss;
    
    params=InputData.Var3;  % a textual value - the predictor subset
    params=InputData.minParent; % a numeric value
    metric=InputData.TestAccuracy;
    metric=InputData.timeTaken;
    
    % plot metric for all parameters
    figure
    plot(metric);  
    xlabel('Experiments');              
    
    % set up the list of unique parameter values and legend labels
    uniqueParams=unique(params);
    labels=categorical(uniqueParams');
    
    % plot the metric by parameter value
    figure
    for n=1:size(uniqueParams,1)
        ind = categorical(params)==categorical(uniqueParams(n));
        yvals=metric(ind);
        hold on;
        plot(yvals)
    end
    legend(labels); 
    
%%
    
    boxplot(str2double([1 2 3]))

end
