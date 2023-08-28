########################### SET WORKING DIRECTORY AND LOAD PACKAGES ###########################
# Set working directory
setwd("C:/Users/rittere5/OneDrive - Michigan State University/Witchs_Broom_Project/phenotypic-data/") #Work working directory
#setwd("C:/Users/elean/OneDrive - Michigan State University/Witchs_Broom_Project/phenotypic-data/") #Home working directory

# Load packages
library(ggplot2)
library(plotrix)
library(stringr)
library("cowplot")
library(ggsignif)
library(gridExtra)

########################## LOAD IN DATA AND CLEAN UP FORMAT ##########################
# Load csv files
MWB <- read.csv("MWB-shoot-observations.csv", header = FALSE)
MWT <- read.csv("MWT-shoot-observations.csv", header = FALSE)
DWB <- read.csv("DWB-shoot-observations.csv", header = FALSE)
DWT <- read.csv("DWT-shoot-observations.csv", header = FALSE)

# Clean up header and data
MWB <- MWB[-c(1), ]
colnames(MWB) <- c("variety","date","shoot","internode","internode-length","lateral-meristem","blade-length","blade-width","petiole-length")
MWB <- MWB[-c(1,2), ]
MWB$`internode-length` <- as.numeric(MWB$`internode-length`)
MWB$`petiole-length` <- as.numeric(MWB$`petiole-length`)
MWB$`blade-length` <- as.numeric(MWB$`blade-length`)
MWB$`blade-width`<- as.numeric(MWB$`blade-width`)

MWT <- MWT[-c(1), ]
colnames(MWT) <- c("variety","date","shoot","internode","internode-length","lateral-meristem","blade-length","blade-width","petiole-length")
MWT <- MWT[-c(1,2), ]
MWT$`internode-length` <- as.numeric(MWT$`internode-length`)
MWT$`petiole-length` <- as.numeric(MWT$`petiole-length`)
MWT$`blade-length` <- as.numeric(MWT$`blade-length`)
MWT$`blade-width`<- as.numeric(MWT$`blade-width`)

DWB <- DWB[-c(1), ]
colnames(DWB) <- c("variety","date","shoot","internode","internode-length","lateral-meristem","blade-length","blade-width","petiole-length")
DWB <- DWB[-c(1,2), ]
DWB$`internode-length` <- as.numeric(DWB$`internode-length`)
DWB$`petiole-length` <- as.numeric(DWB$`petiole-length`)
DWB$`blade-length` <- as.numeric(DWB$`blade-length`)
DWB$`blade-width`<- as.numeric(DWB$`blade-width`)

DWT <- DWT[-c(1), ]
colnames(DWT) <- c("variety","date","shoot","internode","internode-length","lateral-meristem","blade-length","blade-width","petiole-length")
DWT <- DWT[-c(1,2), ]
DWT$`internode-length` <- as.numeric(DWT$`internode-length`)
DWT$`petiole-length` <- as.numeric(DWT$`petiole-length`)
DWT$`blade-length` <- as.numeric(DWT$`blade-length`)
DWT$`blade-width`<- as.numeric(DWT$`blade-width`)

########################## COMPARE INTERNODE LENGTHS ##########################
# Get means and standard errors
MWB.internode.mean = mean(MWB$`internode-length`)
MWB.internode.sterror = std.error(MWB$`internode-length`)

MWT.internode.mean = mean(MWT$`internode-length`)
MWT.internode.sterror = std.error(MWT$`internode-length`)

DWB.internode.mean = mean(DWB$`internode-length`)
DWB.internode.sterror = std.error(DWB$`internode-length`)

DWT.internode.mean = mean(DWT$`internode-length`)
DWT.internode.sterror = std.error(DWT$`internode-length`)

# Run t-test
a = MWB$`internode-length`
b = MWT$`internode-length`
c = DWB$`internode-length`
d = DWT$`internode-length`

ttest1 <- t.test(a,b)
ttest2 <- t.test(c,d)

# Make dataframe of means and standard errors
varieties <- c('Dakapo WT', 'Dakapo WB', 'Merlot WT', 'Merlot WB')
means <- c(DWT.internode.mean, DWB.internode.mean, MWT.internode.mean, MWB.internode.mean)
sterrors <- c(DWT.internode.sterror, DWB.internode.sterror, MWT.internode.sterror, MWB.internode.sterror)
internode.df <- data.frame(varieties, as.numeric(means), as.numeric(sterrors))

# Plot internode length data

#ggplot(internode.df, aes(x=as.factor(varieties), fill=as.factor(varieties), y=as.numeric(means))) +
  #geom_bar(stat="identity") +
  #scale_fill_manual(values = c("maroon", "magenta4", "maroon", "magenta4")) +
  #theme(legend.position = "none")

p = ggplot(internode.df, aes(x=as.factor(varieties), fill=as.factor(varieties), y=as.numeric(means))) +
  geom_bar(stat="identity") +
  scale_fill_manual(values = c("#00A0A3", "#0B676F", "#55548C", "#3B2951")) +
  theme_classic() +
  theme(legend.position = "none", 
        axis.title.x =element_blank(), 
        axis.title.y=element_text(colour="black", size=14),
        axis.text.x=element_text(colour="black", size=14),
        axis.text.y = element_text(colour="black", size=14)) +
  ylab("Internode Length (mm)") + 
  geom_errorbar(aes(x=varieties, ymin=means-sterrors, ymax=means+sterrors), width=0.2, alpha=0.8, size=1.0) +
  scale_x_discrete(labels = function(x) stringr::str_wrap(x, width = 5)) +
  scale_y_continuous(expand = c(0,0), limits=c(0,80)) 

p 

# Clear environment when done and reload csvs

########################## TEST OF VIOLIN PLOT - INTERNODE LENGTH AND PETIOLE LENGTH ##########################
df.all <- rbind(MWB, MWT, DWT, DWB)

dwt <- c("#0B676F")
dwb <- c("#77C3BF")
mwt <- c("#50386e")
mwb <- c("#7E7DB1")

#For internode length
p1 = ggplot(df.all, aes(x=factor(variety, level=c('Dakapo Wild Type', 'Dakapo WB', 'Merlot Wild Type', 'Merlot WB')), y=`internode-length`, fill=variety)) + 
  geom_violin(trim=FALSE) +
  scale_fill_manual(values = c(dwb, dwt, mwb, mwt)) +
  theme_classic() + 
  geom_point(position = position_jitter(seed = 19,width = 0.2), alpha = 0.5, shape = 20, fill = "darkgrey") +
  labs(y = "Internode Length (mm)", x = "") +
  theme(axis.title.x=element_blank(),
        legend.position = "none",
        axis.text.x=element_text(colour="black", size=11),
        axis.text.y=element_text(size=10),
        axis.title.y = element_text(colour="black", size = 12)) +
  scale_x_discrete(labels=c('Dakapo WT', 'Dakapo WB', 'Merlot WT', 'Merlot WB')) +
  scale_y_continuous(expand = c(0,0), limits = c(0, 225)) +
  geom_signif(
    comparisons = list(c("Dakapo WB", "Dakapo Wild Type"), c("Merlot WB", "Merlot Wild Type")),
    test= t.test,
    map_signif_level = TRUE, textsize = 5,
    y_position = 202
  ) +
  geom_signif(
    comparisons = list(c("Dakapo WB", "Merlot WB")),
    test= t.test,
    map_signif_level = TRUE, textsize = 5,
    y_position = 182
  ) +
  geom_signif(
    comparisons = list(c("Dakapo Wild Type", "Merlot Wild Type")),
    test= t.test,
    map_signif_level = TRUE, textsize = 5,
    y_position = 162
  ) +
  stat_summary(fun = "mean",
               geom = "crossbar", 
               width = 0.5,
               colour = "black")


#For petiole length
p2 <- ggplot(df.all, aes(x=factor(variety, level=c('Dakapo Wild Type', 'Dakapo WB', 'Merlot Wild Type', 'Merlot WB')), y=`petiole-length`, fill=variety)) + 
       geom_violin(trim=FALSE) +
       scale_fill_manual(values = c(dwb, dwt, mwb, mwt)) +
       theme_classic() + 
       geom_point(position = position_jitter(seed = 19,width = 0.2), alpha = 0.5, shape = 20, fill = "darkgrey") +
       labs(y = "Petiole Length (mm)", x = "") +
       theme(axis.title.x=element_blank(),
                         legend.position = "none",
                         axis.text.x=element_text(colour="black", size=11),
                         axis.text.y=element_text(size=10),
                         axis.title.y = element_text(colour="black", size = 12)) +
       scale_x_discrete(labels=c('Dakapo WT', 'Dakapo WB', 'Merlot WT', 'Merlot WB')) +
       scale_y_continuous(expand = c(0,0), limits = c(0, 200)) +
       geom_signif(
             comparisons = list(c("Dakapo WB", "Dakapo Wild Type"), c("Merlot WB", "Merlot Wild Type")),
             test= t.test,
             map_signif_level = TRUE, textsize = 5,
             y_position = 182
         ) +
  geom_signif(
    comparisons = list(c("Dakapo WB", "Merlot WB")),
    test= t.test,
    map_signif_level = TRUE, textsize = 5,
    y_position = 163
  ) +
  geom_signif(
    comparisons = list(c("Dakapo Wild Type", "Merlot Wild Type")),
    test= t.test,
    map_signif_level = TRUE, textsize = 5,
    y_position = 145
  ) +
  stat_summary(fun = "mean",
               geom = "crossbar", 
               width = 0.5,
               colour = "black")
  
########################## COMPARE PETIOLE LENGTH ##########################
# Get means and standard errors
MWB.p.mean = mean(MWB$`petiole-length`, na.rm = TRUE)
MWB.p.sterror = std.error(MWB$`petiole-length`, na.rm = TRUE)

MWT.p.mean = mean(MWT$`petiole-length`, na.rm = TRUE)
MWT.p.sterror = std.error(MWT$`petiole-length`, na.rm = TRUE)

DWB.p.mean = mean(DWB$`petiole-length`, na.rm = TRUE)
DWB.p.sterror = std.error(DWB$`petiole-length`, na.rm = TRUE)

DWT.p.mean = mean(DWT$`petiole-length`, na.rm = TRUE)
DWT.p.sterror = std.error(DWT$`petiole-length`, na.rm = TRUE)

# Run t-test
a = MWB$`petiole-length`
b = MWT$`petiole-length`
c = DWB$`petiole-length`
d = DWT$`petiole-length`

ttest1 <- t.test(a,b)
ttest2 <- t.test(c,d)

# Make dataframe of means and standard errors
varieties <- c('Dakapo WT', 'Dakapo WB', 'Merlot WT', 'Merlot WB')
means <- c(DWT.p.mean, DWB.p.mean, MWT.p.mean, MWB.p.mean)
sterrors <- c(DWT.p.sterror, DWB.p.sterror, MWT.p.sterror, MWB.p.sterror)
p.df <- data.frame(varieties, as.numeric(means), as.numeric(sterrors))

# Plot petiole length data

p = ggplot(p.df, aes(x=as.factor(varieties), fill=as.factor(varieties), y=as.numeric(means))) +
  geom_bar(stat="identity") +
  scale_fill_manual(values = c("#00A0A3", "#0B676F", "#55548C", "#3B2951")) +
  theme_classic() +
  theme(legend.position = "none", 
        axis.title.x =element_blank(), 
        axis.title.y=element_text(colour="black", size=14),
        axis.text.x=element_text(colour="black", size=14),
        axis.text.y = element_text(colour="black", size=14)) +
  ylab("Petiole Length (mm)") +  
  geom_errorbar(aes(x=varieties, ymin=means-sterrors, ymax=means+sterrors), width=0.2, alpha=0.8, size=1.0) +
  scale_x_discrete(labels = function(x) stringr::str_wrap(x, width = 5))
p + scale_y_continuous(expand = c(0,0), limits = c(0,110))  

# Clear environment when done and reload csvs
########################## SPLIT DATA APART BY NODES ##########################
MWB4 <- MWB[MWB$internode=='4',]
MWB5 <- MWB[MWB$internode=='5',]
MWB6 <- MWB[MWB$internode=='6',]
MWB7 <- MWB[MWB$internode=='7',]
MWB8 <- MWB[MWB$internode=='8',]
MWB9 <- MWB[MWB$internode=='9',]
MWB10 <- MWB[MWB$internode=='10',]
MWB11 <- MWB[MWB$internode=='11',]
MWB12 <- MWB[MWB$internode=='12',]
MWB13 <- MWB[MWB$internode=='13',]
MWB14 <- MWB[MWB$internode=='14',]
MWB15 <- MWB[MWB$internode=='15',]
MWB16 <- MWB[MWB$internode=='16',]

MWT4 <- MWT[MWT$internode=='4',]
MWT5 <- MWT[MWT$internode=='5',]
MWT6 <- MWT[MWT$internode=='6',]
MWT7 <- MWT[MWT$internode=='7',]
MWT8 <- MWT[MWT$internode=='8',]
MWT9 <- MWT[MWT$internode=='9',]
MWT10 <- MWT[MWT$internode=='10',]
MWT11 <- MWT[MWT$internode=='11',]
MWT12 <- MWT[MWT$internode=='12',]
MWT13 <- MWT[MWT$internode=='13',]
MWT14 <- MWT[MWT$internode=='14',]
MWT15 <- MWT[MWT$internode=='15',]
MWT16 <- MWT[MWT$internode=='16',]

DWB4 <- DWB[DWB$internode=='4',]
DWB5 <- DWB[DWB$internode=='5',]
DWB6 <- DWB[DWB$internode=='6',]
DWB7 <- DWB[DWB$internode=='7',]
DWB8 <- DWB[DWB$internode=='8',]
DWB9 <- DWB[DWB$internode=='9',]
DWB10 <-DWB[DWB$internode=='10',]
DWB11 <- DWB[DWB$internode=='11',]
DWB12 <- DWB[DWB$internode=='12',]
DWB13 <- DWB[DWB$internode=='13',]
DWB14 <- DWB[DWB$internode=='14',]
DWB15 <- DWB[DWB$internode=='15',]
DWB16 <- DWB[DWB$internode=='16',]

DWT4 <- DWT[DWT$internode=='4',]
DWT5 <- DWT[DWT$internode=='5',]
DWT6 <- DWT[DWT$internode=='6',]
DWT7 <- DWT[DWT$internode=='7',]
DWT8 <- DWT[DWT$internode=='8',]
DWT9 <- DWT[DWT$internode=='9',]
DWT10 <- DWT[DWT$internode=='10',]
DWT11 <- DWT[DWT$internode=='11',]
DWT12 <- DWT[DWT$internode=='12',]
DWT13 <- DWT[DWT$internode=='13',]
DWT14 <- DWT[DWT$internode=='14',]
DWT15 <- DWT[DWT$internode=='15',]
DWT16 <- DWT[DWT$internode=='16',]

########################## COMPARE BLADE LENGTH ##########################
# Need to split apart by nodes prior to running!

MWB4.bl.mean = mean(MWB4$`blade-length`, na.rm = TRUE)
MWB4.bl.sterror = std.error(MWB4$`blade-length`, na.rm = TRUE)
MWB5.bl.mean = mean(MWB5$`blade-length`, na.rm = TRUE)
MWB5.bl.sterror = std.error(MWB5$`blade-length`, na.rm = TRUE)
MWB6.bl.mean = mean(MWB6$`blade-length`, na.rm = TRUE)
MWB6.bl.sterror = std.error(MWB6$`blade-length`, na.rm = TRUE)
MWB7.bl.mean = mean(MWB7$`blade-length`, na.rm = TRUE)
MWB7.bl.sterror = std.error(MWB7$`blade-length`, na.rm = TRUE)
MWB8.bl.mean = mean(MWB8$`blade-length`, na.rm = TRUE)
MWB8.bl.sterror = std.error(MWB8$`blade-length`, na.rm = TRUE)
MWB9.bl.mean = mean(MWB9$`blade-length`, na.rm = TRUE)
MWB9.bl.sterror = std.error(MWB9$`blade-length`, na.rm = TRUE)
MWB10.bl.mean = mean(MWB10$`blade-length`, na.rm = TRUE)
MWB10.bl.sterror = std.error(MWB10$`blade-length`, na.rm = TRUE)
MWB11.bl.mean = mean(MWB11$`blade-length`, na.rm = TRUE)
MWB11.bl.sterror = std.error(MWB11$`blade-length`, na.rm = TRUE)
MWB12.bl.mean = mean(MWB12$`blade-length`, na.rm = TRUE)
MWB12.bl.sterror = std.error(MWB12$`blade-length`, na.rm = TRUE)
MWB13.bl.mean = mean(MWB13$`blade-length`, na.rm = TRUE)
MWB13.bl.sterror = std.error(MWB13$`blade-length`, na.rm = TRUE)
MWB14.bl.mean = mean(MWB14$`blade-length`, na.rm = TRUE)
MWB14.bl.sterror = std.error(MWB14$`blade-length`, na.rm = TRUE)
MWB15.bl.mean = mean(MWB15$`blade-length`, na.rm = TRUE)
MWB15.bl.sterror = std.error(MWB15$`blade-length`, na.rm = TRUE)
MWB16.bl.mean = mean(MWB16$`blade-length`, na.rm = TRUE)
MWB16.bl.sterror = std.error(MWB16$`blade-length`, na.rm = TRUE)

MWT4.bl.mean = mean(MWT4$`blade-length`, na.rm = TRUE)
MWT4.bl.sterror = std.error(MWT4$`blade-length`, na.rm = TRUE)
MWT5.bl.mean = mean(MWT5$`blade-length`, na.rm = TRUE)
MWT5.bl.sterror = std.error(MWT5$`blade-length`, na.rm = TRUE)
MWT6.bl.mean = mean(MWT6$`blade-length`, na.rm = TRUE)
MWT6.bl.sterror = std.error(MWT6$`blade-length`, na.rm = TRUE)
MWT7.bl.mean = mean(MWT7$`blade-length`, na.rm = TRUE)
MWT7.bl.sterror = std.error(MWT7$`blade-length`, na.rm = TRUE)
MWT8.bl.mean = mean(MWT8$`blade-length`, na.rm = TRUE)
MWT8.bl.sterror = std.error(MWT8$`blade-length`, na.rm = TRUE)
MWT9.bl.mean = mean(MWT9$`blade-length`, na.rm = TRUE)
MWT9.bl.sterror = std.error(MWT9$`blade-length`, na.rm = TRUE)
MWT10.bl.mean = mean(MWT10$`blade-length`, na.rm = TRUE)
MWT10.bl.sterror = std.error(MWT10$`blade-length`, na.rm = TRUE)
MWT11.bl.mean = mean(MWT11$`blade-length`, na.rm = TRUE)
MWT11.bl.sterror = std.error(MWT11$`blade-length`, na.rm = TRUE)
MWT12.bl.mean = mean(MWT12$`blade-length`, na.rm = TRUE)
MWT12.bl.sterror = std.error(MWT12$`blade-length`, na.rm = TRUE)
MWT13.bl.mean = mean(MWT13$`blade-length`, na.rm = TRUE)
MWT13.bl.sterror = std.error(MWT13$`blade-length`, na.rm = TRUE)
MWT14.bl.mean = mean(MWT14$`blade-length`, na.rm = TRUE)
MWT14.bl.sterror = std.error(MWT14$`blade-length`, na.rm = TRUE)
MWT15.bl.mean = mean(MWT15$`blade-length`, na.rm = TRUE)
MWT15.bl.sterror = std.error(MWT15$`blade-length`, na.rm = TRUE)
MWT16.bl.mean = mean(MWT16$`blade-length`, na.rm = TRUE)
MWT16.bl.sterror = std.error(MWT16$`blade-length`, na.rm = TRUE)

DWB4.bl.mean = mean(DWB4$`blade-length`, na.rm = TRUE)
DWB4.bl.sterror = std.error(DWB4$`blade-length`, na.rm = TRUE)
DWB5.bl.mean = mean(DWB5$`blade-length`, na.rm = TRUE)
DWB5.bl.sterror = std.error(DWB5$`blade-length`, na.rm = TRUE)
DWB6.bl.mean = mean(DWB6$`blade-length`, na.rm = TRUE)
DWB6.bl.sterror = std.error(DWB6$`blade-length`, na.rm = TRUE)
DWB7.bl.mean = mean(DWB7$`blade-length`, na.rm = TRUE)
DWB7.bl.sterror = std.error(DWB7$`blade-length`, na.rm = TRUE)
DWB8.bl.mean = mean(DWB8$`blade-length`, na.rm = TRUE)
DWB8.bl.sterror = std.error(DWB8$`blade-length`, na.rm = TRUE)
DWB9.bl.mean = mean(DWB9$`blade-length`, na.rm = TRUE)
DWB9.bl.sterror = std.error(DWB9$`blade-length`, na.rm = TRUE)
DWB10.bl.mean = mean(DWB10$`blade-length`, na.rm = TRUE)
DWB10.bl.sterror = std.error(DWB10$`blade-length`, na.rm = TRUE)
DWB11.bl.mean = mean(DWB11$`blade-length`, na.rm = TRUE)
DWB11.bl.sterror = std.error(DWB11$`blade-length`, na.rm = TRUE)
DWB12.bl.mean = mean(DWB12$`blade-length`, na.rm = TRUE)
DWB12.bl.sterror = std.error(DWB12$`blade-length`, na.rm = TRUE)
DWB13.bl.mean = mean(DWB13$`blade-length`, na.rm = TRUE)
DWB13.bl.sterror = std.error(DWB13$`blade-length`, na.rm = TRUE)
DWB14.bl.mean = mean(DWB14$`blade-length`, na.rm = TRUE)
DWB14.bl.sterror = std.error(DWB14$`blade-length`, na.rm = TRUE)
DWB15.bl.mean = mean(DWB15$`blade-length`, na.rm = TRUE)
DWB15.bl.sterror = std.error(DWB15$`blade-length`, na.rm = TRUE)
DWB16.bl.mean = mean(DWB16$`blade-length`, na.rm = TRUE)
DWB16.bl.sterror = std.error(DWB16$`blade-length`, na.rm = TRUE)

DWT4.bl.mean = mean(DWT4$`blade-length`, na.rm = TRUE)
DWT4.bl.sterror = std.error(DWT4$`blade-length`, na.rm = TRUE)
DWT5.bl.mean = mean(DWT5$`blade-length`, na.rm = TRUE)
DWT5.bl.sterror = std.error(DWT5$`blade-length`, na.rm = TRUE)
DWT6.bl.mean = mean(DWT6$`blade-length`, na.rm = TRUE)
DWT6.bl.sterror = std.error(DWT6$`blade-length`, na.rm = TRUE)
DWT7.bl.mean = mean(DWT7$`blade-length`, na.rm = TRUE)
DWT7.bl.sterror = std.error(DWT7$`blade-length`, na.rm = TRUE)
DWT8.bl.mean = mean(DWT8$`blade-length`, na.rm = TRUE)
DWT8.bl.sterror = std.error(DWT8$`blade-length`, na.rm = TRUE)
DWT9.bl.mean = mean(DWT9$`blade-length`, na.rm = TRUE)
DWT9.bl.sterror = std.error(DWT9$`blade-length`, na.rm = TRUE)
DWT10.bl.mean = mean(DWT10$`blade-length`, na.rm = TRUE)
DWT10.bl.sterror = std.error(DWT10$`blade-length`, na.rm = TRUE)
DWT11.bl.mean = mean(DWT11$`blade-length`, na.rm = TRUE)
DWT11.bl.sterror = std.error(DWT11$`blade-length`, na.rm = TRUE)
DWT12.bl.mean = mean(DWT12$`blade-length`, na.rm = TRUE)
DWT12.bl.sterror = std.error(DWT12$`blade-length`, na.rm = TRUE)
DWT13.bl.mean = mean(DWT13$`blade-length`, na.rm = TRUE)
DWT13.bl.sterror = std.error(DWT13$`blade-length`, na.rm = TRUE)
DWT14.bl.mean = mean(DWT14$`blade-length`, na.rm = TRUE)
DWT14.bl.sterror = std.error(DWT14$`blade-length`, na.rm = TRUE)
DWT15.bl.mean = mean(DWT15$`blade-length`, na.rm = TRUE)
DWT15.bl.sterror = std.error(DWT15$`blade-length`, na.rm = TRUE)
DWT16.bl.mean = mean(DWT16$`blade-length`, na.rm = TRUE)
DWT16.bl.sterror = std.error(DWT16$`blade-length`, na.rm = TRUE)

# Combine blade length data and plot
varieties <- c('Dakapo WT', 'Dakapo WB', 'Merlot WT', 'Merlot WB','Dakapo WT', 'Dakapo WB', 'Merlot WT', 'Merlot WB',
               'Dakapo WT', 'Dakapo WB', 'Merlot WT', 'Merlot WB','Dakapo WT', 'Dakapo WB', 'Merlot WT', 'Merlot WB',
               'Dakapo WT', 'Dakapo WB', 'Merlot WT', 'Merlot WB', 'Dakapo WT', 'Dakapo WB', 'Merlot WT', 'Merlot WB')
node <- c(4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,9,9,9,9)
means <- c(DWT4.bl.mean, DWB4.bl.mean, MWT4.bl.mean, MWB4.bl.mean,
           DWT5.bl.mean, DWB5.bl.mean, MWT5.bl.mean, MWB5.bl.mean,
           DWT6.bl.mean, DWB6.bl.mean, MWT6.bl.mean, MWB6.bl.mean,
           DWT7.bl.mean, DWB7.bl.mean, MWT7.bl.mean, MWB7.bl.mean,
           DWT8.bl.mean, DWB8.bl.mean, MWT8.bl.mean, MWB8.bl.mean,
           DWT9.bl.mean, DWB9.bl.mean, MWT9.bl.mean, MWB9.bl.mean)
sterrors <- c(DWT4.bl.sterror, DWB4.bl.sterror, MWT4.bl.sterror, MWB4.bl.sterror,
           DWT5.bl.sterror, DWB5.bl.sterror, MWT5.bl.sterror, MWB5.bl.sterror,
           DWT6.bl.sterror, DWB6.bl.sterror, MWT6.bl.sterror, MWB6.bl.sterror,
           DWT7.bl.sterror, DWB7.bl.sterror, MWT7.bl.sterror, MWB7.bl.sterror,
           DWT8.bl.sterror, DWB8.bl.sterror, MWT8.bl.sterror, MWB8.bl.sterror,
           DWT9.bl.sterror, DWB9.bl.sterror, MWT9.bl.sterror, MWB9.bl.sterror)
p.df <- data.frame(varieties, node, as.numeric(means), as.numeric(sterrors))

# Reorder data frame for legend
p.df$varieties <- factor(p.df$varieties, levels = c('Dakapo WT', 'Merlot WT', 'Merlot WB', 'Dakapo WB'))

# Plot data
plota <- ggplot(p.df, aes(x=as.factor(node), y=as.numeric(means))) +
  geom_point(aes(shape = varieties, color = varieties, size = 1, stroke = 0)) + 
  scale_shape_manual(values = c(16, 17, 17, 16)) +
  scale_color_manual(values = c("#0B676F","#3B2951" , "#55548C" , "#00A0A3")) +
  theme_classic() +
  theme(axis.title.x =element_text(colour="black", size=16), 
        axis.title.y=element_text(colour="black", size=16),
        axis.text.x=element_text(colour="black", size=16),
        axis.text.y = element_text(colour="black", size=14),
        legend.position = "none") +
  ylab("Blade Length (mm)") +
  xlab("Node") +
  guides(fill=guide_legend(title=NULL)) +
  guides(size = "none") +
  geom_errorbar(aes(ymin=means-sterrors, ymax=means+sterrors),width=0.1, alpha=0.8, size=0.1) +
  guides(colour = guide_legend(override.aes = list(size=5)))
  

########################## COMPARE BLADE WIDTH ##########################
# Need to split apart by nodes prior to running!

MWB4.bw.mean = mean(MWB4$`blade-width`, na.rm = TRUE)
MWB4.bw.sterror = std.error(MWB4$`blade-width`, na.rm = TRUE)
MWB5.bw.mean = mean(MWB5$`blade-width`, na.rm = TRUE)
MWB5.bw.sterror = std.error(MWB5$`blade-width`, na.rm = TRUE)
MWB6.bw.mean = mean(MWB6$`blade-width`, na.rm = TRUE)
MWB6.bw.sterror = std.error(MWB6$`blade-width`, na.rm = TRUE)
MWB7.bw.mean = mean(MWB7$`blade-width`, na.rm = TRUE)
MWB7.bw.sterror = std.error(MWB7$`blade-width`, na.rm = TRUE)
MWB8.bw.mean = mean(MWB8$`blade-width`, na.rm = TRUE)
MWB8.bw.sterror = std.error(MWB8$`blade-width`, na.rm = TRUE)
MWB9.bw.mean = mean(MWB9$`blade-width`, na.rm = TRUE)
MWB9.bw.sterror = std.error(MWB9$`blade-width`, na.rm = TRUE)
MWB10.bw.mean = mean(MWB10$`blade-width`, na.rm = TRUE)
MWB10.bw.sterror = std.error(MWB10$`blade-width`, na.rm = TRUE)
MWB11.bw.mean = mean(MWB11$`blade-width`, na.rm = TRUE)
MWB11.bw.sterror = std.error(MWB11$`blade-width`, na.rm = TRUE)
MWB12.bw.mean = mean(MWB12$`blade-width`, na.rm = TRUE)
MWB12.bw.sterror = std.error(MWB12$`blade-width`, na.rm = TRUE)
MWB13.bw.mean = mean(MWB13$`blade-width`, na.rm = TRUE)
MWB13.bw.sterror = std.error(MWB13$`blade-width`, na.rm = TRUE)
MWB14.bw.mean = mean(MWB14$`blade-width`, na.rm = TRUE)
MWB14.bw.sterror = std.error(MWB14$`blade-width`, na.rm = TRUE)
MWB15.bw.mean = mean(MWB15$`blade-width`, na.rm = TRUE)
MWB15.bw.sterror = std.error(MWB15$`blade-width`, na.rm = TRUE)
MWB16.bw.mean = mean(MWB16$`blade-width`, na.rm = TRUE)
MWB16.bw.sterror = std.error(MWB16$`blade-width`, na.rm = TRUE)

MWT4.bw.mean = mean(MWT4$`blade-width`, na.rm = TRUE)
MWT4.bw.sterror = std.error(MWT4$`blade-width`, na.rm = TRUE)
MWT5.bw.mean = mean(MWT5$`blade-width`, na.rm = TRUE)
MWT5.bw.sterror = std.error(MWT5$`blade-width`, na.rm = TRUE)
MWT6.bw.mean = mean(MWT6$`blade-width`, na.rm = TRUE)
MWT6.bw.sterror = std.error(MWT6$`blade-width`, na.rm = TRUE)
MWT7.bw.mean = mean(MWT7$`blade-width`, na.rm = TRUE)
MWT7.bw.sterror = std.error(MWT7$`blade-width`, na.rm = TRUE)
MWT8.bw.mean = mean(MWT8$`blade-width`, na.rm = TRUE)
MWT8.bw.sterror = std.error(MWT8$`blade-width`, na.rm = TRUE)
MWT9.bw.mean = mean(MWT9$`blade-width`, na.rm = TRUE)
MWT9.bw.sterror = std.error(MWT9$`blade-width`, na.rm = TRUE)
MWT10.bw.mean = mean(MWT10$`blade-width`, na.rm = TRUE)
MWT10.bw.sterror = std.error(MWT10$`blade-width`, na.rm = TRUE)
MWT11.bw.mean = mean(MWT11$`blade-width`, na.rm = TRUE)
MWT11.bw.sterror = std.error(MWT11$`blade-width`, na.rm = TRUE)
MWT12.bw.mean = mean(MWT12$`blade-width`, na.rm = TRUE)
MWT12.bw.sterror = std.error(MWT12$`blade-width`, na.rm = TRUE)
MWT13.bw.mean = mean(MWT13$`blade-width`, na.rm = TRUE)
MWT13.bw.sterror = std.error(MWT13$`blade-width`, na.rm = TRUE)
MWT14.bw.mean = mean(MWT14$`blade-width`, na.rm = TRUE)
MWT14.bw.sterror = std.error(MWT14$`blade-width`, na.rm = TRUE)
MWT15.bw.mean = mean(MWT15$`blade-width`, na.rm = TRUE)
MWT15.bw.sterror = std.error(MWT15$`blade-width`, na.rm = TRUE)
MWT16.bw.mean = mean(MWT16$`blade-width`, na.rm = TRUE)
MWT16.bw.sterror = std.error(MWT16$`blade-width`, na.rm = TRUE)

DWB4.bw.mean = mean(DWB4$`blade-width`, na.rm = TRUE)
DWB4.bw.sterror = std.error(DWB4$`blade-width`, na.rm = TRUE)
DWB5.bw.mean = mean(DWB5$`blade-width`, na.rm = TRUE)
DWB5.bw.sterror = std.error(DWB5$`blade-width`, na.rm = TRUE)
DWB6.bw.mean = mean(DWB6$`blade-width`, na.rm = TRUE)
DWB6.bw.sterror = std.error(DWB6$`blade-width`, na.rm = TRUE)
DWB7.bw.mean = mean(DWB7$`blade-width`, na.rm = TRUE)
DWB7.bw.sterror = std.error(DWB7$`blade-width`, na.rm = TRUE)
DWB8.bw.mean = mean(DWB8$`blade-width`, na.rm = TRUE)
DWB8.bw.sterror = std.error(DWB8$`blade-width`, na.rm = TRUE)
DWB9.bw.mean = mean(DWB9$`blade-width`, na.rm = TRUE)
DWB9.bw.sterror = std.error(DWB9$`blade-width`, na.rm = TRUE)
DWB10.bw.mean = mean(DWB10$`blade-width`, na.rm = TRUE)
DWB10.bw.sterror = std.error(DWB10$`blade-width`, na.rm = TRUE)
DWB11.bw.mean = mean(DWB11$`blade-width`, na.rm = TRUE)
DWB11.bw.sterror = std.error(DWB11$`blade-width`, na.rm = TRUE)
DWB12.bw.mean = mean(DWB12$`blade-width`, na.rm = TRUE)
DWB12.bw.sterror = std.error(DWB12$`blade-width`, na.rm = TRUE)
DWB13.bw.mean = mean(DWB13$`blade-width`, na.rm = TRUE)
DWB13.bw.sterror = std.error(DWB13$`blade-width`, na.rm = TRUE)
DWB14.bw.mean = mean(DWB14$`blade-width`, na.rm = TRUE)
DWB14.bw.sterror = std.error(DWB14$`blade-width`, na.rm = TRUE)
DWB15.bw.mean = mean(DWB15$`blade-width`, na.rm = TRUE)
DWB15.bw.sterror = std.error(DWB15$`blade-width`, na.rm = TRUE)
DWB16.bw.mean = mean(DWB16$`blade-width`, na.rm = TRUE)
DWB16.bw.sterror = std.error(DWB16$`blade-width`, na.rm = TRUE)

DWT4.bw.mean = mean(DWT4$`blade-width`, na.rm = TRUE)
DWT4.bw.sterror = std.error(DWT4$`blade-width`, na.rm = TRUE)
DWT5.bw.mean = mean(DWT5$`blade-width`, na.rm = TRUE)
DWT5.bw.sterror = std.error(DWT5$`blade-width`, na.rm = TRUE)
DWT6.bw.mean = mean(DWT6$`blade-width`, na.rm = TRUE)
DWT6.bw.sterror = std.error(DWT6$`blade-width`, na.rm = TRUE)
DWT7.bw.mean = mean(DWT7$`blade-width`, na.rm = TRUE)
DWT7.bw.sterror = std.error(DWT7$`blade-width`, na.rm = TRUE)
DWT8.bw.mean = mean(DWT8$`blade-width`, na.rm = TRUE)
DWT8.bw.sterror = std.error(DWT8$`blade-width`, na.rm = TRUE)
DWT9.bw.mean = mean(DWT9$`blade-width`, na.rm = TRUE)
DWT9.bw.sterror = std.error(DWT9$`blade-width`, na.rm = TRUE)
DWT10.bw.mean = mean(DWT10$`blade-width`, na.rm = TRUE)
DWT10.bw.sterror = std.error(DWT10$`blade-width`, na.rm = TRUE)
DWT11.bw.mean = mean(DWT11$`blade-width`, na.rm = TRUE)
DWT11.bw.sterror = std.error(DWT11$`blade-width`, na.rm = TRUE)
DWT12.bw.mean = mean(DWT12$`blade-width`, na.rm = TRUE)
DWT12.bw.sterror = std.error(DWT12$`blade-width`, na.rm = TRUE)
DWT13.bw.mean = mean(DWT13$`blade-width`, na.rm = TRUE)
DWT13.bw.sterror = std.error(DWT13$`blade-width`, na.rm = TRUE)
DWT14.bw.mean = mean(DWT14$`blade-width`, na.rm = TRUE)
DWT14.bw.sterror = std.error(DWT14$`blade-width`, na.rm = TRUE)
DWT15.bw.mean = mean(DWT15$`blade-width`, na.rm = TRUE)
DWT15.bw.sterror = std.error(DWT15$`blade-width`, na.rm = TRUE)
DWT16.bw.mean = mean(DWT16$`blade-width`, na.rm = TRUE)
DWT16.bw.sterror = std.error(DWT16$`blade-width`, na.rm = TRUE)

# Combine blade width data and plot
varieties.bw <- c('Dakapo WT', 'Dakapo WB', 'Merlot WT', 'Merlot WB','Dakapo WT', 'Dakapo WB', 'Merlot WT', 'Merlot WB',
               'Dakapo WT', 'Dakapo WB', 'Merlot WT', 'Merlot WB','Dakapo WT', 'Dakapo WB', 'Merlot WT', 'Merlot WB',
               'Dakapo WT', 'Dakapo WB', 'Merlot WT', 'Merlot WB', 'Dakapo WT', 'Dakapo WB', 'Merlot WT', 'Merlot WB')
node.bw <- c(4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,9,9,9,9)
means.bw <- c(DWT4.bw.mean, DWB4.bw.mean, MWT4.bw.mean, MWB4.bw.mean,
           DWT5.bw.mean, DWB5.bw.mean, MWT5.bw.mean, MWB5.bw.mean,
           DWT6.bw.mean, DWB6.bw.mean, MWT6.bw.mean, MWB6.bw.mean,
           DWT7.bw.mean, DWB7.bw.mean, MWT7.bw.mean, MWB7.bw.mean,
           DWT8.bw.mean, DWB8.bw.mean, MWT8.bw.mean, MWB8.bw.mean,
           DWT9.bw.mean, DWB9.bw.mean, MWT9.bw.mean, MWB9.bw.mean)
sterrors.bw <- c(DWT4.bw.sterror, DWB4.bw.sterror, MWT4.bw.sterror, MWB4.bw.sterror,
              DWT5.bw.sterror, DWB5.bw.sterror, MWT5.bw.sterror, MWB5.bw.sterror,
              DWT6.bw.sterror, DWB6.bw.sterror, MWT6.bw.sterror, MWB6.bw.sterror,
              DWT7.bw.sterror, DWB7.bw.sterror, MWT7.bw.sterror, MWB7.bw.sterror,
              DWT8.bw.sterror, DWB8.bw.sterror, MWT8.bw.sterror, MWB8.bw.sterror,
              DWT9.bw.sterror, DWB9.bw.sterror, MWT9.bw.sterror, MWB9.bw.sterror)
p.df2 <- data.frame(varieties.bw, node.bw, as.numeric(means.bw), as.numeric(sterrors.bw))

# Reorder data frame for legend
p.df2$varieties.bw <- factor(p.df2$varieties.bw, levels = c('Dakapo WT', 'Merlot WT', 'Merlot WB', 'Dakapo WB'))

# Plot data
plotb <- ggplot(p.df2, aes(x=as.factor(node.bw), y=as.numeric(means.bw))) +
  geom_point(aes(shape = varieties.bw, color = varieties.bw, size = 1, stroke = 0)) + 
  scale_shape_manual(values = c(16, 17, 17, 16)) +
  scale_color_manual(values = c("#0B676F","#3B2951" , "#55548C" , "#00A0A3")) +
  theme_classic() +
  theme(axis.title.x =element_text(colour="black", size=16), 
        axis.title.y=element_text(colour="black", size=16),
        axis.text.x=element_text(colour="black", size=16),
        axis.text.y = element_text(colour="black", size=14),
        legend.text = element_text(colour = "black", size=16),
        legend.title = element_blank(),
        legend.key.size = unit(1.5, "cm")) +
  ylab("Blade Width (mm)") +
  xlab("Node") +
  guides(fill=guide_legend(title=NULL)) +
  guides(size = "none") +
  geom_errorbar(aes(ymin=means.bw-sterrors.bw, ymax=means.bw+sterrors.bw),width=0.1, alpha=0.8, size=0.1) +
  guides(colour = guide_legend(override.aes = list(size=5)))

# Make plot for supplement
plot_grid(plota, plotb, ncol=2, labels="auto", rel_widths = c(2,3))

########################## T-TEST FOR LEAF DATA ##########################
# Need to split apart by nodes prior to running!
# Compare node 4
a = MWB4$`blade-length`
b = MWT4$`blade-length`
c = DWB4$`blade-length`
d = DWT4$`blade-length`

ttest1 <- t.test(a,b)
ttest2 <- t.test(c,d)

e = MWB4$`blade-width`
f = MWT4$`blade-width`
g = DWB4$`blade-width`
h = DWT4$`blade-width`

ttest3 <- t.test(e,f)
ttest4 <- t.test(g,h)

# Compare node 5
a = MWB5$`blade-length`
b = MWT5$`blade-length`
c = DWB5$`blade-length`
d = DWT5$`blade-length`

ttest1 <- t.test(a,b)
ttest2 <- t.test(c,d)

e = MWB5$`blade-width`
f = MWT5$`blade-width`
g = DWB5$`blade-width`
h = DWT5$`blade-width`

ttest3 <- t.test(e,f)
ttest4 <- t.test(g,h)

# Compare node 6
a = MWB6$`blade-length`
b = MWT$`blade-length`
c = DWB6$`blade-length`
d = DWT6$`blade-length`

ttest1 <- t.test(a,b)
ttest2 <- t.test(c,d)

e = MWB6$`blade-width`
f = MWT6$`blade-width`
g = DWB6$`blade-width`
h = DWT6$`blade-width`

ttest3 <- t.test(e,f)
ttest4 <- t.test(g,h)

# Compare node 7
a = MWB7$`blade-length`
b = MWT7$`blade-length`
c = DWB7$`blade-length`
d = DWT7$`blade-length`

ttest1 <- t.test(a,b)
ttest2 <- t.test(c,d)

e = MWB7$`blade-width`
f = MWT7$`blade-width`
g = DWB7$`blade-width`
h = DWT7$`blade-width`

ttest3 <- t.test(e,f)
ttest4 <- t.test(g,h)

# Compare node 8
a = MWB8$`blade-length`
b = MWT8$`blade-length`
c = DWB8$`blade-length`
d = DWT8$`blade-length`

ttest1 <- t.test(a,b)
ttest2 <- t.test(c,d)

e = MWB8$`blade-width`
f = MWT8$`blade-width`
g = DWB8$`blade-width`
h = DWT8$`blade-width`

ttest3 <- t.test(e,f)
ttest4 <- t.test(g,h)

# Compare node 9
a = MWB9$`blade-length`
b = MWT9$`blade-length`
c = DWB9$`blade-length`
d = DWT9$`blade-length`

ttest1 <- t.test(a,b)
ttest2 <- t.test(c,d)

e = MWB9$`blade-width`
f = MWT9$`blade-width`
g = DWB9$`blade-width`
h = DWT9$`blade-width`

ttest3 <- t.test(e,f)
ttest4 <- t.test(g,h)

########################## COMPARE LATERAL MERISTEM DATA ##########################
# Check to see what options are possible
unique(DWB$`lateral-meristem`)
unique(MWB$`lateral-meristem`)
unique(DWT$`lateral-meristem`)
unique(MWT$`lateral-meristem`)

# Get counts of each lateral meristem type
table(DWB$`lateral-meristem`)
table(MWB$`lateral-meristem`)
table(DWT$`lateral-meristem`)
table(MWT$`lateral-meristem`)

# Make data frame with counts
varieties <- c('Dakapo WT', 'Dakapo WT','Dakapo WT','Dakapo WT', 'Dakapo WT',
               'Dakapo WB', 'Dakapo WB','Dakapo WB','Dakapo WB', 'Dakapo WB',
               'Merlot WT', 'Merlot WT','Merlot WT','Merlot WT', 'Merlot WT',
               'Merlot WB', 'Merlot WB','Merlot WB','Merlot WB','Merlot WB')
lateral.meristem <- c('cluster', 'tendril', 'shoot', 'skip', 'scar',
                      'cluster', 'tendril', 'shoot', 'skip', 'scar' ,
                      'cluster', 'tendril', 'shoot', 'skip', 'scar' ,
                      'cluster', 'tendril', 'shoot', 'skip', 'scar')
count <- c(19,32,0,65,30,
           0,13,6,85,40,
           25,9,0,61,65,
           0,5,2,54,99)
percent <- c((19/146),(32/146),(0/146),(65/146),(30/146),
             (0/144),(13/144),(6/144),(85/144),(40/144),
             (25/160),(9/160),(0/160),(61/160),(65/160),
             (0/160),(5/160),(2/160),(54/160),(99/160))
meristem.df <- data.frame(varieties, lateral.meristem, as.numeric(count))

p3= ggplot(meristem.df, aes(fill=lateral.meristem, y=count, x=factor(varieties, level=c('Dakapo WT', 'Dakapo WB', 'Merlot WT', 'Merlot WB')))) + 
  geom_bar(position="fill", stat="identity") +
  theme_classic() +
  scale_fill_manual(values = c("#355070", "#6D597A", "#B56576", "#E56B6F", "#EAAC8B")) +
  theme(axis.title.x =element_blank(), 
        axis.title.y=element_blank(),
        axis.text.x=element_text(colour="black", size=11.65),
        axis.text.y = element_text(colour="black", size=11.65),
        legend.text = element_text(colour = "black", size=11.65),
        legend.key.size = unit(0.7, 'cm'),
        legend.title = element_text(colour="black", size=11.65)) +
  guides(fill=guide_legend(title="Lateral Meristem", reverse = TRUE)) + 
  scale_y_continuous(expand = c(0,0)) + 
  coord_flip(ylim = c(0, 1), clip = "off") +
  annotate("text", label = "3%", x = 4, y = 0.019, size = 3.5) +
  annotate("text", label = "34%", x = 4, y = 0.2, size = 3.5) +
  annotate("text", label = "1%", x = 4, y = 0.375, size = 3.5) +
  annotate("text", label = "62%", x = 4, y = 0.68, size = 3.5) +
  annotate("text", label = "6%", x = 3, y = 0.03, size = 3.5) +
  annotate("text", label = "38%", x = 3, y = 0.24, size = 3.5) +
  annotate("text", label = "41%", x = 3, y = 0.65, size = 3.5) +
  annotate("text", label = "16%", x = 3, y = 0.92, size = 3.5) +
  annotate("text", label = "9%", x = 2, y = 0.045, size = 3.5) +
  annotate("text", label = "59%", x = 2, y = 0.39, size = 3.5) +
  annotate("text", label = "4%", x = 2, y = 0.7, size = 3.5) +
  annotate("text", label = "28%", x = 2, y = 0.865, size = 3.5) +
  annotate("text", label = "22%", x = 1, y = 0.11, size = 3.5) +
  annotate("text", label = "44%", x = 1, y = 0.44, size = 3.5) +
  annotate("text", label = "21%", x = 1, y = 0.77, size = 3.5) +
  annotate("text", label = "13%", x = 1, y = 0.94, size = 3.5) 

#  annotate("text", label = "C", size=6, fontface = 2, x = 4.5, y = -0.15) #Could add if needed

p3

########################## COMBINE PLOTS INTO FIGURE ##########################
grid1 <- plot_grid(p1, p2, ncol = 2, nrow = 1, labels = "auto")
grid2 <- plot_grid(p3, ncol = 1, nrow = 1, labels = c('c'))
plot_grid(grid1, grid2, ncol=1, nrow=2)
