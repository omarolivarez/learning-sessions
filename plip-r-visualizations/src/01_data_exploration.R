## GGPLOT2 CHEAT SHEET:
# https://www.maths.usyd.edu.au/u/UG/SM/STAT3022/r/current/Misc/data-visualization-2.1.pdf

# Omar's explanation of how ggplot2 works:
# ggplots are composed of a coordinate system, data, and geoms
# let's make an analogy with real-life art
# a coordinate system is like a canvas; what are you painting on?
# data is like your idea/vision; let's imagine I want to paint a cat
# geoms are your graph-type (scatter, box, bar); they are your medium. Will I use acrylics or watercolors?
# ggplot2 is a layer-based system. You can make your graph/geom simple or complicated by controlling how
# many aesthetics you apply to the graph.

# LIBRARIES TO IMPORT
library(ggplot2) # for making visualizations
library(dplyr) # for running SQL-like commands
library(lubridate) # for extracting day/month/year from date format
library(tidyr) # for doing pivot-table-like actions
library(hrbrthemes)

# READ IN THE DATA
df <- read.csv(file = '/Users/OmarOlivarez/Desktop/workspaces/learning-sessions/plip-r-visualizations/data/liwced_covid_dataset_6.9.21.csv') 

# get the rows for df
nrow(df) # 38,871 rows

# View the ends of the dataframe
View(head(df, 10))
View(tail(df, 10))

# there are 339 cols - let's focus on specific cols
# lets take a look at the language of people worried about getting COVID

# see all column names
colnames(df)

########################
########################
# GRAPHS FOR 1 VARIABLE

########################
########################
# HISTOGRAMS / BARPLOTS
# we use histograms to look at one, continuous variable along the x axis

# let's look at the distribution of WGettingCV using a Barplot
base <- ggplot(data = df, aes( x = WGettingCV ))
barplot_of_worry <- base + geom_bar()
barplot_of_worry # show the barplot

"""
What do we learn?
There's a pretty normal distribution for responses to being worried about getting COVID. 
"""

# NOTE: replace geom_bar with geom_histogram when you're looking at a continuous variable
# on the x-axis. We use geom_bar because in this case, WGettingCV is not continuous.

# for an example of a histogram, let's look at the distribution of pronoun
base <- ggplot(data = df, aes( x = pronoun ))
histogram_of_pronoun <- base + geom_histogram()
histogram_of_pronoun # show the barplot

# if you notice this error in red in your console:
# `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
# add the 'bins' parameter to geom_histogram until your bins looks good. Example:
base <- ggplot(data = df, aes( x = pronoun ))
histogram_of_pronoun <- base + geom_histogram(bins=100) # divide up the histogram so there are 50 bars/buckets/bins
histogram_of_pronoun # show the barplot

"""
What do we learn?
A TON of people don't use any pronouns in their Text entry. There's a pretty normal distribution between
the frequencies of 1 - 35. And there's a long tail going all the way up to 100. We might consider removing
those entries where Text has pronoun greater than, say, 50.
"""

########################
########################
# GRAPHS FOR 2 VARIABLES

########################
########################
# SCATTERPLOTS
# we use scatterplots to look at 2 continuous variables, one on each axis

# looking at the survey data, we can tell that most cols are categorical. So for the
# sake of viewing a scatterplot, let's plot negemo against swear words - which we know usually
# have a positive correlation. 

# let's look at the relationship between negemo (along x) and swear (along y)
base <- ggplot(data = df, aes( x = negemo, y = swear ))
scatterplot_of_negativity <- base + geom_point()
scatterplot_of_negativity # show the scatterplot

"""
What do we learn?
As we suspected, it looks like there's a positive correlation between negemo and swear. To highlight
that correlation, let's remove entries where swear > 25 and negemo > 50.
"""

# let's use the dplyr package to perform that filtering
negativity_subset <- df %>% 
  filter( swear < 25 ) %>%
  filter( negemo < 50 )

# let's look at the relationship between negemo and swear again
base <- ggplot(data = negativity_subset, aes( x = negemo, y = swear )) # note the change in "data"
scatterplot_of_negativity <- base + geom_point()
scatterplot_of_negativity # show the scatterplot

"""
What do we learn?
By removing outliers, we can more clearly see the positive relationship between negemo and swear.
"""

########################
########################
# LINE GRAPHS
# we use line graphs to look at 2  variables, one continuous/time on X, continuous on Y

# let's look, at an aggregate level, how WGettingCV changes over time

# let's use dplyr to get the monthly average of WGettingCV
# first, I like to subset the data to only include the cols I need
monthly_worry <- df %>% select(Start.Date, WGettingCV)
View(head(monthly_worry)) # double check this looks good

# let's see the columns types for the df
str(monthly_worry)
# we can see that Start.Date was interpreted as a character rather than a datetime
# let's convert it
# note: it was very easy to see their types because we'd subsetted the data to only those 2 cols!

# use dplyr to calculate average
m_worry <- monthly_worry %>%
  mutate(new_date= as.Date(df_m$Start.Date, "%m/%d/%Y %H:%M")) %>% # ,tz=Sys.timezone()
  mutate(Month_Yr = format_ISO8601(new_date, precision = "ym")) %>%
  group_by(Month_Yr) %>%
  summarise(monthly_mean = mean(WGettingCV, na.rm = TRUE))  
View(m_worry)

# now let's visualize
monthly_worry <- ggplot(m_worry,aes(Month_Yr,monthly_mean, group=1))  + 
  geom_line()
monthly_worry

# by the way, it's possible to layer geoms - let's add points to this line graph
monthly_worry <- ggplot(m_worry,aes(Month_Yr,monthly_mean, group=1))  + 
  geom_point() +
  geom_line()
monthly_worry

""" 
What do we learn?
Worry about getting COVID seems to be cyclical, with worry appearing to rise on average as mroe time passes. 
"""

########################
########################
# BOXPLOTS

str(df$WGettingCV) # it looks like 
box_df <- df %>% select(WGettingCV, anx)
box_df$WGettingCV <- as.factor(box_df$WGettingCV)
str(box_df$WGettingCV)
nrow(box_df) #38,871
cleaned_box_df <- na.omit(box_df)
nrow(cleaned_box_df) #29,973

# let's look at anx within each group of WGettingCV
boxplot_per_worry <- ggplot(cleaned_box_df, aes(WGettingCV, anx))  + 
  geom_boxplot() 
boxplot_per_worry

# let's remove outliers (points where anx > 25) to get a better view
cleaned_box_df <- cleaned_box_df %>%
  filter(anx < 25)

# another way to get a closeup of the data: use specific coordinates

# now let's try it again
boxplot_per_worry_2 <- ggplot(cleaned_box_df, aes(WGettingCV, anx))  + 
  geom_boxplot() +
  coord_cartesian(ylim=c(0,6.25))
boxplot_per_worry_2

""" 
I don't recommend zooming in on this particular boxplot because it fails to highlight
how many outliers the 5 group has. But this is just to show how to use the coord_cartesian() function.

What do we learn?
The median anxiety frequency rises steadily as you go from Group 1 - 5. Group 5 has the most variance in the upward direction. 
The median for the 5 group is pulled toward the upper quartiles while the median is pulled more toward the lower in Group 1; the more that
a respondent self-identifies as being worried about getting COVID, the more anxiety language they use. 
"""

########################
########################
# AESTHETICS - this is how I made the scatterplot in the pre-session material

# let's build on the negativity scatterplot to show what aesthetics is referring to
# original scatterplot
scatterplot_of_negativity <- ggplot(data = negativity_subset, aes( x = negemo, y = swear )) + geom_point() # note the change in "data"
scatterplot_of_negativity # show the scatterplot

# let's add color to everyone
scatterplot_of_negativity <- ggplot(data = negativity_subset, aes( x = negemo, y = swear )) +
  geom_point( colour="#34cfeb")
scatterplot_of_negativity # show the scatterplot

# let's add a title
scatterplot_of_negativity <- ggplot(data = negativity_subset, aes( x = negemo, y = swear ))  + 
  geom_point( colour="#34cfeb") +
  ggtitle("Negemo against swear in COVID survey respondents") +
  theme(plot.title = element_text(hjust = 0.5)) # this centers the title
scatterplot_of_negativity # show the scatterplot

# let's add transparency and color by group
scatterplot_of_negativity <- ggplot(data = negativity_subset, aes( x = negemo, y = swear, colour=WGettingCV )) + 
  geom_point( alpha=0.3, size = 2.5 ) +
  ggtitle("Negemo against swear in COVID survey respondents") +
  theme(plot.title = element_text(hjust = 0.5)) # this centers the title
scatterplot_of_negativity # show the scatterplot

# FACET GRID + COLORS
# let's look at: Facebook, Youtube, Twitter, OSocMedia, GovernmentSources, PrintOnlineNews, RadioTV (where people got CV news)
# let's facet grid on news source, make the monthYear the x axis, and personal concerns the y axis
# this will show us: for every news source, how do personal concerns change over time? 
# note: there's going to be a lot of data engineering work in this section!

# select the columns we need
facet_df <- df %>% 
  select(Start.Date, work, leisure, home, money, relig, death,
         Facebook, Youtube, Twitter, OSocMedia, GovernmentSources, PrintOnlineNews, RadioTV) %>% # select the cols
  mutate(Youtube = ifelse(Youtube > 3, 1, 0)) %>% # make the responses binary
  mutate(Twitter = ifelse(Twitter > 3, 1, 0)) %>%
  mutate(OSocMedia = ifelse(OSocMedia > 3, 1, 0)) %>%
  mutate(GovernmentSources = ifelse(GovernmentSources > 3, 1, 0)) %>%
  mutate(PrintOnlineNews = ifelse(PrintOnlineNews > 3, 1, 0)) %>%
  mutate(RadioTV = ifelse(RadioTV > 3, 1, 0)) %>%
  gather(key = "news_source", value = "use_this_source", 
         Facebook, Youtube, Twitter, OSocMedia, GovernmentSources, PrintOnlineNews, RadioTV) # turn these 6 cols into 2

nrow(facet_df) # 272,097, data was multiplied by 7 (the num of new sources)
cleaned_facet_df <- na.omit(facet_df)
nrow(cleaned_facet_df) # 126,715 data was halved by missing values (probably from use_this_source)
View(head(cleaned_facet_df, 20))

# now let's remove all 0's
cleaned_facet_df <- cleaned_facet_df %>% filter(use_this_source == 1)
View(head(cleaned_facet_df, 20))

# let's convert the date now
conv_time <- cleaned_facet_df %>%
  mutate(new_date= as.Date(cleaned_facet_df$Start.Date, "%m/%d/%Y %H:%M")) %>% 
  mutate(Month_Yr = format_ISO8601(new_date, precision = "ym")) 
View(head(conv_time))
conv_time <- conv_time %>% select(-Start.Date, -use_this_source, -new_date)
View(head(conv_time))

final_facet <- conv_time %>%
  group_by(Month_Yr, news_source) %>%
  summarise(mean_work = mean(work, na.rm = TRUE), 
            mean_leisure = mean(leisure, na.rm = TRUE),
            mean_home = mean(home, na.rm = TRUE), 
            mean_money = mean(money, na.rm = TRUE), 
            mean_relig = mean(relig, na.rm = TRUE), 
            mean_death = mean(death, na.rm = TRUE) )  
View(head(final_facet, 100))

final_facet <- final_facet %>%
  gather(key = "concern_category", value = "concern_value", 
         mean_work, mean_leisure, mean_home, mean_money, mean_relig, mean_death)
View(head(final_facet, 20))

facet_concern_news <- ggplot(final_facet, aes(Month_Yr, concern_value, group=concern_category)) +
  geom_point(aes(colour=concern_category)) + 
  geom_line(aes(colour=concern_category)) +
  facet_wrap(vars(news_source)) +
  theme(panel.background = element_rect(fill = "white", colour= "black")) + # styling background
  theme(panel.grid.major = element_line(color = "gray"))
facet_concern_news

""" 
What do we learn?
We can spot how the concerns for each consumer group changes over time. Looking at work in particular, it's interesting that 
work becomes more of a focus for some groups while it becomes less for others. 
"""
# VERTICAL AND HORIZAONTAL LINES
facet_concern_news_2 <- ggplot(final_facet, aes(Month_Yr, concern_value, group=concern_category)) +
  geom_point(aes(colour=concern_category)) + 
  geom_line(aes(colour=concern_category)) +
  facet_wrap(vars(news_source)) + 
  geom_vline(xintercept="2020-06", colour="red", linetype = "dashed") + # this is the difference
  theme(panel.background = element_rect(fill = "white", colour= "black")) + 
  theme(panel.grid.major = element_line(color = "gray"))
facet_concern_news_2

# OTHER AESTHETICS:
# color scales, size, labels, regression lines