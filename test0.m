%%Use CNN network to clasisfy the prediction

s = num2str(0);
name = [s, '.png'];
plot(y2); 
saveas(gcf,name);
temp = imread(name);
img = imresize(temp, [64 86]);
imwrite(img,name);
  
net = CNN_network;  
I= imread(name); 
 
imshow(I);

label = classify(net, I);

length(label)
label(1,1)
s1='normal';
s2=cellstr(label);
s3=cell2mat(s2);
ans=strcmpi(s1,s3);