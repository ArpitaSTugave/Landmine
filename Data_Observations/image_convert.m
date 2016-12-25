clc
close all
clear all

destination_folder = '\\ece-bmll-file.ad.ufl.edu\research\UF_Users\Arpita\LandMine\Data_Observations\Input_images_MPG\';
source_folder = '\\ece-bmll-file.ad.ufl.edu\research\UF_Users\Arpita\LandMine\Features\Input_images_MPG\';

xls_name = 'Truth values.xlsx';
truth_data = [];
truth_data = xlsread(xls_name);
[m,~]=size(truth_data);

for i=1:1:m
    file_name = strcat(source_folder,'Input_',int2str(i));
    a = load(file_name);
    if truth_data(i,:) == 0
        save_folder = strcat(destination_folder,'0\Input_',int2str(i),'.jpg');
        imwrite(a.input,save_folder);
    else
        save_folder = strcat(destination_folder,'1\Input_',int2str(i),'.jpg');
        imwrite(a.input,save_folder);
    end
end
