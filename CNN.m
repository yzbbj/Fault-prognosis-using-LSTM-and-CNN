%%This code is used to train and validate the CNN network

%%Load data
digitDatasetPath = fullfile('.') 
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');
%Use an ImageDatastore object to manage a collection of image files
%imds = imageDatastore(location,Name,Value) 

%Count the number of images of each lable
Count_of_Lable = countEachLabel(imds)

%%Specify training and validation sets
number_of_each_train_test = 150;
[imds_of_train_set,imds_of_validation_set]= splitEachLabel(imds, ...
    number_of_each_train_test, 'randomize');

%%Define CNN network
layers = [
    imageInputLayer([64 86 3])
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(4)
    softmaxLayer
    classificationLayer];

%%Specify training options
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01,...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropFactor',0.1,...
    'LearnRateDropPeriod',10,...
    'MaxEpochs',16, ...
    'Shuffle','every-epoch',...
    'ValidationData',imds_of_validation_set,...
    'ValidationFrequency',10,...
    'Verbose',false, ...
    'Plots','training-progress');  

%%CNN network is trained using trian sets
CNN_network = trainNetwork(imds_of_train_set,layers,options);

%%Classify validation sets using the trained CNN network
Prediction_of_validation_set = classify(CNN_network,imds_of_validation_set);
True_lable_of_validation_set = imds_of_validation_set.Labels;

%%Evaluate the CNN network by calculating the accuracy of the validation
%%sets
accuracy = sum(Prediction_of_validation_set == True_lable_of_validation_set)/numel(True_lable_of_validation_set)