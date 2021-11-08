%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Module to read a specified input file and perform functions:
%   DataManipulation
%   PerformEDA
%   CodeValues
%   PerformCorr
% then write out the resulting amended data to a new file.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Judith Grieves
% Date:     27 October 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ReadData(InputFile,FileFormat,FilePrefix)

    disp("**** MODULE: ReadData ***");

    %% set the filename and properties
    OutputFileName=  FilePrefix + "-coded.csv"; % output file name

    %% read in the file(s) and show the file attributes
    disp("   ***** Starting File read");
    InputData = readtable(InputFile,'Format',FileFormat);  % read in the file as all txt
    disp("   ***** Input File: " + InputFile);
    disp("   ***** File Format: " + FileFormat);
    %table2array(InputData(:,1:13) ),1)
    disp("   ***** Table size: " + num2str(size(InputData))); % show the new table size
    InputData.Properties;
    InputData.Properties.VariableNames; % show column names from file
    
    %% clean data and add features
    InputData=DataManipulation(InputData);
    %% do some data analysis
    PerformEDA(InputData);
    %% run a function to code the table values to numeric
    InputDataCoded=CodeValues(InputData);
    %% run a function on the coded data to show the most correlated values 
    PerformCorr(FilePrefix,InputDataCoded);

    %% write processed data out to *.csv
    disp("   ***** Write processed data to CSV");
    disp("   ***** Output File: " + OutputFileName); % display the output file
    writetable(InputDataCoded,OutputFileName); 
end
