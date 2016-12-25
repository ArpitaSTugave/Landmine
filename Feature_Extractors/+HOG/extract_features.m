function features = extract_features(Alarms_info, params )
%EXTRACT_FEATURES Summary of this function goes here
%   Detailed explanation goes here

% Explanantion of all the variables used in this function
% params : contains an array(bkgd_frames) indicating which frames are going to be processed
% features : struct having numel(Alarms_info) elements where each element has 2 fields - feature name and feature vector
% sig : contains signature information of all the alarms
% sig.GPR : contains the 3-D matrix of data points that need to be analysed to find a landmine
% sig.rel_ch : contains the channel/frame of interest (probably obtained from the PreScreener)
% feature_set : temporary variable that stores the feature vector generated after applying the suitable feature extraction algorithm

    import Extractors.HOG.*;
    
    for i = 1:numel(Alarms_info)
        features(i).names = {'HOG'};

        sig = tuf.get_signature(Alarms_info(i));
        if (isfield(sig, 'channel_index') && sig.channel_index == 3)
            feature_set = hog(double(squeeze(sig.GPR(:, params.bkgd_frames, sig.rel_ch))));
        else
            feature_set = hog(double(squeeze(sig.GPR(:, sig.rel_ch, params.bkgd_frames)))); % Looking at one channel (given by sig.rel_ch) in all the frames 
        end
        features(i).vector = feature_set;
    end
end