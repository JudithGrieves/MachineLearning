%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Machine Learning Coursework 
%
% Test a Decision Tree classifier
% Note: the  saved model contains the variable names used in the test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Judith Grieves
% Date:     16 November 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all; 
clc;

disp("### Running DTTest.m");
disp("Testing the Decision Tree model on");
load DTModel;

Filelist=["student-test.csv"];
for InputFile = Filelist, 
    disp("Input File: " + InputFile);
    testData = readtable(InputFile); 
        
    % predict the classifiers for the test dataset
    TestPredict = predict(DTModel,testData); 
    
    TestClassifier = table2array(testData(:,1));       % set the classifier column
    
    %cChart = confusionchart(TestClassifier,TestPredict); %,'RowSummary','row-normalized','ColumnSummary','column-normalized');   
    %cChart.Title = 'Confusion Matrix - Decision Tree (Test) Student Pass/Fail';
    
    TestAcc=GetAccuracy(TestClassifier,TestPredict);    % get the accuracy stats
    disp("Test Accuracy: " + num2str(TestAcc));
end;