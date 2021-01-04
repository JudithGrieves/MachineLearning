%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to code any non-numeric columns in the input data
% Data coded as numeric can be stored in a matrix and is more convenient
% for ML algorithms to process.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Judith Grieves
% Date:     27 October 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function InputDataCoded=CodeValues(InputData)

    disp("***** MODULE: CodeValues ***");
    disp("   ***** Code the data to numeric values")
    
    % parameter to show which column need numeric coding
    CodeColumns=[0 1 1 0 1 1 1 0 0 1 1 1 1 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0];     
    InputDataCoded = InputData; % create a new coded table
    InputData.Properties.VariableNames; % show column names from file
    InputDataCoded.Properties.VariableNames; % show column names from file

    %% convert inputData to an array of strings
    InputDataCoded(1:5,:); % debug
    InputDataCoded=table2array(InputDataCoded); % InputDataCoded is the new working table *****
    InputDataCoded(1:5,:); % debug
    
    %% dynamically create the lookup tables column_lookup and value_lookup
    disp("   ***** Create lookup tables")
    % columns to code
    value_lookup_ind=1;
    for column_num=1:size(InputData.Properties.VariableNames,2) % for each column variable
        column_str=num2str(column_num); % debug
        InputData.Properties.VariableNames(column_num); % show column names from file
        
        % create column_lookup, a table of each column in the dataset, numbered.
        column_lookup(column_num,:)={column_str InputData.Properties.VariableNames{column_num}};
        
        if CodeColumns(column_num)
            i=0; % initialise coded value
            value_list = unique(InputDataCoded(:,column_num)); % show distinct values of each column
            for column_value=1:size(value_list) % each distinct column value 
                %disp({column_str value_list{column_value} num2str(i)}); % debug - the new entry to write
                % create value_lookup, a table of the find/replace strings to use for coding
                value_lookup(value_lookup_ind,:)={column_str value_list{column_value} num2str(i)};
                i=i+1;
                value_lookup_ind=value_lookup_ind+1;
            end % for column_value
        end % if 
    end % for column_num
    
    column_lookup; % number and name of variable columns
    value_lookup;   % column# text_value coded_value

    %% 
    lookup=value_lookup;
    disp("   ***** Find and replace")
    findIndex=[unique(str2double(value_lookup(:,1)))]';
    for col = findIndex                                     % for each column number in lookup table
        col; % debug
        colStr=num2str(col);
        index = find(strcmp(value_lookup(:,1), colStr));    % find lookup rows for current column#
        lookup_curr=value_lookup(index,:) ;                 % lookup subset for current column#
        find_str=lookup_curr(:,2);                          % string to search for
        replace_str=lookup_curr(:,3);                       % string to replace with
        for lookup_entry = 1:size(find_str,1)               % do find/replace for each lookup entry
            lookup_entry; % debug
            find_whole_word= strcat('\<' ,find_str{lookup_entry},'\>');
            InputDataCoded(:,col)=regexprep(InputDataCoded(:,col), find_whole_word, replace_str(lookup_entry));;

        end;
        unique(InputDataCoded(:,col));                      % show valid values for column 'col'
    end % for col
    
    InputDataCoded=array2table(InputDataCoded);             %convert back to table    
    InputDataCoded.Properties.VariableNames=InputData.Properties.VariableNames; % reset headers
    
    InputDataCoded(1:5,:);                                  % show top 5
    
    % debug - check the new valid values
    for i=1:size(InputDataCoded,2)
        unique(InputDataCoded(:,i));
    end
    
    disp("   ***** Table size: " + num2str(size(InputDataCoded))) % show the new table size
end