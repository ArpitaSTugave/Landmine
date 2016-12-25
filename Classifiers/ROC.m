%% generate ROC plots

clc
close all
clear all

foldername = '\\ece-bmll-file.ad.ufl.edu\research\UF_Users\Arpita\LandMine\Classifiers\';

file_name1 = 'LESHULBP_score.mat';
step = 0.1;
[GAR1, FAR1,~] = ROCfunctionLESHULBP(file_name1, step);

cd(foldername);

file_name2 = 'HOG_score.mat';
step = 0.4;
[GAR2, FAR2, ~] = ROCfunctionHOG(file_name2, step);

cd(foldername);

file_name3 = 'WLD_score.mat';
step = 10;
[GAR3, FAR3, ~] = ROCfunctionWLD(file_name3, step);

cd(foldername);

file_name4 = 'LPQ_score.mat';
step = 0.1;
[GAR4, FAR4, ~] = ROCfunctionLPQ(file_name4, step);

cd(foldername);

file_name5 = 'LESH_score.mat';
step = 0.00004;
[GAR5, FAR5, ~] = ROCfunctionLESH(file_name5, step);

cd(foldername);

file_name6 = 'ULBP_score.mat';
step = 0.1;
[GAR6, FAR6, ~] = ROCfunctionULBP(file_name6, step);

cd(foldername);

file_name7 = 'LBPW_score.mat';
step = 0.1;
[GAR7, FAR7, ~] = ROCfunctionLBP(file_name7, step);

cd(foldername);

file_name8 = 'GRABULBP_score.mat';
step = 0.1;
[GAR8, FAR8, ~] = ROCfunctionGRABULBP(file_name8, step);

cd(foldername);

%% plot ROC

orange1 = [1 0 0]*0.8;
orange2 = [1 0.4 0.4];
orange3 = [1 0.8 0.8];
green1 = [0 1 0]*0.8;
green2 = [0.4 1 0.4];
green3 = [0.8 1 0.8];
color1 = [0 0 1];
color2 = [0.5 0 0.9];
color3 = [0.5 0.5 1];

figure,
plot(FAR1.*100/(max(FAR1)),GAR1.*100/(max(GAR1)),':bs','LineSmoothing','on');
hold on
plot(FAR2.*100/(max(FAR1)),GAR2.*100/(max(GAR1)),':rs','LineSmoothing','on');
plot(FAR3.*100/(max(FAR1)),GAR3.*100/(max(GAR1)),':gs','LineSmoothing','on');
plot(FAR4.*100/(max(FAR1)),GAR4.*100/(max(GAR1)),':ks','LineSmoothing','on');
plot(FAR5.*100/(max(FAR1)),GAR5.*100/(max(GAR1)),':bs','LineSmoothing','on');
plot(FAR6.*100/(max(FAR1)),GAR6.*100/(max(GAR1)),':cs','LineSmoothing','on');
plot(FAR7.*100/(max(FAR1)),GAR7.*100/(max(GAR1)),':ms','LineSmoothing','on');
plot(FAR8.*100/(max(FAR1)),GAR8.*100/(max(GAR1)),':ys','LineSmoothing','on');
title('Receiver Operating Characteristic')
xlabel('FAR') % x-axis label
ylabel('GAR') % y-axis label
legend('HOG','Location','SouthEast')
axis([0 100 0 100])
hold off

%% plot genuine and imposter probabilities wrt distance scores

% if(step<1)
% step_size = 2;
% else
% step_size = 1;
% end
% figure,
% %1st
% x = score1(1:step_size:end);
% y = ProbG1(1:step_size:end);
% [la,~] = size(score1);
% x1 = score1(1:0.1:end);
% y1 = spline(x,y,x1);
% plot(x1,y1,'--*','Color', green1,'LineSmoothing','on');
% hold on
% y = ProbI1(1:step_size:end);
% y1 = spline(x,y,x1);
% plot(x1,y1,'-.o','Color', orange1,'LineSmoothing','on');
% %end
% hold off
% len1 = [min(ProbG1) min(ProbI1)];
% len1 = max(len1);
% len2 = [max(ProbG1) max(ProbI1)];
% len2 = max(len2);
% xlabel('scores') % x-axis label
% ylabel('probability density') % y-axis label
% legend('LESH+ULBP genuine scores','LESH+ULBP imposter scores','Location','NorthWest')