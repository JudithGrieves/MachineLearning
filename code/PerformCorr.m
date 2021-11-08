%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Module to create & display a correlation table from the Coded data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Judith Grieves
% Date:     27 October 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
function PerformCorr(FilePrefix,InputDataCoded)

    disp("**** MODULE: PerformCorr ***");
    InputDataMat=str2double(table2array(InputDataCoded));
    
    disp ("   ***** number of records: " + size(InputDataMat,1)); 
    InputDataMat(1:5,:);

    %% calculate correlation between each variable pair
    CorrMatrix = corrcoef(InputDataMat);
    CorrList=[];
    
    % flatten the correlation matrix
    max = size(InputDataMat,2);
    row = 1;
    for i = 1 : max
        for j = 1 : max
            if lt(i,j) % ignore i:i correlation and j:i
                CorrList(row,1) = i ;
                CorrList(row,2) = j ;
                CorrList(row,3) =  CorrMatrix(i,j);
                row=row+1;
            end
        end
    end
    
    % add a column of absolute correlation and sort
    CorrList(:,4)=abs(CorrList(:,3)); 
    [~,Corridx] = sort(CorrList(:,4),'descend'); 
    CorrList = CorrList(Corridx,:);
    
    %% add column names to CorrList
    InputDataCoded.Properties.VariableNames{1};
    for i=1:size(CorrList,1)
        colNames{i,1}=InputDataCoded.Properties.VariableNames{CorrList(i,1)};        
        colNames{i,2}=InputDataCoded.Properties.VariableNames{CorrList(i,2)};        
    end
    TcorrList=horzcat(array2table(colNames,'VariableNames',{'var1','var2'})...
        ,array2table(CorrList,'VariableNames',{'var1Col','var2Col','CorrCoeff','AbsCorrCoeff'}));
    
    disp("   ***** Write correlation data to CSV");
    OutputFileName=  FilePrefix + "-corr.csv";                      % output file name
    disp("   ***** Output File: " + OutputFileName);                % display the output file
    writetable(TcorrList,OutputFileName); 
    
end
