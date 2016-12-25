%% group the images into correctly classified or unclassified rock and mine data
% here 1 is the rock data
% and 0 is the mine data

clc;
close all;
clear all;

%% code:

true_labels = load('HOGLPQ_label.mat.mat');
true_labels = true_labels.Output_Labels_all;
%rock folder is 1
rock_folder = '\\ece-bmll-file.ad.ufl.edu\research\UF_Users\Arpita\LandMine\Data_Observations\Input_images_MPG\1\';
%mine folder is 0
mine_folder = '\\ece-bmll-file.ad.ufl.edu\research\UF_Users\Arpita\LandMine\Data_Observations\Input_images_MPG\0\';
copy_folder = '\\ece-bmll-file.ad.ufl.edu\research\UF_Users\Arpita\LandMine\Data_Observations\Input_images_MPG\';

cd(rock_folder);
imagefiles = dir('*.jpg');      
nfiles = length(imagefiles);    % Number of files found
for i=1:nfiles
   currentfilename = imagefiles(i).name;
   s = currentfilename(regexp(currentfilename,'_')+1:end);
   r=str2num(strrep(s,'.jpg',''));
   source = strcat(rock_folder,imagefiles(i).name);
   if true_labels(r,:) == 1
       destination = strcat(copy_folder,'correctlyClassified1');
       copyfile(source,destination);
   else
       destination = strcat(copy_folder,'wronglyClassified1');
       copyfile(source,destination);
   end
end

cd(mine_folder);
imagefiles = dir('*.jpg');      
nfiles = length(imagefiles);    % Number of files found
for i=1:nfiles
   currentfilename = imagefiles(i).name;
   s = currentfilename(regexp(currentfilename,'_')+1:end);
   r=str2num(strrep(s,'.jpg',''));
   source = strcat(mine_folder,imagefiles(i).name);
   if true_labels(r,:) == 0
       destination = strcat(copy_folder,'correctlyClassified0');
       copyfile(source,destination);
   else
       destination = strcat(copy_folder,'wronglyClassified0');
       copyfile(source,destination);
   end
end