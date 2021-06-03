library(ggplot2)
library(dplyr)

# read in the data
df <- read.csv(file = '/Users/OmarOlivarez/Desktop/workspaces/learning-sessions/plip-r-visualizations/data/test_dataset_ezpztxt_20210603.csv') 

# get the rows for df
nrow(df) # 70,737 rows

# View the top rows of the dataframe
head(df)