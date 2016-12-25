clc;
clear;

%% Read all the feature sets
fusion = 0; %enables fusion if 1
features_matrix = [];
truth_data = [];

if fusion == 0
    
    
    file_name = '\\ece-bmll-file.ad.ufl.edu\research\UF_Users\Arpita\LandMine\NewData\Feature Extractors\HOG\MH\';
    %file_name2 = '\\ece-bmll-file.ad.ufl.edu\research\UF_Users\Arpita\LandMine\NewData\Feature Extractors\LESH\MH\';
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
        %subFolders2 = strcat(file_name2 , Folders(k).name);
        truthFolders = strcat(file_name1 , Folders(k).name);
        files = dir(subFolders);
        for file = files'
            if file.name(1) == '.'
                continue;
            end
            cd(subFolders);
            temp = load(file.name);
            temp_new1 = (temp.feature.vector)';
            if(size(temp_new1,2) == 80)
                features_matrix = [temp_new1 ; features_matrix];
            end
            
            
            cd(truthFolders);
            temp = load(file.name);
            temp_new = temp.feature.HIT;
            if(size(temp_new1,2) == 80)
            truth_data = [temp_new ; truth_data];
            end
            cd(file_name);
        end
    end
    


%% Dividing the data into training and testing data (10 fold cross-validation) kick.

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
    
    Training_data_truth_vals = Training_data_truth_vals';
    Testing_data_truth_vals = Testing_data_truth_vals';
    
    % Training the GRNN classifier using the MATLAB function
    net = newgrnn(Training_data, Training_data_truth_vals);
    Output_Labels = sim(net, Testing_data);
    Output_Labels_all = [Output_Labels_all; Output_Labels];

    % Calculating the prediction rates of each cross validation fold
    prediction_percent = (sum(round(Output_Labels) == Testing_data_truth_vals)) / (n/num_folds);
    prediction_array(i1, 1) = prediction_percent * 100;   
end

avg_prediction_val = sum(prediction_array) / num_folds

cd('\\ece-bmll-file.ad.ufl.edu\research\UF_Users\Arpita\LandMine\Classifiers\');
confmatrix = cfmatrix2(truth_data, Output_Labels_all(:));

        %% save values
        cd('\\ece-bmll-file.ad.ufl.edu\research\UF_Users\Arpita\LandMine\NewData\results');
        str1_2 = 'GRNNLESHULPB';
        str1_3 = '_label.mat';
        str1 = strcat(str1_2, str1_3);
        save(str1, 'Output_Labels_all');
end