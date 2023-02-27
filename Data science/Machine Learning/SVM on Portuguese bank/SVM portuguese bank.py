#Basic RandomForestRegressor model
#Importing libraries
import pandas as pd # Used to manipulate dataframes
import os # Used to read and write on system files
from sklearn.model_selection import train_test_split
import numpy as np # Used to create arrays
from sklearn.ensemble import RandomForestRegressor # Used to import the necessary model


# Read the data
# In order for the code to find the file, please be sure to have both train.csv and test.csv files in the same directory as this python script
cwd = os.getcwd()
X_full = pd.read_csv( cwd + '\\train.csv', index_col='Id')

# Obtain target and predictors. the .copy() is used as to not change the original data
y = X_full.y
features = ['age', 'job', 'marital', 'education', 'housing', 'loan']
X=X_full[features].copy()

# Break off validation set from training data
X_train, X_valid, y_train, y_valid = train_test_split(X, y, train_size = 0.8, test_size = 0.2, random_state = 0 )

#setup a model

my_model = RandomForestRegressor(n_estimators=100, criterion='mae', max_depth=20, random_state=0)

# Fitting the model to the training data
my_model.fit(X, y)

#Generating test predictions
preds_test = my_model.predict(X_test)

# Fitting it into a pandas dataframe and printing the output into an CSV file
output = pd.DataFrame({'Id' : X_test.index, 'SalePrice': preds_test})
output.to_csv('prediction.csv', index=False)

#Printing output, some statistical information and plotting.
print('Algorithm output and SalePrice statistical information: ')
print('\n')
print(output)
print('\n')
print(output['SalePrice'].describe())
