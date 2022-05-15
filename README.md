# Fault-prognosis-using-LSTM-and-CNN
Fault prognosis using LSTM and CNN

Original data come from Western Reserve University Bearing Data Center.Futhure details can be seen in the repository called https://github.com/yzbbj/Data-of-Case-Western-Reserve-University and the doc file called .
Acctually you should download those files first so as to create initial data of your project.

You should run 'create_set.m' first to creat train and test sets.The you should run 'CNN' to train the CNN network,which is going to be used to classify faults.

Then you should run 'y0.m' to train LSTM and make preditcions.After that,you should run 'test0.m' to diagnos the type of the fault.
