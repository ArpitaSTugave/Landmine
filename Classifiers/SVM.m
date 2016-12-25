%% Training an SMV classfier and testing the effectiveness of the feature extractor

clc;
clear;

%% Read all the feature sets
fusion = 0; %enables fusion if 1
features_matrix = [];
truth_data = [];

if fusion == 0
    
    file_name = '\\ece-bmll-file.ad.ufl.edu\research\UF_Users\Arpita\LandMine\NewData\Feature Extractors\ULBP\MH\';
    file_name2 = '\\ece-bmll-file.ad.ufl.edu\research\UF_Users\Arpita\LandMine\NewData\Feature Extractors\LESH\MH\';
    file_name1 = '\\ece-bmll-file.ad.ufl.edu\research\UF_Users\Arpita\LandMine\NewData\hit_info\HIT_info_only_GRABLBP\MH\';
    files = dir(file_name);
    dirFlags = [files.isdir];
    Folders = files(dirFlags);
    % Print folder names to command window.

    dir_names = [];
    for k = 1 : length(Folders)
    %for k = 1 : 4
        if Folders(k).name(1) == '.'
            continue;
        end
        subFolders = strcat(file_name , Folders(k).name);
        subFolders2 = strcat(file_name2 , Folders(k).name);
        truthFolders = strcat(file_name1 , Folders(k).name);
        files = dir(subFolders);
        for file = files'
            if file.name(1) == '.'
                continue;
            end
            cd(subFolders);
            temp = load(file.name);
            temp_new1 = (temp.feature.vector);
            if(size(temp_new1,2) == 56050)
            features_matrix1 = temp_new1/norm(temp_new1,Inf);
            end
            
            cd(subFolders2);
            temp = load(file.name);
            temp_new2 = (temp.feature.vector)';
            if(size(temp_new2,2) == 96)
            features_matrix2 = temp_new2/norm(temp_new2,Inf);
            end
            
            cd(truthFolders);
            temp = load(file.name);
            temp_new = temp.feature.HIT;
            if(size(temp_new1,2) == 56050 && size(temp_new2,2) == 96)
            truth_data = [temp_new ; truth_data];
            features = [features_matrix1 features_matrix2];
            features_matrix = [features ; features_matrix];
            end
            
            cd(file_name);
        end
    end
    


        %% Dividing the data into training and testing data (10 fold cross-validation)

        num_folds = 10;
        [m, n] = size(features_matrix);
        limit = floor(m/10)*10;
        truth_data = truth_data(1:limit,:);
        features_matrix = features_matrix(1:limit,:)';
        [m, n] = size(features_matrix);

        C1 = mat2cell(features_matrix, m , [n/num_folds n/num_folds n/num_folds n/num_folds n/num_folds...
            n/num_folds n/num_folds n/num_folds n/num_folds n/num_folds]);
        C2 = mat2cell(truth_data, [n/num_folds n/num_folds n/num_folds n/num_folds n/num_folds...
            n/num_folds n/num_folds n/num_folds n/num_folds n/num_folds],1);

        prediction_array = zeros(10, 1);
        Output_Labels_all = [];
        Ouput_Score_all = [];
        Output_Cost_all = [];

        for i1 = 1:num_folds
            Testing_data = C1{1, i1};
            Testing_data_truth_vals = C2{i1, 1}; 

            Training_data = [];
            Training_data_truth_vals = [];
            Training_array = 1:num_folds;
            Training_array = Training_array(Training_array ~= i1);

            for j1 = 1:numel(Training_array)
                temp2 = C1{1, Training_array(j1)};
                temp3 = C2{Training_array(j1), 1};
                Training_data = [Training_data temp2];
                Training_data_truth_vals = [Training_data_truth_vals; temp3];
            end

            Training_data = Training_data';
            Testing_data = Testing_data';

            % Training the SVM classifier
            %SVMModel = fitcsvm(Training_data, Training_data_truth_vals, 'KernelFunction', 'RBF'); 
            SVMModel = fitcsvm(Training_data, Training_data_truth_vals, 'KernelFunction', 'linear');
            [Output_Labels, Output_Score, Output_Cost] = predict(SVMModel, Testing_data);
            Output_Labels_all = [Output_Labels_all; Output_Labels];
            Ouput_Score_all = [Ouput_Score_all; Output_Score];
            Output_Cost_all = [Output_Cost_all; Output_Cost];

            % Calculating the prediction rates for each cross validation folds
            prediction_percent = (sum(Output_Labels == Testing_data_truth_vals)) / (n/num_folds);
            prediction_array(i1, 1) = prediction_percent * 100;   
        end

        avg_prediction_val = sum(prediction_array) / num_folds
    
        cd('\\ece-bmll-file.ad.ufl.edu\research\UF_Users\Arpita\LandMine\Classifiers\');
        confmatrix = cfmatrix2(truth_data, Output_Labels_all);
        
        %% save values
        cd('\\ece-bmll-file.ad.ufl.edu\research\UF_Users\Arpita\LandMine\NewData\results');
        str1_2 = 'LESHULBP';
        str1_3 = '_label.mat';
        str1 = strcat(str1_2, str1_3);
        save(str1, 'Output_Labels_all');
        
        str1_3 = '_score.mat';
        str1 = strcat(str1_2, str1_3);
        save(str1, 'Ouput_Score_all');
        
        str1_3 = '_cost.mat';
        str1 = strcat(str1_2, str1_3);
        save(str1, 'Output_Cost_all');
end
%     
%     
%  %% if fusion enabled   
% else
%     
%     %% append feature vectors of all the folders
%     dir_names = [];
%     complete_features = [];
%     for k = 1 : length(subFolders)
%         if subFolders(k).name(1) == '.'
%             continue;
%         end
%         str1_1 = strcat(file_name , subFolders(k).name);
%         subFolders(k).name
% 
%         D = dir([str1_1, '\*.mat']);
%         num = length(D(not([D.isdir])));
%         features_matrix = [];
% 
%         for i = 1:num
%             str1_2 = '\Feature_set_';
%             str1_3 = int2str(i);
%             str1_4 = '.mat';
%             str1 = strcat(str1_1, str1_2, str1_3, str1_4);
%             data = load(str1);
%             if isfield(data,'Features')
%                 features_all = data.Features;   
%             else
%                 features_all = data.features;
%             end
%             features_all_num_elements = numel(features_all);
% 
%             for j = 1:features_all_num_elements
%                 temp = features_all(j).vector;
%                 [p,q] = size(temp);
%                 if q==1
%                     temp = temp';
%                 end
%                 features_matrix = [features_matrix; temp];
%             end           
%         end
%         
%         complete_features = [complete_features features_matrix ];
%         
%     end
% 
%     truth_data = [];
%     xls_name = strcat(file_name,'Truth values.xlsx');
%     truth_data = xlsread(xls_name);
%     
%     %% Dividing the data into training and testing data (10 fold cross-validation)
%     
%     num_folds = 10;
%     [m, n] = size(complete_features);
%     limit = floor(m/10)*10;
%     truth_data = truth_data(1:limit,:);
%     complete_features = complete_features(1:limit,:)';
%     [m, n] = size(complete_features);
%     
%     C1 = mat2cell(complete_features, m , [n/num_folds n/num_folds n/num_folds n/num_folds n/num_folds...
%         n/num_folds n/num_folds n/num_folds n/num_folds n/num_folds]);
%     C2 = mat2cell(truth_data, [n/num_folds n/num_folds n/num_folds n/num_folds n/num_folds...
%         n/num_folds n/num_folds n/num_folds n/num_folds n/num_folds],1);
%     
%     prediction_array = zeros(10, 1);
%     Output_Labels_all = [];
%     Ouput_Score_all = [];
%     Output_Cost_all = [];
%     
%     for i1 = 1:num_folds
%         Testing_data = C1{1, i1};
%         Testing_data_truth_vals = C2{i1, 1};
%         
%         Training_data = [];
%         Training_data_truth_vals = [];
%         Training_array = 1:num_folds;
%         Training_array = Training_array(Training_array ~= i1);
%         
%         for j1 = 1:numel(Training_array)
%             temp2 = C1{1, Training_array(j1)};
%             temp3 = C2{Training_array(j1), 1};
%             Training_data = [Training_data temp2];
%             Training_data_truth_vals = [Training_data_truth_vals; temp3];
%         end
%         
%         Training_data = Training_data';
%         Testing_data = Testing_data';
%         
%         % Training the SVM classifier
%         %SVMModel = fitcsvm(Training_data, Training_data_truth_vals, 'KernelFunction', 'RBF');
%         SVMModel = fitcsvm(Training_data, Training_data_truth_vals, 'KernelFunction', 'linear');
%         [Output_Labels, Output_Score, Output_Cost] = predict(SVMModel, Testing_data);
%         Output_Labels_all = [Output_Labels_all; Output_Labels];
%         Ouput_Score_all = [Ouput_Score_all; Output_Score];
%         Output_Cost_all = [Output_Cost_all; Output_Cost];
%         
%         % Calculating the prediction rates for each cross validation folds
%         prediction_percent = (sum(Output_Labels == Testing_data_truth_vals)) / (n/num_folds);
%         prediction_array(i1, 1) = prediction_percent * 100;
%     end
%     
%     avg_prediction_val = sum(prediction_array) / num_folds
%     
%     confmatrix = cfmatrix2(truth_data, Output_Labels_all);
%     
%     %% save values
%     str1_1 = '\\ece-bmll-file.ad.ufl.edu\research\UF_Users\Arpita\LandMine\Classifier_results\MPGSept2005\';
%     str1_2 = 'HOGLBPLPQ';
%     str1_3 = '_label.mat';
%     str1 = strcat(str1_1, str1_2, str1_3, str1_4);
%     save(str1, 'Output_Labels_all');
%     
%     str1_3 = '_score.mat';
%     str1 = strcat(str1_1, str1_2, str1_3, str1_4);
%     save(str1, 'Ouput_Score_all');
%     
%     str1_3 = '_cost.mat';
%     str1 = strcat(str1_1, str1_2, str1_3, str1_4);
%     save(str1, 'Output_Cost_all');
%     
% end