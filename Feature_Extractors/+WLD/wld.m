%% Weber Local Descriptor (WLD)

function WLD_feature_vector = wld(input)

%% Reading the input frame 
% I = imread('\\ece-bmll-file.ad.ufl.edu\users$\sushanth1992\Desktop\images.jpg');

I = input;
if (numel(size(I)) == 3)
    I = rgb2gray(I);
end


%% Defining the filters

f1 = [1 1 1;1 -8 1;1 1 1];
f2 = [0 0 0;0 1 0;0 0 0];
f3 = [1 2 1;0 0 0;-1 -2 -1];
f4 = [1 0 -1;2 0 -2;1 0 -1];

%% Computing the differential excitations

v1 = conv2(double(I), f1);
v2 = conv2(double(I), f2);

alpha = atan(v1./v2);

%% Computing the differential orientations

v3 = conv2(double(I), f3);
v4 = conv2(double(I), f4);

theta = atan(v3./v4) * 180/pi;

theta_new = zeros(size(theta, 1), size(theta, 2));
for i = 1:size(theta, 1)
    for j = 1:size(theta, 2)
        if (v3(i, j) > 0 && v4(i, j) > 0)
            theta_new(i, j) = theta(i, j);
        else if (v3(i, j) < 0 && v4(i, j) > 0)
                theta_new(i, j) = theta(i, j) + 180;
            else if (v3(i, j) < 0 && v4(i, j) < 0)
                    theta_new(i, j) = theta(i, j) + 180;
                else if (v3(i, j) > 0 && v4(i, j) < 0)
                        theta_new(i, j) = theta(i, j) + 360;
                    end
                end
            end
        end
    end 
end

T2 = 8;   % No. of dominant orientations
for i1 = 1:size(theta_new, 1)
    for j1 = 1:size(theta_new, 2)
        t = mod(floor(theta_new(i1, j1)/(2*pi/T2) + 0.5), T2);
        theta_new(i1, j1) = (2*t*pi)/T2;
    end
end

%% Construct a 2-D histogram of the dominant orientations and dominant excitations

hist_data = [alpha(:), theta_new(:)];
[h, ~] = hist3(hist_data, [10, T2]);
WLD_feature_vector = h(:);
end




        







