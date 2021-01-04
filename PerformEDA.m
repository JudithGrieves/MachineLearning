%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Module to perform exploratory data analysis on the dataset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Judith Grieves
% Date:     27 October 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (i) scatter of previous grades v final grade
% (ii) histogram of grade values
% (iii) histogram of non-grade values

function PerformEDA(InputData)

    disp("**** MODULE: PerformEDA ***");

    %% Read in the data

    disp ("   ***** number of records: " + size(InputData,1)); 
    disp ("   ***** number of columns: " + size(InputData,2)); 

    %disp(InputDataCoded.Properties.VariableNames(:)); % check variable names loaded
    InputDataMat=table2array(InputData);

    %% show scatter of interim grades against final (cols 32,33,34)
    subplot(1,2,1);
    s=scatter(str2double(InputData.G3),str2double(InputData.G1));
    title('G1 against Final Grade');
    ylabel('G1');
    s.MarkerFaceColor ='#0072BD'; % '#D95319' %'r'
    s.MarkerFaceAlpha =0.1; %transparency
    s.LineWidth = 0.6;
    s.MarkerEdgeColor = 'b';
    s.MarkerFaceColor = [0 0.5 0.5];
    subplot(1,2,2);
    s=scatter(str2double(InputData.G3),str2double(InputData.G2));
    title('G2 against Final Grade');
    ylabel('G2');
    s.MarkerFaceColor ='#0072BD'; % '#D95319' %'r'
    s.MarkerFaceAlpha =0.1; %transparency
    
    %% show a histogram of each grade variable (cols 32:34)
    no_of_bins=10;    
    % histogram of the interim and final grades
    var_count=3;         % number of subplots
    hist_cols= 3;        % number of plot columns
    hist_rows = 1;       % number of plot rows
    figure
    for i=1:var_count
        subplot(hist_rows,hist_cols,i)
        histogram(str2double(InputData{:,i+31})) ;
        %hist(InputDataMat(:,i),no_of_bins)    
        title(InputData.Properties.VariableNames{i+31},'fontsize',8); % use headers from input file  
        %xticks(1:size(InputDataMat(:,i),2));
        grid on;   
    end    
    
    %% show a histogram of each non-grade variable (cols 1:31)
    var_count=size(InputDataMat,2)-3;   % number of subplots
    hist_cols= 5;                       % number of plot columns
    hist_rows = 7;                      % number of plot rows
    figure
    for i=1:var_count
        subplot(hist_rows,hist_cols,i);
        cols=InputDataMat(:,i);
        cat=categorical(cols);
        histogram(cat) ;    
        title(InputData.Properties.VariableNames{i},'fontsize',8); % use headers from input file  
        grid on     
        hold on;
    end    
end