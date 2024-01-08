# Set working directory and load necessary packages

#setwd("C:/Users/rittere5/OneDrive - Michigan State University/Witchs_Broom_Project/")
setwd("C:/Users/elean/OneDrive - Michigan State University/Witchs_Broom_Project/")

ad <- read.csv("alleledepth-merlotwb.txt", header = FALSE)
ad$V1 <- as.numeric(ad$V1)
mean(ad$V1, na.rm = TRUE)
min(ad$V1, na.rm = TRUE)
