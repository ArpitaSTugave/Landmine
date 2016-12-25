%% clean up

clc
close all
clear all

%% code:
source_folder = '\\ece-bmll-file.ad.ufl.edu\research\UF_Users\Arpita\LandMine\Classifier_results\MPGSept2005\';
folder=strcat(source_folder,'HOGLBP_label.mat.mat');
true_labels = load(folder);
final_labels = true_labels.Output_Labels_all;

xls_name = 'Truth values.xlsx';
truth_data = [];
truth_data = xlsread(xls_name);
truth_data = truth_data(1:1790,:);
[m,~]=size(truth_data);
n = m/10;

percentage = [];
for i = 1:n:m
    truth_data_cf = truth_data(i:i+n-1,:);
    final_labels_cf = final_labels(i:i+n-1,:);
    percentage = [(n-sum(abs(truth_data_cf - final_labels_cf)))*100/n percentage];
end

std(percentage)
    