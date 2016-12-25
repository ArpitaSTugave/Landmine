function [GAR, FAR, ProbG, ProbI, score] = ROCfunctionULBP(file_name, step)

truth_data = [];
str1 = strcat(file_name);
data = load(str1);
data = data.Ouput_Score_all(:,2);

%% genuine and imposter scores

%% Read all the feature sets
fusion = 0; %enables fusion if 1
features_matrix = [];
truth_data = [];

if fusion == 0
    
    file_name = '\\ece-bmll-file.ad.ufl.edu\research\UF_Users\Arpita\LandMine\NewData\Feature Extractors\ULBP\MH\';
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
        truthFolders = strcat(file_name1 , Folders(k).name);
        files = dir(subFolders);
        for file = files'
            if file.name(1) == '.'
                continue;
            end
            cd(subFolders);
            temp = load(file.name);
            temp_new1 = (temp.feature.vector);
                     
            cd(truthFolders);
            temp = load(file.name);
            temp_new = temp.feature.HIT;
            if(size(temp_new1,2) == 56050)
            truth_data = [temp_new ; truth_data];
            end
            
            cd(file_name);
        end
    end
    
   truth_data = truth_data(1:size(data,1),:);

genuine = [];
imposter = [];

for i=1:1:size(data,1)
    if truth_data(i,:) == 0
        genuine = [data(i,:) genuine];
    elseif truth_data(i,:) == 1
        imposter = [data(i,:) imposter];
    end
end

% find range of array data of distances
Maximum = max(data); %find maximum value in data
Minimum = min(data); %find minimum value in data
count = 1;  
[~,gl] = size(genuine); %genuine matrix length
[~,il] = size(imposter); %imposter matrix length
first = Minimum;

% find imposter and genuine probability
for i = Minimum:step:Maximum
    % total number of distance scores in the particular range
    s = sum(abs(first-genuine) <= step );
    %genuine probablity
    ProbG(count,1) = s/gl;
    s = sum(abs(first-imposter) <= step );
    %imposter probablity
    ProbI(count,1) = s/il;
    score(count,1) = first;
    % calculate GAR, using area under the curve
    GAR(count,1) = sum(ProbG*step);
    % calculate FAR, using area under the curve
    FAR(count,1) = sum(ProbI*step);
    first = first + step;
    count = count + 1;
end

end