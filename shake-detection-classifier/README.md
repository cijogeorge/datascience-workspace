## Shake Detection

### Problem statement

**Summary**: Building a classifier for detecting _shake_ gestures using data from phone sensors.

The goal is to create a classifier that can be implemented easily on streaming sensor data to detect Shake gesture.

There are 3 data sets:

1. a.lbl.csv, a.sensor.csv
2. m.lbl.csv, m.sensor.csv
3. p.lbl.csv, p.sensor.csv

Each set has two files: **sensor.csv** and **lbl.csv**.

**sensor.csv** has data from various phone sensors with the below information as columns:

- **timestamp(ms)**: Unix Timestamp in milliseconds.
- **acceleration_x(g)**: Acceleration along phone's x axis (measured in g)
- **acceleration_y(g)**: Acceleration along phone's y axis (measured in g)
- **acceleration_z(g)**: Acceleration along phone's z axis (measured in g)
- **roll(rad)**: Roll angle representing phone's attitude (orientation)
- **pitch(rad)**: Pitch angle representing phone's attitude (orientation)
- **yaw(rad)**: Yaw angle representing phone's attitude (orientation)
- **angular_velocity_x(rad/sec)**: Angular velocity around x axis (passing thru phones center along smaller edge)
- **angular_velocity_y(rad/sec)**: Angular velocity around y axis (passing thru phones center along longer edge)
- **angular_velocity_z(rad/sec)**: Angular velocity around z axis (passing thru phones center emerging out of phone )

The data is recorded every 100 ms (10Hz frequency).

**lbl.csv** contains 2 columes:

- **timestamp(ms)**: Unix Timestamp in milliseconds.
- **label**: 2 possible types of labels as given below.

Possible types of labels in **lbl.csv**:

1. Label **0** : Represents start of Shake gesture
2. Label **1** : Indicates end of Shake gesture

The Goal is to create a classifier that can be implemented easily on streaming sensor data to detect Shake gesture.

### Dive into the codebase

Click [here](shake_detection.ipynb) for viewing the **Jupyter Notebook** with code and explanations. Below is the summary of the solution approach.

**To re-run the analysis and reproduce results**, execute `Rscript shake_detection.r` or re-run the Jupiter Notebook. 

### Solution approach

#### Decision-tree based classifier using Recursive Partitioning

A '**decision-tree**' based classifier is trained using '**recursive partitioning**' ('rpart' method in R). The choice of using a decision tree based algorithm is because decision trees would be much more efficient for shake detection on incoming streaming data. Decsion trees will be simple to interpret and can be converted into rules for  matching on input data if needed. Choice of 'recursive partitioning'/ 'rpart' from among the available tree based algorithms is arbitrary.

#### Hyper-parameter tuning using Grid Search

'rpart' has just one hyper-parameter which is the '**complexity parameter**' - 'cp'. The best 'cp' is selected by doing  Grid Search using '**repeated cross-validation**' (10 fold cross validation repeated 10 times) on a range of 'cp' values. The 'cp' value which gives the best 'F1-Score' from the 'repeated cross-validation' is selected. The reasoning behind using '**F1-score**' here is explained below in 'Design Considerations'.

#### Data is heavily skewed!

After creating a labelled dataset for training the classifier, it is observed that **only 1.5% of the training data consists of measurements while the phone was 'Shaking' (Positive class for the Classifier)**. This means that the data is heavily skewed. This makes the classification problem more like a '**needle in a haystack**' problem. In this case, the probability of even a random classifier giving a lot of 'True Negatives' is very high. This will affect our evaluation of the classifier if we are not careful enough. For example, **'Accuracy' of the classifier of even a random classifier will be very high because 'True Negatives' will be high**. Hence we have to use evaluation metrics like Precision (Positive Predictive Value) and Recall (Sensitivity/  True Positive Rate) to evaluate the classifier or even selecting parameters in the training phase. Precision, Recall, F1-Score or some other similar 'True Negative' independent metrics should be used to select hyper-parameters values for a classification algorithm for solving such a problem. Here, I've used 'recursive partitioning' algorithm to build a classifier and used 'repeated cross-validation' to select the 'complexity parameter' that maximizes 'F1-Score'. **A custom function is written for this which is used by 'trainControl' in 'caret' package in R for training the classifier**.

**Note:** Another approach to handle skewed datasets is to do up/ down sampling i.e., either increase the number of positive samples by replication (as is or with slight variations) or decrease th number of negative samples by taking only a random subset of the negative class set with size roughly equal to the size of the positive class set. This is not used in this evaluation.
