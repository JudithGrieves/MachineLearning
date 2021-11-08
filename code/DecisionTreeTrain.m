%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Module to read in a training dataset and train a Decision Tree by 
% applying the Matlab function fitctree.
% Also test the model on unseen data to evaluate the results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Judith Grieves
% Date:     27 October 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function DecisionTreeTrain(FilePrefix)
    %%    
    disp("**** MODULE: DecisionTreeTrain ***");    
    hTree=findall(0,'Tag','tree viewer'); close(hTree) % close any previous tree diagrams
    
    showFigs=1;                                        % parameter to show/not  diagrams - suppress during gridsearch
    
    
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
    
    TrainClassifier = TrainingSet(:,1);         % classifier column
    
    % parameters
    testRunComments={'train/test split'};
    no_of_kfolds=10;            % no of folds in k-fold validation
    
    % set up experimental predictor subsets
    sub_all=[2:33];         % All predictive variable
    sub_grades=[32 33];     % G1, G2  - most correlated
    sub_all_ex=[2:31];      % All but G1,G2

    % grid search values - predictor variable subsets
    % subset_list = {sub_all, sub_grades, sub_all_ex};  
    % subset_desc = {'all vars', 'grades only', 'all excl. grades'};
    % best parameters    
    subset_list = {sub_grades};                           
    subset_desc = {'grades only'};

    %default tree parameters
    maxSplits=size(TrainingSet,1);          % default is size(X,1)  1.
    minParent =10;  % default is 10 
    minLeaf=1;     % default is 1
    % 
    % grid search values - Tree hyperparameters
    leafs=[18];     %[2:2:6];  %[minLeaf]; %   % grid search  - leaf values 
    parents=[20];   %[2:2:20];   %[minParent]; grid search - minParent
    splits=[260];   %[10:50:325]; [maxSplits]; % grid search - maxSplits
    
    gridsearch=1;               % index of result set
    r=1;                        % number of xval random loops
    
    for randomLoop=1:r                       % loop to test the results of random cross validations
        for subset_num=1:size(subset_list,2) % gridsearch of predictor variable subsets
            subset=subset_list{subset_num};

            %% set the dependent variables to use    
            TrainDependents = TrainingSet(:,subset);    % use the subset of predictive vars    

            for L=1:numel(leafs)
                for P=1:numel(parents)
                    for S=1:numel(splits)

                        %% train a decision tree model on the training dataset and current params
                        
                        tic; % start the timer on training process

                        DTModel = fitctree(TrainDependents,TrainClassifier,...
                            'MaxNumSplits',splits(S),...
                            'MinParentSize',parents(P),...
                            'MinLeafSize',leafs(L)); % create classification tree

                        resuberror = resubLoss(DTModel); 

                        % show the resulting tree structure 
                        if showFigs
                            view(DTModel,'mode','graph'); 
                        end

                        % Create a crossvalidated model to evaluate the losses
                        cvmodel = crossval(DTModel,'KFold',no_of_kfolds);
                        % Evaluate the quality the model using kfoldLoss.
                        cvloss(gridsearch) = kfoldLoss(cvmodel);
                        disp("   ***** K Fold loss: " + num2str(cvloss(gridsearch)));                
                        timeTaken=toc;  % store time taken to train

                        %% find the predicted classification on the training set
                        TrainPredict = predict(DTModel,TrainDependents); 

                        %  compare to known classes with a confusion matrix
                        TrainAcc=GetAccuracy(table2array(TrainClassifier),TrainPredict);

                        %%  find the predicted classification on the test set 

                        % set the dependent variables to use    
                        TestClassifier = TestSet(:,1);       % classifier column
                        Testdependents = TestSet(:,subset);  % use the subset of predictive vars 
                        TestPredict = predict(DTModel,Testdependents);    

                        %  compare to known classes with a confusion matrix
                        TestAcc=GetAccuracy(table2array(TestClassifier),TestPredict);
                        
                        % function to investigate incorrect predictions -
                        % run when required
                        
                        % ErrPredictions(table2array(TestClassifier), TestPredict, TestSet);
                        
                        % TestLoss=loss(model,testdata)

                        %% concatenate all output results               
                        accTest=array2table(TestAcc,'VariableNames',{'TestAccuracy','TstTP','TstTN','TstFP','TstFN'});
                        accTrain=array2table(TrainAcc,'VariableNames',{'TrainAccuracy','TrnTP','TrnTN','TrnFP','TrnFN'});
                        CVloss=array2table([no_of_kfolds cvloss(gridsearch)],'VariableNames',{'Folds','CrossValLoss'});
                        prog={'Decision Tree'};
                        %pred={TrainingSet.Properties.VariableNames(subset)};
                        dt = {datetime('now','TimeZone','local','Format','yyyy-MM-dd HH:mm:ss Z')};
                        params= array2table([splits(S) parents(P) leafs(L)],'VariableNames',{'maxSplits','minParent','minLeaf'});
                        holdoutPerc=array2table([round(size(TestSet,1)/(size(TrainingSet,1)+size(TestSet,1))*100)],...
                            'VariableNames',{'HoldoutPerc'});

                        % concatenate current gridsearch table and append
                        % to previous
                        t=horzcat(table(prog,testRunComments,subset_desc(subset_num),dt),params,CVloss,accTrain,accTest,array2table(timeTaken),holdoutPerc);
                        allResults(gridsearch,:)=t; 
                        gridsearch=gridsearch+1;
                    end % maxSplits loop
                end % minParents loop
            end % minLeaf loop
        end % end of subset grid search
    end % end of random loop
    
    disp(accTest);
    % show the accuracy results, confusion charts & decision trees for the last/best model
    
    
    if showFigs
    % training data
        figure
        cChart = confusionchart(table2array(TrainClassifier),TrainPredict,'RowSummary','row-normalized','ColumnSummary','column-normalized');   
        cChart.Title = 'Confusion Matrix - Decision Tree (Train) Student Pass/Fail';
    
    % test data
        figure
        cChart = confusionchart(table2array(TestClassifier),TestPredict,'RowSummary','row-normalized','ColumnSummary','column-normalized');   
        cChart.Title = 'Confusion Matrix - Decision Tree (Test) Student Pass/Fail';
    end
    
    %% write output results to a file
    fileDate=string(datetime('now','TimeZone','local'),"yyyy-MM-dd_HHmmSSS");
    outputFile= "DTAccuracy" + fileDate + ".xlsx";
    disp("Accuracy Results File: " + outputFile);
    writetable(allResults,outputFile);  % write out grid search results 
    
    % save the trained model
    save DTModel.mat DTModel;
    
end
