## Predicting Survival on the Titanic

### Overview

This repo covers the solution to one of the 'getting started' machine learning problems in [Kaggle](https://www.kaggle.com) on **Predicting survival on the Titanic**. Click [here](https://www.kaggle.com/c/titanic) for the Kaggle page on this problem.

### Problem Description

[Reproduced as-is from Kaggle]

The sinking of the RMS Titanic is one of the most infamous shipwrecks in history.  On April 15, 1912, during her maiden voyage, the Titanic sank after colliding with an iceberg, killing 1502 out of 2224 passengers and crew. This sensational tragedy shocked the international community and led to better safety regulations for ships.

One of the reasons that the shipwreck led to such loss of life was that there were not enough lifeboats for the passengers and crew. Although there was some element of luck involved in surviving the sinking, some groups of people were more likely to survive than others, such as women, children, and the upper-class.

In this challenge, we ask you to complete the analysis of what sorts of people were likely to survive. In particular, we ask you to apply the tools of machine learning to predict which passengers survived the tragedy.

### Data Description

#### Overview

The data has been split into two groups:

- training set (train.csv)
- test set (test.csv)

**The training set **should be used to build your machine learning models. For the training set, we provide the outcome (also known as the “ground truth”) for each passenger. Your model will be based on “features” like passengers’ gender and class. You can also use [feature engineering ](https://triangleinequality.wordpress.com/2013/09/08/basic-feature-engineering-with-the-titanic-data/)to create new features.

**The test set **should be used to see how well your model performs on unseen data. For the test set, we do not provide the ground truth for each passenger. It is your job to predict these outcomes. For each passenger in the test set, use the model you trained to predict whether or not they survived the sinking of the Titanic.

#### Data Dictionary

| **Variable** | **Definition**                           |
| ------------ | ---------------------------------------- |
| survival     | Survival                                 | 
| pclass       | Ticket class                             |
| sex          | Sex                                      |                                         
| Age          | Age in years                             |                              
| sibsp        | # of siblings / spouses aboard the Titanic |
| parch        | # of parents / children aboard the Titanic |                                          
| ticket       | Ticket number                            |                                          
| fare         | Passenger fare                           |                                          
| cabin        | Cabin number                             |                                          
| embarked     | Port of Embarkation                      | 

**Key**
0 = No, 1 = Yes
1 = 1st, 2 = 2nd, 3 = 3rd

C = Cherbourg, Q = Queenstown, S = Southampton

#### Variable Notes

**pclass**: A proxy for socio-economic status (SES)
1st = Upper
2nd = Middle
3rd = Lower
**age**: Age is fractional if less than 1. If the age is estimated, is it in the form of xx.5
**sibsp**: The dataset defines family relations in this way...
Sibling = brother, sister, stepbrother, stepsister
Spouse = husband, wife (mistresses and fiancés were ignored)
**parch**: The dataset defines family relations in this way...
Parent = mother, father
Child = daughter, son, stepdaughter, stepson
Some children travelled only with a nanny, therefore parch=0 for them.

### Dive into the codebase

#### Feature engineering

Click [here](titanic_make_features.ipynb) for viewing the **Jupyter Notebook** with code and explanations.

**To re-run the feature engineering**, execute `Rscript titanic_make_features.r` or re-run the Jupiter Notebook. This will create the file **data/processed_train.csv**

#### Training

Click [here](titanic_train.ipynb) for viewing the **Jupyter Notebook** with code and explanations.

**To re-run training**, execute `Rscript titanic_train.r` or re-run the Jupiter Notebook.

#### Test

Will be added soon.
