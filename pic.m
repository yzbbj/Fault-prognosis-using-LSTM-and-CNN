%Function pic is used to generate train sets in the form of png pictures 
% and save them in corresponding folders
%%
%length_of_signal is the length of each signal  
%amount_of_data is the amount of the data included in each signal 
%segmentation
%mat_number is the number of the mat that need to be loaded
%folder_name is the name of the folder that is used to save different types
% of pictures
%%
function[k]=pic(length_of_signal,amount_of_data,mat_number,folder_name)
addpath("12k Drive End Bearing Fault Data\")
addpath("12k Fan End Bearing Fault Data\")
addpath("48k Drive End Bearing Fault Data\")
addpath("Normal Baseline Data\")
mat_number = num2str(mat_number);
mat_number = [mat_number,'.mat'];
mat = load(mat_number);
mat = struct2cell(mat);
mat1 = mat(1);           
mat1 = mat1{1,1}; %m1 is the signal that needs to be sectioned
segment = section(length_of_signal,amount_of_data,mat1);
folder_name = ['./',folder_name,'/'];
for i = 1:amount_of_data
    b = segment(:,i);
    s = num2str(i);
    pic_name = [s, '.png'];
    path = [folder_name,pic_name];
    plot(b);
    saveas(gcf,path);
    temp=imread(path);
	img = imresize(temp, [64 NaN]);
	imwrite(img,path);
end
k=1;%k is maeningless
end
 