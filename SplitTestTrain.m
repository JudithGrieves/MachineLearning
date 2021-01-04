%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Module to split the input file into training & test sets based on 
% parameter testRatio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Judith Grieves
% Date:     27 October 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function SplitTestTrain(FilePrefix,testRatio)

    disp("**** MODULE: SplitTestTrain ###");
    % parameters to vary
    classCol=1; % location of the classification variable in the file
    
    % Read in the file
    InputFileName = FilePrefix + "-coded.csv";
    disp("    **** Input File: " + InputFileName); % display the input file
    AllData = readtable(InputFileName);  % read in the file
    class= table2array(AllData(:,classCol)); % extract the classification column

    % randomly split into test & training sets
    disp("    **** partition the data. Test holdout: " + num2str(testRatio*100) + '%');
    rng(1)  % for reproducibility
    
    % partition the predictor data based on testRatio
    cv = cvpartition(size(class,1),'HoldOut',testRatio);
    trainInds = training(cv);
    testInds = test(cv);

    trainSet = AllData(trainInds,:);
    testSet = AllData(testInds,:);

    disp("    **** Train: " + num2str(size(trainSet)));
    disp("    **** Test: " + num2str(size(testSet)));   
    
    % show the distribution of the classifier, overall and in train/test
    % files
    disp("    **** Class = 1(Overall) : " + round((size(class(class==1),1) ...
        / size(class,1)) * 100) + "%  ")
    testClass=table2array(testSet(:,1));
    disp("    **** Class = 1 (Test set) : " + round(sum(testClass) ...
        / size(testClass,1) * 100) + '%')
    trainClass=table2array(trainSet(:,1));
    disp("    **** Class = 1 (Train set) : " + round(sum(trainClass)...
        / size(trainClass,1) * 100) + '%')
   
    outputFile = FilePrefix + "-train.csv";
    disp("    **** Output Train File: " + outputFile); % display the input file
    writetable(trainSet,outputFile); 

    outputFile = FilePrefix + "-test.csv";
    disp("    **** Output Test File: " + outputFile); % display the input file
    writetable(testSet,outputFile); 
end