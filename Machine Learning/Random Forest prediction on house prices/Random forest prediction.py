#! python 3
# Random Forest Algorithm for price prediction, using the 'Housing prices competition' dataset from kaggle.

#Importing libraries
import pandas as pd # Used to manipulate dataframes
import os # Used to read and write on system files
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt # Used for plotting
import seaborn as sns # Used for plot themes
import matplotlib.ticker as mtick # Used to adjust plot ticks
import numpy as np # Used to create arrays
from sklearn.ensemble import RandomForestRegressor # Used to import the necessary model
from sklearn.metrics import mean_absolute_error # Used for the creation of a score system in order to determine the best model
sns.set_style('white')

# Read the data
# In order for the code to find the file, please be sure to have both train.csv and test.csv files in the same directory as this python script
cwd = os.getcwd()
X_full = pd.read_csv( cwd + '\\train.csv', index_col='Id')
X_test_full = pd.read_csv(cwd + '\\test.csv', index_col='Id')

# Obtain target and predictors
y = X_full.SalePrice
features = ['LotArea', 'YearBuilt', '1stFlrSF', '2ndFlrSF', 'FullBath', 'BedroomAbvGr', 'TotRmsAbvGrd']
X=X_full[features].copy()
X_test=X_test_full[features].copy()

# Break off validation set from training data
X_train, X_valid, y_train, y_valid = train_test_split(X, y, train_size = 0.8, test_size = 0.2, random_state = 0 )

# Defining the models, testing for the lowest MAE score

model_1 = RandomForestRegressor(n_estimators=50, random_state=0)
model_2 = RandomForestRegressor(n_estimators=100, random_state=0)
model_3 = RandomForestRegressor(n_estimators=100, criterion='mae', random_state=0)
model_4 = RandomForestRegressor(n_estimators=200, min_samples_split=20, random_state=0)
model_5 = RandomForestRegressor(n_estimators=100, max_depth=7, random_state=0)

#Model N° 6 is a combination of the models that scored the lowest mae, that is model N°3 and N°5, adding some more depth
model_6 = RandomForestRegressor(n_estimators=100, criterion='mae', max_depth=20, random_state=0)

models = [model_1,model_2,model_3,model_4,model_5, model_6]

#Function for comparing different models

def score_model(model, X_t=X_train, X_v=X_valid, y_t=y_train, y_v=y_valid):
    model.fit(X_t, y_t)
    preds = model.predict(X_v)
    return mean_absolute_error(y_v, preds)

print('Model scores (lowest is best): ')
print('\n')

# Plotting each model in order to visually see the differences.
for i in range(0, len(models)):
    mae = score_model(models[i])
    plt.ylim(23250,24200)
    plt.bar('Model ' + str(i+1), mae, align='center', alpha=0.5)
    plt.ylabel('Mae score')
    plt.title('Mae score comparision')
    print('Model %d MAE: %d' %(i+1, mae))
print('\n')
print('Model 6 has the lowest score, this model will be trained with the dataset: ')
print('\n')

#The lowest model was N3, followed by number 5. So We are going to use a combination of both that scores an even better MAE.
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

#Plotting the differences between the model and the real data, comparing different parameters such as LotArea, BedroomAbvGr, etc.

#First set of plots, LotArea vs SalePrice, defining fig1, ax1 and ax2
fig1, ((ax1, ax2)) = plt.subplots(nrows=1, ncols=2, sharey=True)

#defining ax1 parameters
ax1.scatter(X['LotArea'], X_full['SalePrice'],c=X_full['SalePrice'], cmap='viridis')
ax1.set_xlabel('LotArea(ft2)')
ax1.set_xlim([0,60000])
ax1.set_ylabel('SalePrice($)')
ax1.set_title('LotArea vs SalePrice Real data')
ax1.yaxis.set_major_formatter(mtick.StrMethodFormatter('{x:,.0f}'))

#defining ax2 parameters
ax2.scatter(X_test['LotArea'], output['SalePrice'],c=output['SalePrice'], cmap='viridis')
ax2.set_xlabel('LotArea(ft2)')
ax2.set_xlim([0,60000])
ax2.set_title('LotArea vs SalePrice model prediction')


#Second set of plots, BedroomAbvGr vs Sale Price, defining fig2, ax3 and ax4
fig2, ((ax3, ax4)) = plt.subplots(nrows=1, ncols=2, sharey=True)

#defining ax3 parameters
ax3.scatter(X['BedroomAbvGr'], X_full['SalePrice'],c=X_full['SalePrice'], cmap='plasma')
ax3.set_xlabel('BedroomAbvGr(n)')
ax3.set_ylabel('SalePrice($)')
ax3.set_xlim([-1,7])
ax3.set_title('N° of rooms vs SalePrice Real data')
ax3.yaxis.set_major_formatter(mtick.StrMethodFormatter('{x:,.0f}'))

#defining ax4 parameters
ax4.scatter(X_test['BedroomAbvGr'], output['SalePrice'],c=output['SalePrice'], cmap='plasma')
ax4.set_xlabel('BedroomAbvGr(n)')
ax4.set_xlim([-1,7])
ax4.set_title('N° of rooms vs SalePrice model prediction')
#
#
plt.tight_layout()
plt.show()
