%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Module to do any data cleanup and add any new features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Judith Grieves
% Date:     27 October 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function InputData=DataManipulation(InputData)

    disp("**** MODULE: DataManipulation ***");    
    
    % Data cleaning
    % delete rows where G3=0
    %InputData(str2double(InputData.G3) == 0,:)=[]; 
    
    passMark=10;
    
    %create a new feature of pass/fail based on the passMark parameter
    disp("   ***** Add passFail column");    
    passFail = string(double(str2double(InputData.G3) >= passMark));
    InputData = addvars(InputData,passFail,'Before','school');
    InputData.Properties.VariableNames; % debug - show column names from file
    head(InputData,5); % debug
    
end    
  