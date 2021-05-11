# Project: practice-loops
# Author: Omar Olivarez
# Last modified: 05/11/2021

# initialize variables
data_1 <- c(0, 0, 0.1, 0.15, 0.15, 0.16, 0.17, 0.15, 0.11, 0.1,
            0.2, 0.21, 0.16, 0.11, 0.12, 0.11, 0.11, 0.09, 0.15, 0.2)
data_2 <- c(10, 20, 21, 15, 15, 16, 17, 15, 11, 1,
            20, 21, 16, 11, 12, 11, 11, 9, 15, 20)
data_3 <- c(0, 0, 0.1, 0.151, 0.15, 0.162, 0.17, 0.15, 0.111, 0.1,
            0.2, 0.21, 0.16, 0.111, 0.12, 0.111, 0.11, 0.09, 0.15, 0.2)
data_4 <- c(100, 120, 121, 115, 115, 116, 117, 115, 111, 111,
            120, 121, 116, 111, 112, 111, 111, 119, 115, 120)
data_list <- list(data_1, data_2, data_3, data_4)
length(data_list)

# how you would normally run the t tests
t1 = t.test(data_1, data_2)
t1$p.value
t.test(data_1, data_3)
t.test(data_1, data_4)

# using the for loop method
for(v in data_list){
  t_test <- t.test(data_1, v)
  p <- t_test$p.value
  print(p)
}

