#!/usr/bin/env python
# coding: utf-8

# In[360]:


import pandas as pd
import numpy as np
import os
from sklearn.model_selection import train_test_split


# In[361]:


#While importing the data, it's important to note that the original data-set has 'unknown' values. In this case we will replace them with the null equivalent.
data = pd.read_csv(os.getcwd() + '\\bank-additional-full.csv', na_values ='unknown', sep = ';')


# In[362]:


#Reviewing our data
data


# In[363]:


#Checking what types of data each column has in order to normalize them.
data.dtypes


# In[364]:


#Check the amount of data we have for each category (missing data is Null / None data)
data.count()


# In[365]:


#Total sum of Nulls per column
data.isna().sum()


# In[366]:


# Percentage of target value being positive
round(data['y'].value_counts() * 100 / data['y'].count(),2)


# In[367]:


#Percentage of nulls in each column
percentage_missing = data.isnull().sum() * 100 / len(data)
print(round((percentage_missing),2))


# In[368]:


#Since default has a large amount of null values, it would be unwise to delete every row that has a null value in default, sincce
# it will remove a lot of useful information. 
#The best way to conduct this would be to remove every row on job, marital, education, housing and loan
#and replace the null values on "default" with the value that has the most appearences in this column OR
#delete the default column, this will depend on the count for each category on default:


# In[369]:


#As we can see, default not only has 20% of missing data, but only has 3 'yes'. This column must be removed from
#the data-set in order to preserve data integrity for the algorithm to work.
data['default'].value_counts()


# In[370]:


data['job'].value_counts()


# In[371]:


#Replacing admin. for admin
data['job'].replace({'admin.' : 'admin'}, inplace = True) 


# In[372]:


#Replacing Na's for the most frequent value 
data['job'].value_counts()


# In[373]:


data['job'].fillna('admin', inplace = True)


# In[374]:


percentage_missing = data.isnull().sum() * 100 / len(data)
print(round((percentage_missing),2))


# In[375]:


data['education'].value_counts()


# In[376]:


data['education'].fillna('university.degree', inplace = True)


# In[377]:


data['marital'].value_counts()


# In[378]:


data['marital'].fillna('married', inplace = True)


# In[379]:


data['housing'].value_counts()


# In[380]:


data['housing'].fillna('yes', inplace = True)


# In[381]:


data['loan'].value_counts()


# In[382]:


data['loan'].fillna('no', inplace = True)


# In[383]:


data.drop(columns = 'default', inplace = True)


# In[384]:


data.count()


# In[385]:


job_dummy = pd.get_dummies(data.job)
marital_dummy = pd.get_dummies(data.marital)
education_dummy = pd.get_dummies(data.education)
housing_dummy = pd.get_dummies(data.housing)
loan_dummy = pd.get_dummies(data.loan)
concat_data = pd.concat([data,job_dummy,marital_dummy,education_dummy,housing_dummy,loan_dummy],axis=1)


# In[386]:


concat_data.drop(columns = ['job','marital','education','housing','loan','contact','month','day_of_week','duration','campaign','pdays','previous','poutcome','emp.var.rate','cons.price.idx','cons.conf.idx','euribor3m','nr.employed'], inplace = True)


# In[387]:


concat_data


# In[388]:


y = concat_data.y
concat_data.drop(columns = 'y', inplace= True)
X = concat_data


# In[389]:


y


# In[390]:


X


# In[391]:


X_train, X_test, y_train, y_test = train_test_split(X, y , test_size = 0.20)


# In[392]:


#data.to_csv('train.csv', encoding = 'utf-8')

