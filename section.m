%function section is used to create segmentations of mat1 randomly
function[X]=section(length_of_signal,amount_of_data,mat1)
X = zeros(length_of_signal,amount_of_data);
size_m1 = size(mat1);
size_m1 = size_m1(1,1);
for i=1:amount_of_data
    %%unidrnd:Generates a set of discrete uniform random integers.
    startpoint_size=size_m1-length_of_signal;
    start_point(i) = unidrnd(startpoint_size); 
    %start point of segmentation i
    end_point(i) = start_point(i)+length_of_signal-1;
    %end point of segmentation i
    X(:,i) = mat1(start_point(i):end_point(i));
end 
%every column of matrix X is a sample of original signal
  

   