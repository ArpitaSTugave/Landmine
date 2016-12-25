%% generate ROC plots

clc
close all
clear all

file_name1 = 'HOGLPQ_score.mat';
file_name2 = 'HOGLPQLESH_score.mat';
file_name3 = 'HOGLESH_score.mat';
file_name4 = 'HOGLBP_score.mat';
% file_name1 = 'WLD_score.mat';
% file_name2 = 'LESH_score.mat';
% file_name3 = 'GRABULBP_score.mat';
% file_name4 = 'LBP_windows_score.mat';
% file_name5 = 'LPQ_score.mat';
% file_name6 = 'HOG_score.mat';
step = 0.05;
[GAR1, FAR1, ProbG1, ProbI1, score1] = ROCfunction(file_name1, step);
[GAR2, FAR2, ProbG2, ProbI2, score2] = ROCfunction(file_name2, step);
[GAR3, FAR3, ProbG3, ProbI3, score3] = ROCfunction(file_name3, step);
[GAR4, FAR4, ProbG4, ProbI4, score4] = ROCfunction(file_name4, step);
% [GAR5, FAR5, ProbG5, ProbI5, score5] = ROCfunction(file_name5, step);
% [GAR6, FAR6, ProbG6, ProbI6, score6] = ROCfunction(file_name6, step);

%% plot ROC

figure,
set(gca,'fontsize',30)
plot(FAR1.*100/(max(FAR1)),GAR1.*100/(max(GAR1)),'-dr','LineSmoothing','on');
hold on
plot(FAR2.*100/(max(FAR2)),GAR2.*100/(max(GAR2)),'-.m*','LineSmoothing','on');
plot(FAR3.*100/(max(FAR3)),GAR3.*100/(max(GAR3)),'--bo','LineSmoothing','on');
plot(FAR4.*100/(max(FAR4)),GAR4.*100/(max(GAR4)),'-.og','LineSmoothing','on');
% plot(FAR5.*100/(max(FAR5)),GAR5.*100/(max(GAR5)),':sc','LineSmoothing','on');
% plot(FAR6.*100/(max(FAR6)),GAR6.*100/(max(GAR6)),'--.k','LineSmoothing','on');
xlabel('FAR','FontSize', 20) % x-axis label
ylabel('GAR','FontSize', 20) % y-axis label
% legend('HOG&LPQ','HOG,LPQ&LESH','HOG&LESH','Location','SouthEast')
h_legend = legend('HOG & LPQ','HOG, LPQ & LESH','HOG & LESH','HOG & LBP','Location','SouthEast')
set(h_legend,'FontSize',20);
axis([0 100 0 100])
hold off

%% plot genuine and imposter probabilities wrt distance scores

% if(step<1)
% step_size = 1;
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
% plot(x1,y1,':s','Color', green1,'LineSmoothing','on');
% hold on
% y = ProbI1(1:step_size:end);
% y1 = spline(x,y,x1);
% plot(x1,y1,':s','Color', orange1,'LineSmoothing','on');
% %2nd
% x = score2(1:step_size:end);
% y = ProbG2(1:step_size:end);
% [la,~] = size(score2);
% x1 = score2(1:0.1:end);
% y1 = spline(x,y,x1);
% plot(x1,y1,'--o','Color', green2,'LineSmoothing','on');
% y = ProbI2(1:step_size:end);
% y1 = spline(x,y,x1);
% plot(x1,y1,'--o','Color', orange2,'LineSmoothing','on');
% %3rd
% x = score3(1:step_size:end);
% y = ProbG3(1:step_size:end);
% [la,~] = size(score3);
% x1 = score3(1:0.1:end);
% y1 = spline(x,y,x1);
% plot(x1,y1,'-.*','Color', green3,'LineSmoothing','on');
% y = ProbI3(1:step_size:end);
% y1 = spline(x,y,x1);
% plot(x1,y1,'-.*','Color', orange3,'LineSmoothing','on');
% %end
% hold off
% len1 = [min(ProbG1) min(ProbI1) min(ProbG2) min(ProbI2) min(ProbG3) min(ProbI3)];
% len1 = max(len1);
% len2 = [max(ProbG1) max(ProbI1) max(ProbG2) max(ProbI2) max(ProbG3) max(ProbI3)];
% len2 = max(len2);
% %axis([Minimum Maximum len1 len2])
% title('Genuine and imposter probablities vs scores')
% xlabel('scores') % x-axis label
% ylabel('probability density') % y-axis label
% legend('HOG&LPQ genuine scores','HOG&LPQ imposter scores','HOG,LPQ&LESH genuine scores','HOG,LPQ&LESH imposter scores',...
%     'HOG&LESH genuine scores','HOG&LESH imposter scores')
% % legend('HOG genuine scores','HOG imposter scores','LPQ genuine scores','LPQ imposter scores',...
% %     'LESH genuine scores','LESH imposter scores')