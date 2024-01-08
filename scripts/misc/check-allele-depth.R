# Set working directory and load necessary packages

setwd("C:/Users/rittere5/OneDrive - Michigan State University/Witchs_Broom_Project/")
#setwd("C:/Users/elean/OneDrive - Michigan State University/Witchs_Broom_Project/")

ad <- read.csv("alleledepth-merlotwb.txt", header = FALSE)
ad$V1 <- as.numeric(ad$V1)
mean(ad$V1, na.rm = TRUE)
min(ad$V1, na.rm = TRUE)

ad1 <- read.csv("alleledepth-merlotwt.txt", header = FALSE)
ad1$V1 <- as.numeric(ad1$V1)
mean(ad1$V1, na.rm = TRUE)
min(ad1$V1, na.rm = TRUE)

ad2 <- read.csv("alleledepth-dakapowb.txt", header = FALSE)
ad2$V1 <- as.numeric(ad2$V1)
mean(ad2$V1, na.rm = TRUE)
min(ad2$V1, na.rm = TRUE)

ad3 <- read.csv("alleledepth-dakapowt.txt", header = FALSE)
ad3$V1 <- as.numeric(ad3$V1)
mean(ad3$V1, na.rm = TRUE)
min(ad3$V1, na.rm = TRUE)

# Mean allele depth ranges from 26.66-29.79.
# To ensure that complex heterozygous sites are not filtered, we will be removing sites where
# the alt allele depth is fewer than 6 reads.