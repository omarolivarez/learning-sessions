#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 24 21:05:13 2021

@author: OmarOlivarez
"""

"""
WHAT ARE VARIABLES?
-------------------
if x1 = 1
   x2 = 2
   x3 = 3
   
and
   y1 = 2
   y2 = 4
   y3 = 6
   
Can you describe the relationship between x and y? 

WHAT ARE FUNCTIONS?
-------------------
Well, y = 2x

Or, you might have also seen the notation: f(x) = 2x, where y = f(x). You read f(x) as 'ef of ex'.
Or, you'd say that 'y is a function of x'. 
So, y = f(x) = 2x.

In Python, you identify that something is a function by first writing the keyword 'def' in front of
the function name. This is how you would write: f(x) = 2x

def f(x): return 2x

A function intakes parameters inside the parenthes

Let's create more complex functions.
"""

"""
WHAT IS PANDAS?
---------------

"""
import pandas as pd

# function 1: a basic calculation
def calculate_birth_year(age):
    return 2021 - age

def practice_python():
    
    johns_age = 24 #yrs old
    janes_age = 64 #yrs old
    print("John's age is %d and his birth year is %d" % (johns_age, calculate_birth_year(johns_age)))
    print()
    print("Jane's age is %d and her birth year is %d" % (janes_age, calculate_birth_year(janes_age)))
    print()
    
    # now let's learn about other data types
    
    # VARIABLE DATA TYPES
    # strings
    print("String section")
    x = "Hello world!"
    print(x, type(x))
    
    # integers
    print("Integer section")
    x = 1
    print(x, type(x))
    
    # floats
    print("Float section")
    x = 1.02
    print(x, type(x))
    
    # booleans
    print("Boolean section")
    x = True 
    print(x, type(x))
    
    # COLLECTIONS
    
    # lists - ordered, changeable, and allows duplicates
    print("List section")
    x = [1, 2, 4, 2, 4]
    print(x, type(x))
    print(x, type(x))
    
    # sets - unordered, unchangeable, does not allow duplicates
    print("Set section")
    x = set(x)
    print(x, type(x))
    print(x, type(x))
  
    # tuples - ordered, unchangeable, and allows duplicates
    print("Tuple section")
    x = (1, 2, 4, 2, 4)
    print(x, type(x))
    print(x, type(x))
    
    # dictionaries - ordered, changeable, does not allow duplicates
    print("Dictionary section")
    x = {}
    x["Jack"] = 24
    x["John"] = 30
    x["Jill"] = 50
    print(x, type(x))
    print(x, type(x))
    return

def add_quartile(x):
    if x.perc <= 0.25:
        return 1
    elif x.perc > 0.25 and x.perc < 0.5:
        return 2
    elif x.perc > 0.5 and x.perc <= 0.75:
        return 3
    else:
        return 4

# FUNCTIONS
def main():
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print("THE CODE BEGINS")
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print()
    
    #practice_python() # this will run the function above
    
    # PANDAS
    # pandas cheat sheet: https://pandas.pydata.org/Pandas_Cheat_Sheet.pdf
    # read in data
    df = pd.read_csv("/Users/OmarOlivarez/Desktop/workspaces/learning-sessions/plip-r-visualizations/data/liwced_covid_dataset_6.9.21.csv")
    # other useful reading parameters
    #df = pd.read_csv("file_path", nrows=10) # if you only want to read in a few lines
    #df = pd.read_csv("file_path", nrows=1).columns.tolist() # if you only want to read in column names
    #df = pd.read_csv("file_path", usecols=cols_list) # to only read in certain columns
    
    print(df.head())
    print()
    
    print(df.columns) # this only prints the first and last ten
    print()
    print(list(df.columns)) # this lists out all the column names
    print()
    # let's look at HrsAroundOthers, social, and HrsTalking
    
    # first, let's get the correlation between HrsAroundOthers with social
    subset = df[['HrsAroundOthers','social','HrsTalking']].copy()
    print(subset.dtypes)
    print("The correlation between HrsAroundOthers and social is:", round(subset['HrsAroundOthers'].corr(subset['social']), 4))
    print("The correlation between HrsTalking and social is:", round(subset['HrsTalking'].corr(subset['social']), 4))
    print()
    
    # let's make a new column for social time: HrsAroundOthers and HrsTalking
    subset["SocialTime"] = subset.HrsAroundOthers + subset.HrsTalking
    print(subset.head())
    print()
    
    # there are a lot of NaNs! (the same as NAs in R). Let's remove them.
    subset = subset.dropna()
    print(subset.head())
    print()
    
    # perfect! Now let's create a new column for the quartile that each row's SocialTime falls in
    
    # first let's add a new percentile rank column against Social Time
    subset['perc'] = subset['SocialTime'].rank(pct=True)
    
    # now let's add in a new column for quartile
    subset['quart'] = subset.apply(add_quartile, axis=1) 
    
    # let's take a look at the head again
    print(subset.head())
    print()
    
    # perfect, now let's get average social per quartile 
    averaged_subset = subset.copy().groupby(by="quart").mean()
    print("AVERAGE OF EACH COLUMN PER QUARTILE:")
    print(averaged_subset.head())
    print()
    
    # we only need quart and social, so let's only select those columns
    simple_averaged_subset = averaged_subset[[ "social"]].copy()
    print(simple_averaged_subset.head())
    print()
    
    # now let's plot this as a barplot
    # first, reset index (not necessary)
    simple_averaged_subset = simple_averaged_subset.reset_index()
    simple_averaged_subset.plot.bar(x = "quart", y = "social")
    
    # lastly, let's create a new df and merge it to this one
    labels_df = pd.DataFrame( [["Not very social", 1], ["Slightly below avg social", 2], 
                             ["Slight above average social", 3], ["Very social", 4] ],index=[1, 2, 3, 4], columns=['name', 'quart']) 
    # name is for the first list, quartile is for the second
    print(labels_df.head())
    print()
    
    # now merge the data
    merged_data = pd.merge(simple_averaged_subset, labels_df, how='left', on='quart')
    print(merged_data.head())
    print()

main()






























