% Local Binary Patterns (3 * 3 window) (Local Function implementation)
function feature_vector = lbp(input)
    
    [m, n] = size(input);
    encoded_data = zeros(m, n);
    for i = 1:m-2
        for j = 1:n-2
            temp_data = input(i:i+2, j:j+2);
            centre = temp_data(2, 2);
            encoded_val = (temp_data(1, 1) > centre) + ((temp_data(1, 2) > centre) * 2) + ((temp_data(1, 3) > centre) * 4) + ...
                            ((temp_data(2, 1) > centre) * 8) + ((temp_data(2, 3) > centre) * 16) + ((temp_data(3, 1) > centre) * 32) + ...
                            ((temp_data(3, 2) > centre) * 64) + ((temp_data(3, 3) > centre) * 128);

            encoded_data(i, j) = encoded_val;
        end;
    end;

    Wx = 5;
    Wy = 5;
    numBins = 20;
    feature_vec = [];
    for x = 1:Wx:m
        for y = 1:Wy:n
            block = encoded_data(x:x+Wx-1, y:y+Wy-1);
            [f, ~] = hist(block(:), numBins);
            feature_vec = [feature_vec f];
        end
    end
    feature_vector = feature_vec';
end