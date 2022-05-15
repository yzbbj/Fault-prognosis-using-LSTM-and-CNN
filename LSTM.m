%%Time sequence forcasting using LSTM

%The input of the LSTM is the original time seires,the responses of it are
%the training sequences with values shifted by one time step
function [y2]=lstm(c)
   s = num2str(c);%%j(Êý×Ö£©×ª»»Îª×Ö·û´®
   name = [s, '.mat'];
   A=load(name);
   B=struct2cell(A);
   D=B{1,1};
   data=D(1:20000)';

figure
plot(data)
xlabel("Time")
ylabel("Amplitude")
title("Vibration Signal")

%%Partition the original data into training and test sets(9:1)
numTimeStepsTrain = floor(0.9*numel(data));
dataTrain = data(1:numTimeStepsTrain+1);
dataTest = data(numTimeStepsTrain+1:end);

%%Data normalization of trian set
mu = mean(dataTrain);
sig = std(dataTrain);
dataTrainStandardized = (dataTrain - mu) / sig;

%%Specify train sets and test sets
XTrain = dataTrainStandardized(1:end-1);
YTrain = dataTrainStandardized(2:end);

%%Define LSTM network
numFeatures = 1;
numResponses = 1;
numHiddenUnits = 200;
layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits)
    fullyConnectedLayer(numResponses)
    regressionLayer];

%%Specify training options
options = trainingOptions('sgdm', ...
    'MaxEpochs',100, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',0, ...
    'Plots','training-progress');

%%Train LSTM
net3 = trainNetwork(XTrain,YTrain,layers,options);

%%Data normalization of test set 
dataTestStandardized = (dataTest - mu) / sig;
XTest = dataTestStandardized(1:end-1);

%%Initialize the network state by forcasting the input data
%%Then use the last time step of the train responses to make the first
%%prediction
net3 = predictAndUpdateState(net3,XTrain);
[net3,YPred] = predictAndUpdateState(net3,YTrain(end));

%%Forecast further predictions
numTimeStepsTest = numel(XTest);
for i = 2:numTimeStepsTest
    [net3,YPred(:,i)] = predictAndUpdateState(net3,YPred(:,i-1), ...
        'ExecutionEnvironment','cpu');
end

%%Data denormalization of prediction 
YPred = sig*YPred + mu;
YTest = dataTest(2:end);
rmse = sqrt(mean((YPred-YTest).^2));

%%Plot the prediction
figure
plot(dataTrain(1:end-1))
hold on
idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
plot(idx,[data(numTimeStepsTrain) YPred],'.-')
hold off
xlabel("Time")
ylabel("CAmplitude")
title("Vibration Signal")
legend(["Observed" "Forecast"])

%%Compare the predictions with test set
figure
subplot(2,1,1)
plot(YTest)
hold on
plot(YPred,'.-')
hold off
legend(["Observed" "Forecast"])
ylabel("Cases")
title("Forecast")
subplot(2,1,2)
stem(YPred - YTest)
xlabel("Time")
ylabel("Error")
title("RMSE = " + rmse)

%%Reset the LSTM network to predict new time series
net3 = resetState(net3);
net3 = predictAndUpdateState(net3,XTrain);

%%Predict the repsponse of next time step
YPred = [];
numTimeStepsTest = numel(XTest);
for i = 1:numTimeStepsTest
    [net3,YPred(:,i)] = predictAndUpdateState(net3,XTest(:,i), ...
        'ExecutionEnvironment','cpu');
end

%%Data denormalization of prediction¡£
YPred = sig*YPred + mu;

%%Calculate RMSE
rmse = sqrt(mean((YPred-YTest).^2));

%%Compare the predictions with test set
figure
subplot(2,1,1)
plot(YTest)
hold on
plot(YPred,'.-')
hold off
legend(["Observed" "Predicted"])
ylabel("Cases")
title("Forecast with Updates")

subplot(2,1,2)
stem(YPred - YTest)
xlabel("Time")
ylabel("Error")
title("RMSE = " + rmse)
y2=YPred;