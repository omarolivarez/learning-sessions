## GGPLOT2 CHEAT SHEET:
# https://www.maths.usyd.edu.au/u/UG/SM/STAT3022/r/current/Misc/data-visualization-2.1.pdf

# LIBRARIES TO IMPORT
library(ggplot2) # for making visualizations
library(dplyr) # for running SQL-like commands
library(lubridate) # for extracting day/month/year from date format
library(tidyr) # for doing pivot-table-like actions
library(hrbrthemes) # for themes

df <- read.csv(file = '/Users/OmarOlivarez/Desktop/workspaces/learning-sessions/plip-r-visualizations/data/liwced_covid_dataset_6.9.21.csv') 

nrow(df)

View(head(df))

colnames(df)

base_layer <- ggplot(data = df, aes(x = WGettingCV))
barplot_of_worry <- base_layer + geom_bar()
barplot_of_worry

base <- ggplot(data = df, aes( x = pronoun ))
histogram_of_pronoun <- base + geom_histogram(bins=101)
histogram_of_pronoun

# let's look at the relationship between negemo (along x) and swear (along y)
base <- ggplot(data = df, aes( x = negemo, y = swear ))
scatterplot_of_negativity <- base + geom_point()
scatterplot_of_negativity # show the scatterplot# show the scatterplot

# let's use the dplyr package to perform that filtering
negativity_subset <- df %>% 
  filter( swear < 25 ) %>%
  filter( negemo < 50 )

# let's look at the relationship between negemo and swear again
base <- ggplot(data = negativity_subset, aes( x = negemo, y = swear )) # note the change in "data"
scatterplot_of_negativity <- base + geom_point()
scatterplot_of_negativity


monthly_worry <- df %>% select(Start.Date, WGettingCV)
View(head(monthly_worry, 20))
str(monthly_worry)

m_worry <- monthly_worry %>%
  mutate(new_date = as.Date(monthly_worry$Start.Date,"%m/%d/%Y %H:%M")) %>%
  mutate(Month_Yr = format_ISO8601(new_date, precision="ym")) %>%
  group_by(Month_Yr) %>%
  summarise(monthly_mean = mean(WGettingCV, na.rm = TRUE))

View(m_worry)

monthly_WGettingCV <- ggplot(m_worry, aes(Month_Yr,monthly_mean, group=1))  + 
  geom_line()
monthly_WGettingCV


monthly_WGettingCV <- ggplot(m_worry, aes(Month_Yr, monthly_mean, group=1)) +
  geom_point()
monthly_WGettingCV

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

# now let's try it again
boxplot_per_worry_2 <- ggplot(cleaned_box_df, aes(WGettingCV, anx))  + 
  geom_boxplot() +
  coord_cartesian(ylim=c(0,6.25))
boxplot_per_worry_2




# let's build on the negativity scatterplot to show what aesthetics is referring to
# original scatterplot
scatterplot_of_negativity <- ggplot(data = negativity_subset, aes( x = negemo, y = swear )) + geom_point() # note the change in "data"
scatterplot_of_negativity # show the scatterplot

# let's add color to everyone
scatterplot_of_negativity <- ggplot(data = negativity_subset, aes( x = negemo, y = swear )) +
  geom_point( colour="green")
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


facet_df <- df %>% 
  select(Start.Date, work, leisure, home, money, relig, death,
         Facebook, Youtube, Twitter, OSocMedia, GovernmentSources, PrintOnlineNews, RadioTV) %>%
  mutate(Youtube = ifelse(Youtube > 3, 1, 0)) %>% # make the responses binary
  mutate(Twitter = ifelse(Twitter > 3, 1, 0)) %>%
  mutate(OSocMedia = ifelse(OSocMedia > 3, 1, 0)) %>%
  mutate(GovernmentSources = ifelse(GovernmentSources > 3, 1, 0)) %>%
  mutate(PrintOnlineNews = ifelse(PrintOnlineNews > 3, 1, 0)) %>%
  mutate(RadioTV = ifelse(RadioTV > 3, 1, 0)) %>%
  mutate(Facebook = ifelse(Facebook > 3, 1, 0)) %>%
  gather(key = "news_source", value = "use_this_source", 
         Facebook, Youtube, Twitter, OSocMedia, GovernmentSources, PrintOnlineNews, RadioTV)
nrow(facet_df)
cleaned_facet_df <- na.omit(facet_df)
nrow(cleaned_facet_df) # 126,715 data was halved by missing values (probably from use_this_source)
View(head(cleaned_facet_df, 20))

# now let's remove all 0's
cleaned_facet_df <- cleaned_facet_df %>% filter(use_this_source == 1)
View(head(cleaned_facet_df, 20))

str(cleaned_facet_df)

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
  gather(key = "concern_category", value = "mean_value", 
         mean_work, mean_leisure, mean_home, mean_money, mean_relig, mean_death)
View(head(final_facet, 20))

# VERTICAL AND HORIZAONTAL LINES
facet_concern_news_2 <- ggplot(final_facet, aes(Month_Yr, mean_value, group=concern_category)) +
  geom_point(aes(colour=concern_category)) + 
  geom_line(aes(colour=concern_category)) +
  facet_wrap(vars(news_source)) + 
  geom_vline(xintercept="2020-06", colour="red", linetype = "dashed") + # this is the difference
  theme(panel.background = element_rect(fill = "white", colour= "black")) + 
  theme(panel.grid.major = element_line(color = "gray"))
facet_concern_news_2

