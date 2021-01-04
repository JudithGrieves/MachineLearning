%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Controlling program to read in data, process, perform EDA and 
% train 2 classifiers: Decision Tree & Naive Bayes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Judith Grieves
% Date:     27 October 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all; 
clc;
clf;

disp("*** MODULE: RunAll ***");

% set up parameters
InputFile=["student-por-original.txt"]; % input file prefix
FilePrefix=["student"];                 %  prefix to use for file names
FileFormat='%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s';
ClassCol=1;
testRatios=[0.50]; % test/train split % - grid search values [0.2 0.3 0.4 0.5 0.6];

% execute all modules
for ratio=testRatios
    ReadData(InputFile,FileFormat,FilePrefix);  % Read the file, output data analysis, clean & wrangle
    SplitTestTrain(FilePrefix,ratio);                 % split the processed data into train & test sets
    DecisionTreeTrain(FilePrefix);              % train and evaluate the Decision Tree
    NaiveBayesTrain(FilePrefix);                % train and evaluate the Naive Bayes
end