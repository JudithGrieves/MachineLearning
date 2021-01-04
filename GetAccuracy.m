%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Module to return accuracy values from a set of known and 
% predicted classifier values.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Judith Grieves
% Date:     27 October 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function AccMatrix=GetAccuracy(TrueClass,Predictions)
    disp("   **** MODULE: GetAccuracy ***");  
    cMatrix=confusionmat(TrueClass,Predictions);
    TP=cMatrix(2,2);
    TN=cMatrix(1,1);
    FP=cMatrix(1,2);
    FN=cMatrix(2,1);
    accuracy = (TP + TN) / (TP + TN + FP + FN);
    AccMatrix = [accuracy*100 TP TN FP FN  ] ;
end    