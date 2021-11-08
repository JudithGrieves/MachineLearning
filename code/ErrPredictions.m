%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Module to investigate incorrect predictions
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Judith Grieves
% Date:     27 October 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ErrPredictions(Classifier,Predict,Dependents)

    disp("      *** MODULE: ReportErrors ***");
    testNum=20;
    
    % results sample for testing
    %Classifier=Classifier(end-testNum:end,:)
    %Predict=Predict(end-testNum:end,:)
    
    % show data where Known class <> prediction
    indError = Classifier~=Predict;    
    
    errPred = horzcat(Dependents(indError,:), ...
        array2table(Classifier(indError,:),'VariableNames',{'Known'}), ...
        array2table(Predict(indError,:),'VariableNames',{'Predict'} ));
    
     % write out to a file
    fileDate=string(datetime('now','TimeZone','local'),"yyyy-MM-dd_HHmmSSS");
    outputFile= "DTerrPredictions" + fileDate + ".xlsx";
    disp("Prediction Errors File: " + outputFile);
    writetable(errPred,outputFile); 
end
