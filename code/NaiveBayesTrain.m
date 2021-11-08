%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Module to read in a training dataset and create a Naive Bayes 
% classifier by applying the Matlab function fitcnb.
% Also test the model on unseen data to evaluate the results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Judith Grieves
% Date:     27 October 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function NaiveBayesTrain(FilePrefix)
    %%    
    disp("**** MODULE: NaiveBayesTrain ***");    
    
    %% Read in the training data
    InputFileName = FilePrefix + "-train.csv";  
    disp("   ***** Reading Training Data: " + InputFileName)
    TrainingSet = readtable(InputFileName);
    disp("   ***** Size: " + size(TrainingSet,1) + " x " + size(TrainingSet,2) );

    %% Read in the test dataset 
    InputFileName = FilePrefix + "-test.csv";  
    disp("   ***** Reading Test Data: " + InputFileName)
    TestSet = readtable(InputFileName);
    disp("   ***** Size: " + size(TestSet,1) + " x " + size(TestSet,2) );
    
    %% grid search set up
    % parameters
    testRunComments={'Train/test split 50:50'};
    no_of_kfolds=10;                % no of folds in k-fold validation
    gridsearch=1;                   % index of result set
    random_num=1;                   % number of xval random loops
    
    % loop to test the results of random cross validations
    for randomLoop=1:random_num     
        % set up subsets of predictor variables
        sub_all=[2:33];             % All predictive variable
        sub_grades=[32 33];         % G1, G2  - most correlated
        sub_all_ex=[2:31];          % All but G1,G2
        %
        % grid search values - predictor subsets
        %subset_list = {sub_all, sub_grades, sub_all_ex};  
        %subset_desc = {'all vars', 'grades only', 'all excl. grades'};
        
        % best parameters
        subset_list = {sub_grades};                           
        subset_desc = {'grades only'}; 
        
        % gridsearch of predictor variable subsets
        for subset_num=1:size(subset_list,2)            
            
            subset=subset_list{subset_num};

            %% set the dependent variables to use from the subset value   
            TrainClassifier = TrainingSet(:,1);         % classifier column
            TrainDependents = TrainingSet(:,subset);    % use the subset of predictive vars    

            % set the Kernel smoother type hyperparameters
            Kernel={'normal'}; % normal=default, others: 'box', 'epanechnikov' ,'triangle';
            cvloss = zeros(size(Kernel,2),1);
            
            %  gridsearch of Kernel smoother types
            for kernel_num=1:size(Kernel,2)            
                
                %% train a Naive Bayes model on the training dataset and current params
                tic; % start the timer on training process

                % NBModel is a trained NaiveBayes classifier.
                NBModel = fitcnb(TrainDependents,TrainClassifier); % 

                % show features of the model
                disp(NBModel.Prior); % 
                NBModel.DistributionParameters;
    
                %% section to create the model with K-fold validation 
                
                CVNBModel = fitcnb(TrainDependents,TrainClassifier,'CrossVal','on','KFold',no_of_kfolds); % 'ClassNames',{'pass','fail'},

                % Full and compact naive Bayes models are not used for predicting on new data.
                % Instead, use them to estimate the generalization error by passing CVNBModel to kfoldLoss.

                % Evaluate the quality the model using kfoldLoss.
                cvloss(kernel_num) = kfoldLoss(CVNBModel);
                disp("   ***** K Fold loss: " + num2str(cvloss(kernel_num)));                
                timeTaken=toc;                                   % store time taken to train

                %% find the predicted classification on the training set
                TrainPredict = predict(NBModel,TrainDependents); % [label,PostProbs,MisClassCost]
                
                %  compare to known classes with a confusion matrix
                TrainAcc=GetAccuracy(table2array(TrainClassifier),TrainPredict);

                %%  find the predicted classification on the test set 
                
                TestClassifier = TestSet(:,1);       % classifier column
                Testdependents = TestSet(:,subset);  % use the subset of predictive vars 
                TestPredict = predict(NBModel,Testdependents);    

                %  compare to known classes with a confusion matrix
                TestAcc=GetAccuracy(table2array(TestClassifier),TestPredict);
                
                %% concatenate all output results
                
                accTest=array2table(TestAcc,'VariableNames',{'TestAccuracy','TstTP','TstTN','TstFP','TstFN'});
                accTrain=array2table(TrainAcc,'VariableNames',{'TrainAccuracy','TrnTP','TrnTN','TrnFP','TrnFN'});
                CVloss=array2table([no_of_kfolds cvloss(kernel_num)],'VariableNames',{'Folds','CrossValLoss'});
                prog={'Naive Bayes'};
                %pred_columns={TrainingSet.Properties.VariableNames(subset)};
                dt = {datetime('now','TimeZone','local','Format','yyyy-MM-dd HH:mm:ss Z')};
                params= array2table([Kernel(kernel_num)],'VariableNames',{'Kernel'});
                holdoutPerc=array2table([round(size(TestSet,1)/(size(TrainingSet,1)+size(TestSet,1))*100)],...
                    'VariableNames',{'HoldoutPerc'});
                
                % concatenate current gridsearch results and append to
                % previous
                
                t=horzcat(table(prog,testRunComments,subset_desc(subset_num),dt),params,CVloss,accTrain,accTest,array2table(timeTaken),holdoutPerc);
                allResults(gridsearch,:)=t; 
                gridsearch=gridsearch+1;
            end % end of leafsize grid search
        end % end of subset grid search
    end % end of random loop    
    
    disp(accTest);
    % show the confusion charts & decision trees for the last/best model
    
    % training data
    figure
    cChart = confusionchart(table2array(TrainClassifier),TrainPredict,'RowSummary','row-normalized','ColumnSummary','column-normalized');   
    cChart.Title = 'Confusion Matrix - Naive Bayes (Train) Student Pass/Fail';
    
    % test data
    figure
    cChart = confusionchart(table2array(TestClassifier),TestPredict,'RowSummary','row-normalized','ColumnSummary','column-normalized');   
    cChart.Title = 'Confusion Matrix - Naive Bayes (Test) Student Pass/Fail';
    
    %% write output results to a file
    fileDate=string(datetime('now','TimeZone','local'),"yyyy-MM-dd_HHmmSSS");
    outputFile= "NBAccuracy" + fileDate + ".xlsx";
    disp("Accuracy Results File: " + outputFile);
    writetable(allResults,outputFile);  % write out grid search results - ,'WriteMode','Append'
    
    % save the trained model
    save NBModel.mat NBModel; 
    
