%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% City University MSc Data Science
% Machine Learning Coursework
%
% A comparison of Decision Trees and Naive Bayes Classifier 
% on the 'Student' dataset.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Judith Grieves
% Date:     22 November 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
This zipped file contains the MATLAB code and Student datasets 
to train and test 2 machine learning models: 

	a Decision Tree and a Naive Bayes classifier.

The code has been written and run on MATLAB R2019b and R2020a.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Instructions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
To test the models, run:

	DTTest.m		test the Decision Tree model DTModel.mat
	NBTest.m		test the Naive Bayes model NBModel.mat

To train the models, run:

	RunAll.m		EDA, wrangling, training x2

This will train the best models for Decision Tree and Naive Bayes, 
do predictions on the train and test sets and output resulting
data analysis visualisations, result files and confusion charts.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File output of the training programs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
student-test.csv		: test dataset
student-train.csv		: training dataset
student-coded.csv		: original dataset with coded variables
DTAccuracy%Date%Time%.csv	: parameter details & accuracy results
NBAccuracy%Date%Time%.csv	: parameter details & accuracy results
student-corr.csv		: correlation analysis output
%predvars%Tree.csv		: decision tree diagram(s)
DTModel.mat			: trained Decision Tree model
NBModel.mat			: trained Naive Bayes model


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code/ Overview
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

student-por-original.txt	: the dataset under consideration

RunAll.m 			: top-level program to run the following modules

   ReadData.m			: read the specified input file and execute 

	DataManipulation.m	: perform any data cleaning and manipulation required
	PerformEDA.m		: Carry out Exploratory Data Analysis on the dataset
	CodeValues.m		: Convert the dataset into numeric coded values
	PerformCorr.m		: Carry out a correlation analysis on the dataset

   SplitTestTrain.m		: split the processed data into train & test sets

   DecisionTreeTrain.m          : train a Decision Tree model & test on Test dataset 
	GetAccuracy.m		: return a confusion matrix for known and predicted vars
	ErrPredictions.m	: output a file of incorrect predictions for analysis

   NaiveBayesTrain.m		: train a Naive Bayes model & test on Test dataset 
	GetAccuracy.m		: return a confusion matrix for known and predicted vars

ReadOutput.m			: Read the output files and show visualisations
