function Features = extract_features(Alarms_info, params )
%EXTRACT_FEATURES Summary of this function goes here
%   Detailed explanation goes here

% Explanantion of all the variables used in this function
% params : contains an array(bkgd_frames) indicating which frames are going to be processed
% features : struct having numel(Alarms_info) elements where each element has 2 fields - feature name and feature vector
% sig : contains signature information of all the alarms
% sig.GPR : contains the 3-D matrix of data points that need to be analysed to find a landmine
% sig.rel_ch : contains the channel/frame of interest (probably obtained from the PreScreener)
% feature_set : temporary variable that stores the feature vector generated after applying the suitable feature extraction algorithm

    import Extractors.LBPW.*;
    
    for i = 1:numel(Alarms_info)
        Features(i).names = {'LBP'};

        sig = tuf.get_signature(Alarms_info(i));
        if (isfield(sig, 'channel_index') && sig.channel_index == 3)
            feature_set = lbp(double(squeeze(sig.GPR(:, params.bkgd_frames, sig.rel_ch))));
        else
            feature_set = lbp(double(squeeze(sig.GPR(:, sig.rel_ch, params.bkgd_frames)))); % Looking at one channel (given by sig.rel_ch) in all the frames 
        end
        Features(i).vector = feature_set;
    end

str1_1 = '\\ece-bmll-file.ad.ufl.edu\users$\arpita123\Documents\Arpita\TUF\hmds_millbrook_tuf\extracted_features\LBP_windows'; 
D1 = dir([str1_1, '\*.mat']);
num = length(D1(not([D1.isdir])));

str1_2 = '\Feature_set_';
str1_3 = int2str(num + 1);
str1_4 = '.mat';
str1 = strcat(str1_1, str1_2, str1_3, str1_4);
save(str1, 'Features');

end
