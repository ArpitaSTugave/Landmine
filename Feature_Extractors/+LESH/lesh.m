%% LESH (Local Energy Based Shape Histogram) feature extractor

function lesh_features = lesh(input)

import Extractors.LESH.*;
imagesc(input,[-0.02 0.02]);
drawnow;
I = input;

[rows, cols] = size(I);
num_sub_regions = 4;
hist_total = [];
rows_val = floor(rows / num_sub_regions);
cols_val = floor(cols / num_sub_regions);

scales = 5;       % Number of scales for the Gabor filter
orientations = 8; % Number of orientations for the Gabor filter

%% Convolving each sub-region with each of the 40 gabor filters

for i = 1:rows_val:rows-rows_val
    for j = 1:cols_val:cols-cols_val
        
        I_sub = I(i:i+rows_val-1, j:j+cols_val-1);
        EO = gaborconvolve(I_sub, scales, orientations, 3, 1.7, 0.65, 1.3);
        mag_comp = cell(scales, orientations);
        orientation_comp = cell(scales, orientations);
        for i1 = 1:scales
            for j1 = 1:orientations
                convolved_image = EO{i1, j1};
                temp1 = real(double(convolved_image));
                temp2 = imag(double(convolved_image));
                mag_comp{i1, j1} = sqrt(temp1.^2 + temp2.^2);
                orientation_comp{i1, j1} = (angle(double(convolved_image)));
            end
        end


        %% Computing the E values for each orientation
        E_vals = cell(orientations, 1);
        for i2 = 1:orientations
            mag_comp_req = mag_comp(:, i2);
            orientation_comp_req = orientation_comp(:, i2);
            mag_sum = 0;
            orientation_sum = 0;

            for j2 = 1:scales
                mag = cell2mat(mag_comp_req(j2, :));
                mag_sum = mag_sum + mag;
                orientation = cell2mat(orientation_comp_req(j2, :));
                orientation_sum = orientation_sum + orientation;
            end
            orientation_avg = orientation_sum ./ scales;

            E = 0;
            for k = 1:scales
                mag = cell2mat(mag_comp_req(k, :));
                orientation = cell2mat(orientation_comp_req(k, :));
                temp_total = mag .* (cos(orientation - orientation_avg) - abs(sin(orientation - orientation_avg))) ;
                temp_total(temp_total < 0) = 0;
                E = E + (temp_total ./ mag_sum);
            end
            E_vals{i2, 1} = E;
        end

        %% Computing the label map 
        L_map = zeros(rows_val, cols_val);
        for p1 = 1:size(E, 1);
            for p2 = 1:size(E, 2)
                pixel_vals = zeros(orientations, 1);
                for i3 = 1:orientations
                    temp = cell2mat(E_vals(i3));
                    pixel_vals(i3, 1) = temp(p1, p2);
                end
                max_val = max(pixel_vals);
                idx_max_val = find(pixel_vals == max_val);
                L_map(p1, p2) = ((idx_max_val(1) - 1) * pi) / orientations;
            end
        end

        %% Computing the histogram
        gauss_filter = fspecial('gaussian', [rows_val, cols_val], 20);
        hist_vector = zeros(orientations, 1);
        for i4 = 1:orientations
            orientation_val = ((i4 - 1) / orientations) * pi;
            temp_L_map = L_map - orientation_val;
            temp_L_map(temp_L_map == 0) = 1;
            temp_L_map(temp_L_map ~= 1) = 0;
            hist_val = sum(sum(gauss_filter .* (E_vals{i4, 1}) .* temp_L_map));
            hist_vector(i4, 1) = hist_val;
        end
        hist_total = [hist_total; hist_vector];
    end
end
%save('\\ece-bmll-file.ad.ufl.edu\users$\sushanth1992\Desktop\lesh_features.mat', 'hist_total');
lesh_features = hist_total;

        
            
    
    
            
    




    
    









          



    