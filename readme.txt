Landmine Detection

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Extracting Features from the TUF framework:
++++++++++++++++++++++++++++++++++++++++++
1.	Enter the folder csilab->uf_hmds_demo->+Extractors. Here in every feature extractor subfolder open the file “extract_features.m”. 

2.	After the for loop ends add the following code section:
str1_1 = '\\ece-bmll-file.ad.ufl.edu\users$\sushanth1992\Desktop\Landmine features\MPG Sept 2005\HOG';  % File location will be different
    D1 = dir([str1_1, '\*.mat']);
    num = length(D1(not([D1.isdir])));
    
  str1_2 = '\Feature_set_';
  str1_3 = int2str(num + 1);
    str1_4 = '.mat';
    str1 = strcat(str1_1, str1_2, str1_3, str1_4);
    save(str1, 'Features');

3.	To save the HIT information for all the alarm features, follow these steps:

	a)	Add a breakpoint in any one of the “extract_features.m” file at the following line.
	sig = tuf.get_signature(Alarms_info(i));

	b.	When the debugger pauses the execution of the breakpoint, from the workspace access the variable “Alarms_info”. 
	In this struct save the feature named “HIT” in a mat-file. Repeat this process every time the debugger pauses the execution. 
	(If possible write a script for this. Will save a lot of time and effort.)
	(This process should be done only once, not for all the feature extractors as the HIT info will remain the same for a given dataset)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Running the Classifiers on the extracted features:
++++++++++++++++++++++++++++++++++++++++++++++++++
All the data has been stored in the folder named “Landmine features”. The file structure is as follows:
1.	MPG Sept 2005 – This folder contains features that have been extracted using all the feature extraction algorithms (LBP, HOG, LPQ, LESH, WLD). 
	The features for each extractor has been stored in a separate sub folder. A folder called “Truth values” contains the HIT info of each alarm.
	All the truth values have been consolidated in an excel sheet file called “Truth Values”. This file is sufficient to extract any Alarm HIT information.

2.	Small Millbrook – This folder contains features that have been extracted using all the feature extraction algorithms (LBP, HOG, LPQ, LESH, WLD). 
	The features for each extractor has been stored in a separate sub folder. A folder called “Truth values” contains the HIT info of each alarm. 
	All the truth values have been consolidated in an excel sheet file called “Truth Values”. This file is sufficient to extract any Alarm HIT information.


3.	Tiny Millbrook – This folder contains features that have been extracted using all the feature extraction algorithms (LBP, HOG, LPQ, LESH, WLD). 
	The features for each extractor has been stored in a separate sub folder. A folder called “Truth values” contains the HIT info of each alarm. 
	All the truth values have been consolidated in an excel sheet file called “Truth Values”. This file is sufficient to extract any Alarm HIT information.

4.	Codes – This folder contains all the scripts and functions for obtaining the classification for each extraction algorithm on each dataset. 
	It contains the following files:
===============================================================================================================================================================
a.	Test_code_svm – Used for running the Support Vector Machine classification algorithm on the features. The following changes need to be kept in mind:
--------------------------------------------------------------------------------------------------------------------------------------------------------------
i.	On line 8, change the name of the folder to whichever folder needs to be accessed. Eg. “/Landmine Features/Small Millbrook/HOG”
ii.	On line 29, do the same for accessing the variable “truth_data”.
iii.	If the dataset being used is Small Millbrook look at step iv. If the dataset being used is either Tiny Millbrook or MPG Sept 2005, uncomment lines 32-38 
	or 40-46 respectively. This has been done to ensure the dataset can be split into 10 folds. Do the same for any future datasets that may be used.
iv.	Based on the relationship between the number of features and the number of samples change the SVM kernel to either ‘linear’ or ‘rbf’.
	No. of features > No. of samples – linear kernel
	No. of features < No. of samples – rbf kernel
v.	The code will run and give the average classification rate of the 10 folds along with the confusion matrix.

======================================================================================================================================================================
b.	Test_code_grnn - Used for running the Generalized Regression Neural Network classification algorithm on the features. The following changes need to be kept in mind:
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
i.	On line 8, change the name of the folder to whichever folder needs to be accessed. Eg. “/Landmine Features/Small Millbrook/HOG”
ii.	On line 29, do the same for accessing the variable “truth_data”.
iii.	If the dataset being used is Small Millbrook look at step iv. If the dataset being used is either Tiny Millbrook or MPG Sept 2005, 
	uncomment lines 32-38 or 40-46 respectively. This has been done to ensure the dataset can be split into 10 folds. Do the same for any 
	future datasets that may be used.
============================================================================================================================================================================
c.	Feature_fusion_svm – Used for running the SVM on a fusion of the feature vectors. 2 fusion algorithms have been implemented here: Simple concatenation and
	Canonical Correlation Analysis (CCA). To use simple concatenation, uncomment the lines 117-119 and to use CCA, uncomment the lines 114-115. 
	The code will again give the average classification rate for the 10 folds and the confusion matrix. 
============================================================================================================================================================================
d.	Feature_fusion_grnn – Used for running the GRNN on a fusion of the feature vectors. 2 fusion algorithms have been implemented here: Simple concatenation and 
	Canonical Correlation Analysis (CCA). To use simple concatenation, uncomment the lines 117-119 and to use CCA, uncomment the lines 114-115. 
	The code will again give the average classification rate for the 10 folds and the confusion matrix. 
============================================================================================================================================================================
e.	cfMatrix2 – This function determines the Confusion Matrix for the algorithm by taking in the Training and Testing data. It returns the Confusion Matrix (TP, FP, TN, FN) 
	and also the accuracy of classification of the algorithm which can be used to cross verify the correctness of the feature extractor.
==============================================================================================================================================================================
f.	ccaFuse – This function implements the CCA fusion algorithm on the training samples. 
============================================================================================================================================================================
If any new fusion algorithm needs to be implemented follow the same variable naming convention as these to ensure minimal changes need to be made to ensure the program runs correctly. 
