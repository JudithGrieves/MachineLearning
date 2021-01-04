%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Machine Learning Coursework 
%
% Test a Naive Bayes classifier
% Note: the  saved model contains the variable names used in the test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Judith Grieves
% Date:     16 November 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all; 
clc;

disp("### Running NBTest.m");
disp("Testing the Naive Bayes model on");
load NBModel;


Filelist=["student-test.csv"];
for InputFile = Filelist, 
    disp("Input File: " + InputFile);
    testData = readtable(InputFile); 
        
    % predict the classifiers for the test dataset
    TestPredict = predict(NBModel,testData); 
    
    TestClassifier = table2array(testData(:,1));       % set the classifier column
    
    %cChart = confusionchart(TestClassifier,TestPredict,'RowSummary','row-normalized','ColumnSummary','column-normalized');   
    %cChart.Title = 'Confusion Matrix - Naive Bayes (Test) Student Pass/Fail';
    
    TestAcc=GetAccuracy(TestClassifier,TestPredict);   % get the accuracy stats
    disp("Test Accuracy: " + num2str(TestAcc));
end;