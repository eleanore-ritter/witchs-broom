# Set working directory and load packages
setwd("C:/Users/rittere5/OneDrive - Michigan State University/Witchs_Broom_Project/landmarking/") #Work working directory
#setwd("C:/Users/elean/OneDrive - Michigan State University/Witchs_Broom_Project/landmarking/")
library(ggplot2)
library(shapes)
library(reshape2)
library(dplyr)
library(gridExtra)
library("cowplot")
library(plotrix)
library(stringr)
library(ggsignif)
library(Momocs)
library(ggnewscale)
library(viridis)

########################## 1 LOAD DATA IN AND RUN INITIAL ANALYSES ##########################

#Load data in
files<-list.files()[grepl('coords\\d+\\.txt',list.files())]
tmp1<-read.csv(files[1],sep="",header=FALSE)
coords<-array(dim=c(dim(tmp1),length(files)))
for(i in seq_along(files)){
  coords[,,i]<-as.matrix(read.csv(files[i],sep="",header=FALSE))
}

#Run procGPA and make eigenleaves with shapepca
gpa <- procGPA(coords, reflect=TRUE)
scaled <- procGPA(coords, reflect=TRUE, scale = TRUE)
shapepca(gpa, joinline=c(1:21,1)) #Need to fix joinline
shapepca(gpa, pcno=c(1,2,3), joinline=c(1,6, 14, 15, 16, 17, 18, 19, 20, 21, 13, 4), mag=0.5)

#Extract out and plot rotated points
tmp2 <- gpa$rotated

rotated <- data.frame(id=rep(files,each=dim(tmp2)[1]),
           landmark=seq_len(dim(tmp2)[1]),
           do.call(rbind,asplit(tmp2,3)))

ggplot(rotated, aes(x=X1, y=X2)) +
  geom_point(size=2, aes(color=landmark)) +
  theme_classic() +
  coord_fixed() +
  theme(aspect.ratio = 1)

########################## 2 CHECK ONE FILE ##########################
#Load in file
c1 <- read.csv("DWT-1-1-2coords1.txt", sep="" ,header = FALSE)
#Visualize points
ggplot(c1, aes(x=V1, y=V2)) +
  geom_point(size=2) +
  theme_classic() +
  coord_fixed() +
  theme(aspect.ratio = 1)

########################## 3 RESTRUCTURING ROTATED DATA ##########################
#Make empty dataframe
df <- data.frame(matrix(ncol = 45, nrow = 237))

#Rename columns
cn <- c("sample", "shoot", "node", "x1", "y1", "x2", "y2", "x3", "y3", "x4", "y4",
              "x5", "y5", "x6", "y6", "x7", "y7", "x8", "y8", "x9", "y9", "x10", "y10",
              "x11", "y11", "x12", "y12", "x13", "y13", "x14", "y14", "x15", "y15",
              "x16", "y16", "x17", "y17", "x18", "y18", "x19", "y19", "x20", "y20",
              "x21", "y21")
colnames(df) <- cn

#Get lists for sample, shoot, and node
sample <- gsub( "-.*", "", files)
shoot <- substring(files,5,5)
tmpnode <- gsub( ".*coords", "", files)
node <- gsub(".txt", "", tmpnode)
rm(tmpnode)

#Move descriptor lists into dataframe
df$sample <- sample
df$shoot <- shoot
df$node <- node

#Modify coordinates to be shape needed (wide and not long)
coords1 <- select(rotated, c("X1", "X2"))
coords.list <- split(coords1, seq(nrow(coords1)))
head(coords1) # Double check that it worked
head(coords.list) # Double check that it worked
coords.df <- as.data.frame(matrix(unlist(coords.list),nrow=237,byrow=TRUE)) #Turn list into dataframe with proper dimensions

#Move coordinates into dataframe (not super elegant, just had to get it done)
df$x1 <- coords.df$V1
df$y1 <- coords.df$V2
df$x2 <- coords.df$V3
df$y2 <- coords.df$V4
df$x3 <- coords.df$V5
df$y3 <- coords.df$V6
df$x4 <- coords.df$V7
df$y4 <- coords.df$V8
df$x5 <- coords.df$V9
df$y5 <- coords.df$V10
df$x6 <- coords.df$V11
df$y6 <- coords.df$V12
df$x7 <- coords.df$V13
df$y7 <- coords.df$V14
df$x8 <- coords.df$V15
df$y8 <- coords.df$V16
df$x9 <- coords.df$V17
df$y9 <- coords.df$V18
df$x10 <- coords.df$V19
df$y10 <- coords.df$V20
df$x11 <- coords.df$V21
df$y11 <- coords.df$V22
df$x12 <- coords.df$V23
df$y12 <- coords.df$V24
df$x13 <- coords.df$V25
df$y13 <- coords.df$V26
df$x14 <- coords.df$V27
df$y14 <- coords.df$V28
df$x15 <- coords.df$V29
df$y15 <- coords.df$V30
df$x16 <- coords.df$V31
df$y16 <- coords.df$V32
df$x17 <- coords.df$V33
df$y17 <- coords.df$V34
df$x18 <- coords.df$V35
df$y18 <- coords.df$V36
df$x19 <- coords.df$V37
df$y19 <- coords.df$V38
df$x20 <- coords.df$V39
df$y20 <- coords.df$V40
df$x21 <- coords.df$V41
df$y21 <- coords.df$V42 #Ugly, but done

########################## 4A RESTRUCTURING RAW DATA FOR CALCULATIONS ##########################
#Make empty dataframe
df <- data.frame(matrix(ncol = 45, nrow = 275))

#Rename columns
cn <- c("sample", "shoot", "node", "x1", "y1", "x2", "y2", "x3", "y3", "x4", "y4",
        "x5", "y5", "x6", "y6", "x7", "y7", "x8", "y8", "x9", "y9", "x10", "y10",
        "x11", "y11", "x12", "y12", "x13", "y13", "x14", "y14", "x15", "y15",
        "x16", "y16", "x17", "y17", "x18", "y18", "x19", "y19", "x20", "y20",
        "x21", "y21")
colnames(df) <- cn

#Get lists for sample, shoot, and node
sample <- gsub( "-.*", "", files)
shoot <- substring(files,5,5)
tmpnode <- gsub( ".*coords", "", files)
node <- gsub(".txt", "", tmpnode)
rm(tmpnode)

#Modify coordinates to be shape needed (wide and not long) and add all data to datafram
tmp<-matrix(aperm(coords,c(3,2,1)),dim(coords)[3],prod(dim(coords)[1:2]))
df<-do.call(data.frame,setNames(asplit(tmp,2),paste0(c('x','y'),rep(1:dim(coords)[1],each=2))))
df$sample <- sample
df$shoot <- shoot
df$node <- node
df<-df[,c('sample','shoot','node',paste0(c('x','y'),rep(1:dim(coords)[1],each=2)))]

########################## 4B CALCULATE TOTAL LEAF AREA ##########################
# MAKE SURE YOU ARE USING RAW DATA!
# Code from Chitwood et al. 2021 https://github.com/DanChitwood/grapevine_climate_allometry/blob/master/Code/figure1.R 

# Attach dataframe with raw data and use Dan's equation to calculate total leaf area
attach(df)

df$all_area <- (0.5*abs(
  
  (x4*y3 + x3*y2 + x2*y1 + x1*y6 + x6*y14 + x14*y15 + x15*y16 + x16*y17 + x17*y18 + x18*y19 + x19*y20 + x20*y21 + x21*y13 + x13*y4) - 
    
    (y4*x3 + y3*x2 + y2*x1 + y1*x6 + y6*x14 + y14*x15 + y15*x16 + y16*x17 + y17*x18 + y18*x19 + y19*x20 + y20*x21 + y21*x13 + y13*x4) 
  
))

detach(df)

# Plot total leaf area to compare samples
ggplot(df, aes(x=all_area, color=sample, fill=sample)) +
  geom_histogram(binwidth = 1, alpha=0.75, position="stack") +
  scale_color_manual(values = c("#77C3BF", "#0B676F", "#7E7DB1", "#3B2951")) +
  scale_fill_manual(values = c("#77C3BF", "#0B676F", "#7E7DB1", "#3B2951")) +
  theme_classic()  +
  theme(axis.title.x=element_text(colour="black", size=14),
        axis.title.y=element_text(colour="black", size=14),
        axis.text.x=element_text(colour="black", size=14),
        axis.text.y = element_text(colour="black", size=14)) +
  labs(x = bquote('Leaf Area'~(cm^2)), y = "Count") +
  scale_y_continuous(expand = c(0,0)) +
  scale_x_continuous(expand = c(0,0))

# Plot total leaf area as a violin plot
dwt <- c("#0B676F")
dwb <- c("#77C3BF")
mwt <- c("#50386e")
mwb <- c("#7E7DB1")
area.breaks <- as.numeric(c("0", "25", "50", "75", "100"))

p5 <- ggplot(df, aes(x=factor(sample, level=c('DWT', 'DWB', 'MWT', 'MWB')), y=all_area, fill=sample)) + 
  geom_violin(trim=FALSE) +
  scale_fill_manual(values = c(dwb, dwt, mwb, mwt)) +
  theme_classic() + 
  geom_point(position = position_jitter(seed = 19,width = 0.2), alpha = 0.5, shape = 20, fill = "darkgrey") +
  labs(y = bquote('Leaf Area'~(cm^2)), x = "") +
  theme(axis.title.x=element_blank(),
        legend.position = "none",
        axis.text.x=element_text(colour="black", size=9),
        axis.text.y=element_text(size=8),
        axis.title.y = element_text(colour="black", size = 10)) +
  scale_x_discrete(labels=c("Dakapo WT", "Dakapo WB", "Merlot WT", "Merlot WB")) +
  scale_y_continuous(expand = c(0,0), limits = c(0, 130), breaks = area.breaks) +
  geom_signif(
    comparisons = list(c("DWB", "DWT"), c("MWB", "MWT")),
    test= t.test,
    map_signif_level = TRUE, textsize = 4,
    y_position = 119) + 
  geom_signif(
    comparisons = list(c("DWB", "MWB")),
    test= t.test,
    map_signif_level = TRUE, textsize = 3,
    y_position = 109) + 
  geom_signif(
    comparisons = list(c("DWT", "MWT")),
    test= t.test,
    map_signif_level = TRUE, textsize = 4,
    y_position = 97.5) + 
  stat_summary(fun = "mean",
               geom = "crossbar", 
               width = 0.5,
               colour = "black")

# Comparing total leaf area between samples AT SPECIFIC NODES
nodes<-unique(df$node)
nodes<-nodes[nodes!="14"] #Exclude node 14 because it is not present in all samples

# ttests<-matrix(list(),length(nodes),2)
# rownames(ttests)<-nodes
# colnames(ttests)<-c("D","M")
# for(i in nodes){
#   inds<-df$node==i
#   ttests[[i,1]]<-tryCatch(t.test(df$all_area[inds&df$sample=="DWT"],
#                                  df$all_area[inds&df$sample=="DWB"]),
#                           error=function(e) list())
#   ttests[[i,2]]<-tryCatch(t.test(df$all_area[inds&df$sample=="MWT"],
#                                  df$all_area[inds&df$sample=="MWB"]),
#                           error=function(e) list())
# }
# lapply(ttests,'[[','p.value')

ttests<-matrix(NA,length(nodes),2)
rownames(ttests)<-nodes
colnames(ttests)<-c("D","M")
for(i in nodes){
  inds<-df$node==i
  ttests[i,1]<-tryCatch(t.test(df$all_area[inds&df$sample=="DWT"],
                               df$all_area[inds&df$sample=="DWB"])$p.value,
                        error=function(e) NA)
  ttests[i,2]<-tryCatch(t.test(df$all_area[inds&df$sample=="MWT"],
                               df$all_area[inds&df$sample=="MWB"])$p.value,
                        error=function(e) NA)
}

# Comparing total leaf area between samples AT ALL NODES
## Get means and standard errors
DWTLA = df[df$sample== "DWT",]
DWTLA.mean = mean(DWTLA$all_area)
DWTLA.sterror = std.error(DWTLA$all_area)

DWBLA = df[df$sample== "DWB",]
DWBLA.mean = mean(DWBLA$all_area)
DWBLA.sterror = std.error(DWBLA$all_area)

MWTLA = df[df$sample== "MWT",]
MWTLA.mean = mean(MWTLA$all_area)
MWTLA.sterror = std.error(MWTLA$all_area)

MWBLA = df[df$sample== "MWB",]
MWBLA.mean = mean(MWBLA$all_area)
MWBLA.sterror = std.error(MWBLA$all_area)

## Run t-test
a = DWTLA$all_area
b = DWBLA$all_area
c = MWTLA$all_area
d = MWBLA$all_area

ttestd <- t.test(a,b)
ttestm <- t.test(c,d)
ttestwb <- t.test(b,d)
ttestwt <- t.test(a,c)

########################## 4C CALCULATE LN(VEIN AREA / BLADE AREA) AND COMPARE TO LEAF AREA ##########################
# MAKE SURE 1, 4A, AND 4B HAVE BEEN RUN!
# Code from Chitwood et al. 2021 https://github.com/DanChitwood/grapevine_climate_allometry/blob/master/Code/figure1.R 

# Calculate the area of the proximal veins

attach(df)

df$prox <- (0.5*abs(
  
  (x2*y1 + x1*y6 + x6*y14 + x14*y5 + x5*y15 + x15*y7 + x7*y2) -
    
    (y2*x1 + y1*x6 + y6*x14 + y14*x5 + y5*x15 + y15*x7 + y7*x2)
  
))

detach(df)

# Calculate the area of the distal veins

attach(df)

df$dist <- (0.5*abs(
  
  (x3*y2 + x2*y9 + x9*y17 + x17*y8 + x8*y18 + x18*y10 + x10*y3) -
    
    (y3*x2 + y2*x9 + y9*x17 + y17*x8 + y8*x18 + y18*x10 + y10*x3)
  
))

detach(df)

# Calculate the area of the midveins

attach(df)

df$mid <- (0.5*abs(
  
  (x4*y3 + x3*y12 + x12*y20 + x20*y11 + x11*y21 + x21*y13 + x13*y4) -
    
    (y4*x3 + y3*x12 + y12*x20 + y20*x11 + y11*x21 + y21*x13 + y13*x4)
  
))

detach(df)

# Calculate overall vein area as the sum of the proximal, distal, and midveins

df$veins <- df$prox + df$dist + df$mid

# Calculate blade area as the overall area of the leaf minus vein area

df$blade <- df$all_area - df$veins

# Calculate vein-to-blade ratio 
# Use natural log transformation

df$veins_to_blade <- log(df$veins / df$blade)
df$log_all_area <- log(df$all_area)

# Plot log(vein/blade) against log(all area)
# We expect a straight line based on Chitwood et al. 2021

# Set colors
dwt <- c("#0B676F")
dwb <- c("#77C3BF")
mwt <- c("#50386e")
mwb <- c("#7E7DB1")
grey <- c("#D3D3D3")
black <-c ("#000000")

ggplot(df, aes(x=log_all_area, y=veins_to_blade, color=sample)) +
  geom_point(shape=20, size = 2) +
  scale_color_manual(values = c(dwb, dwt, mwb, mwt)) +
  theme_classic() +
  labs(x="ln(Total Leaf Area)", y="ln(Vein Area / Blade Area)")

#With linear regression
model <- lm(veins_to_blade~log_all_area, data=df)
summary(model)

ggplot(df, aes(x=log_all_area, y=veins_to_blade)) +
  geom_point(shape=20, size = 2, aes(color=sample)) +
  scale_color_manual(values = c(dwb, dwt, mwb, mwt)) +
  theme_classic() +
  labs(x="ln(Total Leaf Area)", y="ln(Vein Area / Blade Area)") +
  geom_smooth(method='lm')

#Plot ln(Vein-to-blade area) as a violin plot
p6 <- ggplot(df, aes(x=factor(sample, level=c('DWT', 'DWB', 'MWT', 'MWB')), y=veins_to_blade, fill=sample)) + 
  geom_violin(trim=FALSE) +
  scale_fill_manual(values = c(dwb, dwt, mwb, mwt)) +
  theme_classic() + 
  geom_point(position = position_jitter(seed = 19,width = 0.2), alpha = 0.5, shape = 20, fill = "darkgrey") +
  labs(y = "ln(Vein Area / Blade Area)", x = "") +
  theme(axis.title.x=element_blank(),
        legend.position = "none",
        axis.text.x=element_text(colour="black", size=9),
        axis.text.y=element_text(size=8),
        axis.title.y = element_text(colour="black", size = 10)) +
  scale_x_discrete(labels=c("Dakapo WT", "Dakapo WB", "Merlot WT", "Merlot WB")) +
  scale_y_continuous(expand = c(0,0), limits = c(-4.3, -1.51)) +
    geom_signif(
    comparisons = list(c("DWB", "DWT"), c("MWB", "MWT")),
    test= t.test,
    map_signif_level = TRUE, textsize = 4,
    y_position = -1.75) + 
  geom_signif(
    comparisons = list(c("DWB", "MWB")),
    test= t.test,
    map_signif_level = TRUE, textsize = 4,
    y_position = -2.02) + 
  geom_signif(
    comparisons = list(c("DWT", "MWT")),
    test= t.test,
    map_signif_level = TRUE, textsize = 4,
    y_position = -2.28) + 
  stat_summary(fun = "mean",
                   geom = "crossbar", 
                   width = 0.5,
                   colour = "black")
## Run t-test
a = df[df$sample=="DWT",]
b = df[df$sample=="DWB",]
c = df[df$sample=="MWT",]
d = df[df$sample=="MWB",]

ttestdakapo <- t.test(a$veins_to_blade,b$veins_to_blade)
ttestmerlot <- t.test(c$veins_to_blade,d$veins_to_blade)
ttestwb <- t.test(b$veins_to_blade,d$veins_to_blade)
ttestwt <- t.test(a$veins_to_blade, c$veins_to_blade)

########################## 4D COMPARE OUR DATA WITH CHITWOOD ET AL. 2021 ##########################
# MAKE SURE 1, 4A, 4B, AND 4C HAVE BEEN RUN!
# Code from Chitwood et al. 2021 https://github.com/DanChitwood/grapevine_climate_allometry/blob/master/Code/figure1.R

# Add in dataset from Chitwood et al. 2021
C2021 <- read.delim("Chitwood-2021-dataset.txt", header=TRUE)

# Attach dataframe with raw data and use Dan's equation to calculate total leaf area
attach(C2021)

C2021$all_area <- (0.5*abs(
  
  (x4*y3 + x3*y2 + x2*y1 + x1*y6 + x6*y14 + x14*y15 + x15*y16 + x16*y17 + x17*y18 + x18*y19 + x19*y20 + x20*y21 + x21*y13 + x13*y4) - 
    
    (y4*x3 + y3*x2 + y2*x1 + y1*x6 + y6*x14 + y14*x15 + y15*x16 + y16*x17 + y17*x18 + y18*x19 + y19*x20 + y20*x21 + y21*x13 + y13*x4) 
  
))/(px2_cm2)

detach(C2021)

# Calculate the area of the proximal veins

attach(C2021)

C2021$prox <- (0.5*abs(
  
  (x2*y1 + x1*y6 + x6*y14 + x14*y5 + x5*y15 + x15*y7 + x7*y2) -
    
    (y2*x1 + y1*x6 + y6*x14 + y14*x5 + y5*x15 + y15*x7 + y7*x2)
  
))/(px2_cm2)

detach(C2021)

# Calculate the area of the distal veins

attach(C2021)

C2021$dist <- (0.5*abs(
  
  (x3*y2 + x2*y9 + x9*y17 + x17*y8 + x8*y18 + x18*y10 + x10*y3) -
    
    (y3*x2 + y2*x9 + y9*x17 + y17*x8 + y8*x18 + y18*x10 + y10*x3)
  
))/(px2_cm2)

detach(C2021)

# Calculate the area of the midveins

attach(C2021)

C2021$mid <- (0.5*abs(
  
  (x4*y3 + x3*y12 + x12*y20 + x20*y11 + x11*y21 + x21*y13 + x13*y4) -
    
    (y4*x3 + y3*x12 + y12*x20 + y20*x11 + y11*x21 + y21*x13 + y13*x4)
  
))/(px2_cm2)

detach(C2021)

# Calculate overall vein area as the sum of the proximal, distal, and midveins

C2021$veins <- C2021$prox + C2021$dist + C2021$mid

# Calculate blade area as the overall area of the leaf minus vein area

C2021$blade <- C2021$all_area - C2021$veins

# Calculate vein-to-blade ratio 
# Use natural log transformation

C2021$veins_to_blade <- log(C2021$veins / C2021$blade)
C2021$log_all_area <- log(C2021$all_area)
C2021$sample <- c("Chitwood 2021")

# Plot Chitwood et al. 2021 data with our data
ggplot(C2021, aes(x=log_all_area, y=veins_to_blade, color=sample)) +
  labs(x="ln(Total Leaf Area)", y="ln(Vein Area / Blade Area)") +
  geom_point(shape=20, size = 1, alpha=0.5) +
  geom_point(data=df, shape=20, size=2, alpha=1) +
  geom_smooth(data=C2021, color=black, size=0.5) +
  scale_color_manual(values = c(grey, dwt, dwb, mwt,mwb),
                     breaks = c('Chitwood 2021', 'DWT', 'DWB', 'MWT', 'MWB'),
                     labels = c('Chitwood 2021', 'Dakapo WT', 'Dakapo WB', 'Merlot WT', 'Merlot WB')) +
  theme_classic() +
  theme(axis.text.x=element_text(size=8),
        axis.text.y=element_text(size=8),
        axis.title.x = element_text(colour="black", size = 10),
        axis.title.y = element_text(colour="black", size = 10),
        legend.title = element_blank(),
        legend.text = element_text(size=8)) + 
  guides(colour = guide_legend(override.aes = list(size=4)))

########################## 5 RESTRUCTURING RAW DATA IN LONG FORMAT ##########################
#Make empty dataframe
df.p <- data.frame(matrix(ncol = 6, nrow = 4977))

#Rename columns
cn1 <- c("sample", "shoot", "node", "landmark", "x", "y")
colnames(df.p) <- cn1

#Get lists for sample, shoot, and node
sample <- gsub( "-.*", "", files)
shoot <- substring(files,5,5)
tmpnode <- gsub( ".*coords", "", files)
node <- gsub(".txt", "", tmpnode)
rm(tmpnode)

#Modify coordinates to be shape needed (long) and add all data to dataframe
tmp<-matrix(aperm(coords,c(3,2,1)),dim(coords)[3],prod(dim(coords)[1:2]))
df<-do.call(data.frame,setNames(asplit(tmp,2),paste0(c('x','y'),rep(1:dim(coords)[1],each=2))))
df.p$sample <- sample
df.p$shoot <- shoot
df.p$node <- node
df<-df[,c('sample','shoot','node',paste0(c('x','y'),rep(1:dim(coords)[1],each=2)))]

df.p<-as.data.frame(do.call(rbind,asplit(coords,3)))
nlm<-dim(coords)[1]
df.p[c('sample','shoot','node','landmark','x','y')]<-
  list(rep(sample,each=nlm),
       rep(shoot,each=nlm),
       rep(node,each=nlm),
       rep(1:nlm,dim(coords)[3]),
       df.p$V1,
       df.p$V2)
df.p$V1<-NULL;df.p$V2<-NULL

########################## 6 ROTATE AND PLOT POINTS WITHOUT SCALING ##########################
#Run procGPA and make eigenleaves with shapepca
gpa <- procGPA(coords, reflect=TRUE, scale=FALSE)
shapepca(gpa, joinline=c(1:21,1)) #Need to fix joinline

#Extract out rotated points
tmp2 <- gpa$rotated

rotated <- data.frame(id=rep(files,each=dim(tmp2)[1]),
                      landmark=seq_len(dim(tmp2)[1]),
                      do.call(rbind,asplit(tmp2,3)))

#Add columns needed to dataframe
rotated$sample <- gsub( "-.*", "", rotated$id)
rotated$shoot <- substring(rotated$id,5,5)
tmpnode <- gsub( ".*coords", "", rotated$id)
rotated$node <- gsub(".txt", "", tmpnode)
rm(tmpnode)

#Plot data
ggplot(rotated, aes(x=X1, y=X2)) +
  geom_point(size=2, aes(color=sample), alpha=0.75) +
  theme_classic() +
  coord_fixed() +
  theme(aspect.ratio = 1) +
  scale_color_manual(values = c("#77C3BF", "#0B676F", "#7E7DB1", "#3B2951")) +
  scale_fill_manual(values = c("#77C3BF", "#0B676F", "#7E7DB1", "#3B2951"))


########################## 7 CALCULATE LANDMARK AVERAGES AND PLOT ##########################
#Run procGPA and make eigenleaves with shapepca
gpa <- procGPA(coords, reflect=TRUE, scale=FALSE)
shapepca(gpa, joinline=c(1:21,1)) #Need to fix joinline

#Extract out rotated points
tmp2 <- gpa$rotated

rotated <- data.frame(id=rep(files,each=dim(tmp2)[1]),
                      landmark=seq_len(dim(tmp2)[1]),
                      do.call(rbind,asplit(tmp2,3)))

#Add columns needed to dataframe
rotated$sample <- gsub( "-.*", "", rotated$id)
rotated$shoot <- substring(rotated$id,5,5)
tmpnode <- gsub( ".*coords", "", rotated$id)
rotated$node <- gsub(".txt", "", tmpnode)
rm(tmpnode)

#Plot data to check
ggplot(rotated, aes(x=X1, y=X2)) +
  geom_point(size=2, aes(color=sample), alpha=0.75) +
  theme_classic() +
  coord_fixed() +
  theme(aspect.ratio = 1) +
  scale_color_manual(values = c("#77C3BF", "#0B676F", "#7E7DB1", "#3B2951")) +
  scale_fill_manual(values = c("#77C3BF", "#0B676F", "#7E7DB1", "#3B2951"))

#Calculate average landmark values at each node
averages <- aggregate(rotated[,c("X1","X2")],rotated[,c("sample","node","landmark")],mean)

#Plot averages just to see how it looks
ggplot(averages, aes(x=X1, y=X2)) +
  geom_point(size=2, aes(color=sample), alpha=0.75) +
  theme_classic() +
  coord_fixed() +
  theme(aspect.ratio = 1) +
  scale_color_manual(values = c("#77C3BF", "#0B676F", "#7E7DB1", "#3B2951")) +
  scale_fill_manual(values = c("#77C3BF", "#0B676F", "#7E7DB1", "#3B2951"))

#Look into making a join line or something to connect the points. Will also want to rotate the plot.
#I am thinking of ultimately making 4 separate plots for each sample, colored for leaf node.

# Split averages up by sample
DWT <- averages[averages$sample== "DWT",]
DWB <- averages[averages$sample== "DWB",]
MWT <- averages[averages$sample== "MWT",]
MWB <- averages[averages$sample== "MWB",]

# Make vectors for geom_path() order
orderout <- c("1", "6", "14", "15", "16", "17", "18", "19", "20", "21", "13", "4") #Make vector for order of landmarks to join for leaf edge
orderin <- c("1", "6", "14", "5", "15", "7", "2", "9", "17", "8", "18",
             "10", "3", "12", "20", "11", "21", "13", "4") #Make vector for order of landmarks to join for veins

#Plot DWT and color by leaf node
DWT$node <- as.integer(DWT$node) #Make node numeric so gradient coloring can be used
DWT <- DWT[order(DWT$node),] #Reorder by node to set up dataframe for geom_path()
DWT$landmark <- as.character(DWT$landmark)#Reorder nodes to be in proper joinline order

#Make dataframe with points arranged for outer line
DWT.O <- DWT %>% arrange(factor(landmark, levels = orderout))
DWT.O <- DWT.O[order(DWT.O$node),]
DWT.O <- DWT.O[DWT.O$landmark %in% orderout, ]
DWT.O$line <- c("outer")

#Make dataframe with points arranged for vein lines
DWT.I <- DWT %>% arrange(factor(landmark, levels = orderin))
DWT.I <- DWT.I[order(DWT.I$node),]
DWT.I <- DWT.I[DWT.I$landmark %in% orderin, ]
DWT.I$line <- c("inner")

#Merge two dataframes
DWT.A <- rbind(DWT.I, DWT.O)

#Plot DWB and color by leaf node
DWB$node <- as.integer(DWB$node) #Make node numeric so gradient coloring can be used
DWB <- DWB[order(DWB$node),] #Reorder by node to set up dataframe for geom_path()
DWB$landmark <- as.character(DWB$landmark)#Reorder nodes to be in proper joinline order

#Make dataframe with points arranged for outer line
DWB.O <- DWB %>% arrange(factor(landmark, levels = orderout))
DWB.O <- DWB.O[order(DWB.O$node),]
DWB.O <- DWB.O[DWB.O$landmark %in% orderout, ]
DWB.O$line <- c("outer")

#Make dataframe with points arranged for vein lines
DWB.I <- DWB %>% arrange(factor(landmark, levels = orderin))
DWB.I <- DWB.I[order(DWB.I$node),]
DWB.I <- DWB.I[DWB.I$landmark %in% orderin, ]
DWB.I$line <- c("inner")

#Merge two dataframes
DWB.A <- rbind(DWB.I, DWB.O)
DWB.A <- DWB.A[DWB.A$node!=14,] #Drop node 14 so leaf size plot is easier to digest

#Plot MWT and color by leaf node
MWT$node <- as.integer(MWT$node) #Make node numeric so gradient coloring can be used
MWT <- MWT[order(MWT$node),] #Reorder by node to set up dataframe for geom_path()
MWT$landmark <- as.character(MWT$landmark)#Reorder nodes to be in proper joinline order

#Make dataframe with points arranged for outer line
MWT.O <- MWT %>% arrange(factor(landmark, levels = orderout))
MWT.O <- MWT.O[order(MWT.O$node),]
MWT.O <- MWT.O[MWT.O$landmark %in% orderout, ]
MWT.O$line <- c("outer")

#Make dataframe with points arranged for vein lines
MWT.I <- MWT %>% arrange(factor(landmark, levels = orderin))
MWT.I <- MWT.I[order(MWT.I$node),]
MWT.I <- MWT.I[MWT.I$landmark %in% orderin, ]
MWT.I$line <- c("inner")

#Merge two dataframes
MWT.A <- rbind(MWT.I, MWT.O)

#p3 <- ggplot(MWT.A, aes(x=X1, y=X2)) +
#  theme_classic() +
#  coord_fixed() +
#  theme(aspect.ratio = 1) +
#  scale_color_gradientn(colors = c("#B9CBDF", "#355070")) +
#  scale_fill_gradientn(colors = c("#B9CBDF", "#355070")) +
#  scale_y_continuous(limits = c(-10,10)) +
#  scale_x_continuous(limits = c(-10,10)) + 
#  geom_path(aes(group=line, color=node), alpha=0.5) 

#Plot MWB and color by leaf node
MWB$node <- as.integer(MWB$node) #Make node numeric so gradient coloring can be used
MWB <- MWB[order(MWB$node),] #Reorder by node to set up dataframe for geom_path()
MWB$landmark <- as.character(MWB$landmark)#Reorder nodes to be in proper joinline order

#Make dataframe with points arranged for outer line
MWB.O <- MWB %>% arrange(factor(landmark, levels = orderout))
MWB.O <- MWB.O[order(MWB.O$node),]
MWB.O <- MWB.O[MWB.O$landmark %in% orderout, ]
MWB.O$line <- c("outer")

#Make dataframe with points arranged for vein lines
MWB.I <- MWB %>% arrange(factor(landmark, levels = orderin))
MWB.I <- MWB.I[order(MWB.I$node),]
MWB.I <- MWB.I[MWB.I$landmark %in% orderin, ]
MWB.I$line <- c("inner")

#Merge two dataframes
MWB.A <- rbind(MWB.I, MWB.O)
MWB.A <- MWB.A[MWB.A$node!=14,] #Drop node 14 so leaf size plot is easier to digest

#Now I need to fix the axes so they look less dumb
#We'll play around with p3 to do so
X1 <- c(-6,-5)
X2 <- c(-9,-9)
sizebar <- data.frame(X1,X2) #THESE COORDINATES WILL NEED TO BE CHANGED IF THE DATA IS TRANSFORMED IN ANY WAY WHATSOEVER

#Set colors
light <- c("#EBEAEA")
dark <- c("#486C99")

p1 <- ggplot(DWT.A, aes(x=X1, y=X2)) +
  theme_classic() +
  coord_fixed() +
  theme(axis.line=element_blank(),axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        plot.background=element_blank(),
        #plot.margin=unit(c(-1,-2,-1,-2), "pt"),
        legend.position="none") +
  scale_color_gradientn(colors = c(light, dark), breaks = c(1,13), labels= c(1,13)) +
  scale_fill_gradientn(colors = c(light, dark), breaks = c(1,13), labels= c(1,13)) +
  scale_y_continuous(limits = c(-10,7.5)) +
  scale_x_continuous(limits = c(-7,4)) +  
  geom_path(aes(group=line, color=node), alpha=0.75, size = 0.75) +
  geom_path(data=sizebar, size=2) +
  annotate("text", label = "1 cm", x = -3.25, y = -8.92, size = 3.5) +
  annotate("text", label = "Dakapo WT", x = 0, y = 7, size = 3.5) 

p2 <- ggplot(DWB.A, aes(x=X1, y=X2)) +
  theme_classic() +
  coord_fixed() +
  theme(axis.line=element_blank(),axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        plot.background=element_blank(),
        #plot.margin=unit(c(-1,-2,-1,-2), "pt"),
        legend.position="none") +
  scale_color_gradientn(colors = c(light, dark), breaks = c(1,13), labels= c(1,13)) +
  scale_fill_gradientn(colors = c(light, dark), breaks = c(1,13), labels= c(1,13)) +
  scale_y_continuous(limits = c(-10,7.5)) +
  scale_x_continuous(limits = c(-7,4)) + 
  geom_path(aes(group=line, color=node), alpha=0.75, size = 0.75) +
  annotate("text", label = "Dakapo WB", x = 0, y = 7, size = 3.5)

p3 <- ggplot(MWT.A, aes(x=X1, y=X2)) +
  coord_fixed() +
  theme(axis.line=element_blank(),axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        plot.background=element_blank(),
        #plot.margin=unit(c(-1,-2,-1,-2), "pt"),
        legend.position="none") +
  scale_color_gradientn(colors = c(light, dark), breaks = c(1,13), labels= c(1,13)) +
  scale_fill_gradientn(colors = c(light, dark), breaks = c(1,13), labels= c(1,13)) +
  scale_y_continuous(limits = c(-10,7.5)) +
  scale_x_continuous(limits = c(-7,4)) + 
  geom_path(aes(group=line, color=node), alpha=0.75, size = 0.75) + 
  annotate("text", label = "Merlot WT", x = 0, y = 7, size = 3.5) 

p4 <- ggplot(MWB.A, aes(x=X1, y=X2)) +
  theme_classic() +
  coord_fixed() +
  theme(axis.line=element_blank(),axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        plot.background=element_blank(),
        #plot.margin=unit(c(-1,-2,-1,-2), "pt"),
        legend.position = c(0.94, 0.55),
        legend.key.width = unit(0.2, "cm"),
        legend.key.height = unit(0.5, "cm"),
        legend.title=element_text(size=9),
        legend.text=element_text(size=8)) +
  scale_color_gradientn(colors = c(light, dark), breaks = c(1,13), labels= c(1,13)) +
  scale_fill_gradientn(colors = c(light, dark), breaks = c(1,13), labels= c(1,13)) +
  scale_y_continuous(limits = c(-10,7.5)) +
  scale_x_continuous(limits = c(-7,4)) + 
  geom_path(aes(group=line, color=node), alpha=0.75, size = 0.75) +
  annotate("text", label = "Merlot WB", x = 0, y = 7, size = 3.5) 

# Combine all into one plot
#grid.arrange(p1, p2, p3, p4, ncol=2) 

library("cowplot")
#plot_grid(p1, NULL, p2, p3, NULL, p4,  ncol = 3, nrow = 2, align = "hv", rel_widths = c(1, -0.25, 1))

# Plot with leaf area violin plot
# grid1 <- plot_grid(p1, p2, p3, p4,  ncol = 2, nrow = 2, align = "hv", labels="auto")
# grid2 <- plot_grid(p5, ncol = 1, nrow = 1, labels = c('e'))
# plot_grid(grid1, grid2, ncol=1, nrow=2, rel_heights = c(2,1), align = "hv")

grid1 <- plot_grid(p1, p2, p3, p4,  ncol = 4, nrow = 1,align = "hv", labels="auto")
grid2 <- plot_grid(p5, p6, ncol = 2, nrow = 1, labels = c('e', 'f'))
plot_grid(grid1, grid2, ncol=1, nrow=2, align = "hv")

########################## 8 TEST MEAN SHAPE DIFFERENCES BETWEEN SAMPLES ##########################
#Set working directory
setwd("C:/Users/rittere5/OneDrive - Michigan State University/Witchs_Broom_Project/landmarking/coords_files") #Work working directory
#setwd("C:/Users/elean/OneDrive - Michigan State University/Witchs_Broom_Project/landmarking/coords_files")

#Rerun procGPA for each sample
## DWT
dwt.files<-list.files()[grepl('DWT',list.files())]
dwt.tmp1<-read.csv(dwt.files[1],sep="",header=FALSE)
dwt.coords<-array(dim=c(dim(dwt.tmp1),length(dwt.files)))
for(i in seq_along(dwt.files)){
  dwt.coords[,,i]<-as.matrix(read.csv(dwt.files[i],sep="",header=FALSE))
}
dwt.gpa <- procGPA(dwt.coords, reflect=TRUE, scale = TRUE)

## DWB
dwb.files<-list.files()[grepl('DWB',list.files())]
dwb.tmp1<-read.csv(dwb.files[1],sep="",header=FALSE)
dwb.coords<-array(dim=c(dim(dwb.tmp1),length(dwb.files)))
for(i in seq_along(dwb.files)){
  dwb.coords[,,i]<-as.matrix(read.csv(dwb.files[i],sep="",header=FALSE))
}
dwb.gpa <- procGPA(dwb.coords, reflect=TRUE, scale = TRUE)

## MWT
mwt.files<-list.files()[grepl('MWT',list.files())]
mwt.tmp1<-read.csv(mwt.files[1],sep="",header=FALSE)
mwt.coords<-array(dim=c(dim(mwt.tmp1),length(mwt.files)))
for(i in seq_along(mwt.files)){
  mwt.coords[,,i]<-as.matrix(read.csv(mwt.files[i],sep="",header=FALSE))
}
mwt.gpa <- procGPA(mwt.coords, reflect=TRUE, scale = TRUE)

## DWB
mwb.files<-list.files()[grepl('MWB',list.files())]
mwb.tmp1<-read.csv(mwb.files[1],sep="",header=FALSE)
mwb.coords<-array(dim=c(dim(mwb.tmp1),length(mwb.files)))
for(i in seq_along(mwb.files)){
  mwb.coords[,,i]<-as.matrix(read.csv(mwb.files[i],sep="",header=FALSE))
}
mwb.gpa <- procGPA(mwb.coords, reflect=TRUE, scale = TRUE)

#Test mean shape difference between samples
tms.dakapo <- testmeanshapes(dwt.coords, dwb.coords, scale = TRUE)
tms.merlot <- testmeanshapes(mwt.coords, mwb.coords, scale = TRUE)

# Plot mean shapes together
#Run procGPA once to get points scaled and rotated the same
#Load data in
files<-list.files()[grepl('coords\\d+\\.txt',list.files())]
tmp1<-read.csv(files[1],sep="",header=FALSE)
coords<-array(dim=c(dim(tmp1),length(files)))
for(i in seq_along(files)){
  coords[,,i]<-as.matrix(read.csv(files[i],sep="",header=FALSE))
}

#Run procGPA and make eigenleaves with shapepca
gpa.scaled <- procGPA(coords, reflect=TRUE, scale = TRUE)
scaled <- gpa.scaled$rotated

#Extract scaled and rotated points by sample
which(grepl('DWT', as.character(files)))
dwt.scaled <- scaled[1:21,1:2,70:136] 
dwt.gpa.scaled <- procGPA(dwt.scaled, reflect=TRUE, scale = TRUE)

which(grepl('DWB', as.character(files)))
dwb.scaled <- scaled[1:21,1:2,1:69] 
dwb.gpa.scaled <- procGPA(dwb.scaled, reflect=TRUE, scale = TRUE)

which(grepl('MWT', as.character(files)))
mwt.scaled <- scaled[1:21,1:2,207:275] 
mwt.gpa.scaled <- procGPA(mwt.scaled, reflect=TRUE, scale = TRUE)

which(grepl('MWB', as.character(files)))
mwb.scaled <- scaled[1:21,1:2,137:206] 
mwb.gpa.scaled <- procGPA(mwb.scaled, reflect=TRUE, scale = TRUE)

# Get mean shapes
dwt.mshape <- as.data.frame(dwt.gpa.scaled$mshape)
dwt.mshape$sample <- c("Dakapo WT")
dwb.mshape <- as.data.frame(dwb.gpa.scaled$mshape)
dwb.mshape$sample <- c("Dakapo WB")
mwt.mshape <- as.data.frame(mwt.gpa.scaled$mshape)
mwt.mshape$sample <- c("Merlot WT")
mwb.mshape <- as.data.frame(mwb.gpa.scaled$mshape)
mwb.mshape$sample <- c("Merlot WB")

#Order data properly before combining
#Make vectors for geom_path() order
orderout <- c("1", "6", "14", "15", "16", "17", "18", "19", "20", "21", "13", "4") #Make vector for order of landmarks to join for leaf edge
orderin <- c("1", "6", "14", "5", "15", "7", "2", "9", "17", "8", "18",
             "10", "3", "12", "20", "11", "21", "13", "4") #Make vector for order of landmarks to join for veins

#Plot DWT and color by leaf node
dwt.mshape$landmark <- rownames(dwt.mshape)
dwt.mshape$landmark <- as.character(dwt.mshape$landmark)#Reorder nodes to be in proper joinline order

#Make dataframe with points arranged for outer line
dwt.mshape.O <- dwt.mshape %>% arrange(factor(landmark, levels = orderout))
dwt.mshape.O <- dwt.mshape.O[dwt.mshape.O$landmark %in% orderout, ]
dwt.mshape.O$line <- c("outer")

#Make dataframe with points arranged for vein lines
dwt.mshape.I <- dwt.mshape %>% arrange(factor(landmark, levels = orderin))
dwt.mshape.I <- dwt.mshape.I[dwt.mshape.I$landmark %in% orderin, ]
dwt.mshape.I$line <- c("inner")

#Merge two dataframes
dwt.mshape.A <- rbind(dwt.mshape.I, dwt.mshape.O)

#Plot dwb and color by leaf node
dwb.mshape$landmark <- rownames(dwb.mshape)
dwb.mshape$landmark <- as.character(dwb.mshape$landmark)#Reorder nodes to be in proper joinline order

#Make dataframe with points arranged for outer line
dwb.mshape.O <- dwb.mshape %>% arrange(factor(landmark, levels = orderout))
dwb.mshape.O <- dwb.mshape.O[dwb.mshape.O$landmark %in% orderout, ]
dwb.mshape.O$line <- c("outer")

#Make dataframe with points arranged for vein lines
dwb.mshape.I <- dwb.mshape %>% arrange(factor(landmark, levels = orderin))
dwb.mshape.I <- dwb.mshape.I[dwb.mshape.I$landmark %in% orderin, ]
dwb.mshape.I$line <- c("inner")

#Merge two dataframes
dwb.mshape.A <- rbind(dwb.mshape.I, dwb.mshape.O)

#Plot mwt and color by leaf node
mwt.mshape$landmark <- rownames(mwt.mshape)
mwt.mshape$landmark <- as.character(mwt.mshape$landmark)#Reorder nodes to be in proper joinline order

#Make dataframe with points arranged for outer line
mwt.mshape.O <- mwt.mshape %>% arrange(factor(landmark, levels = orderout))
mwt.mshape.O <- mwt.mshape.O[mwt.mshape.O$landmark %in% orderout, ]
mwt.mshape.O$line <- c("outer")

#Make dataframe with points arranged for vein lines
mwt.mshape.I <- mwt.mshape %>% arrange(factor(landmark, levels = orderin))
mwt.mshape.I <- mwt.mshape.I[mwt.mshape.I$landmark %in% orderin, ]
mwt.mshape.I$line <- c("inner")

#Merge two dataframes
mwt.mshape.A <- rbind(mwt.mshape.I, mwt.mshape.O)

#Plot mwb and color by leaf node
mwb.mshape$landmark <- rownames(mwb.mshape)
mwb.mshape$landmark <- as.character(mwb.mshape$landmark)#Reorder nodes to be in proper joinline order

#Make dataframe with points arranged for outer line
mwb.mshape.O <- mwb.mshape %>% arrange(factor(landmark, levels = orderout))
mwb.mshape.O <- mwb.mshape.O[mwb.mshape.O$landmark %in% orderout, ]
mwb.mshape.O$line <- c("outer")

#Make dataframe with points arranged for vein lines
mwb.mshape.I <- mwb.mshape %>% arrange(factor(landmark, levels = orderin))
mwb.mshape.I <- mwb.mshape.I[mwb.mshape.I$landmark %in% orderin, ]
mwb.mshape.I$line <- c("inner")

#Merge two dataframes
mwb.mshape.A <- rbind(mwb.mshape.I, mwb.mshape.O)

# Plot mean shapes
# Merge dataframes by variety
dakapo.mshape <- rbind(dwt.mshape.A, dwb.mshape.A)
merlot.mshape <- rbind(mwt.mshape.A, mwb.mshape.A)

#Set colors
light1 <- c("#F6E7DF")
dark1 <- c("#F46666")
light2 <- c("#C4D1E9")
dark2 <- c("#40376E")

# Plot Dakapo mean shapes
p.dakapo.mshape <- ggplot() +
  geom_path(dwt.mshape.A, mapping = aes(x=V1, y=V2, group=line, color='Dakapo WT'), alpha=0.75, size = 1.5) +
  geom_path(dwb.mshape.A, mapping = aes(x=V1, y=V2, group=line, color='Dakapo WB'), alpha=0.75, size = 1.5) +
  theme_classic() +
  coord_fixed() +
  scale_color_manual(values = c(dark2, dark1)) +
  theme(axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        plot.background=element_blank(),
        legend.title = element_blank(),
        legend.text = element_text(size=12),
        #plot.margin=unit(c(-1,-2,-1,-2), "pt"),
        legend.position = "bottom") +
  guides(col = guide_legend(override.aes = list(alpha = 1), reverse = T))

p.merlot.mshape <- ggplot() +
  geom_path(mwt.mshape.A, mapping = aes(x=V1, y=V2, group=line, color='Merlot WT'), alpha=0.75, size = 1.5) +
  geom_path(mwb.mshape.A, mapping = aes(x=V1, y=V2, group=line, color='Merlot WB'), alpha=0.75, size = 1.5) +
  theme_classic() +
  coord_fixed() +
  scale_color_manual(values = c(dark2, dark1)) +
  theme(axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        plot.background=element_blank(),
        legend.title = element_blank(),
        legend.text = element_text(size=12),
        #plot.margin=unit(c(-1,-2,-1,-2), "pt"),
        legend.position = "bottom") +
  guides(col = guide_legend(override.aes = list(alpha = 1), reverse = T))

mshape.grid <- plot_grid(p.dakapo.mshape, p.merlot.mshape, ncol=2, nrow=1, align = "h", labels = "auto")

########################## 9 PLOTTING PCA FOR SHAPE DATA ##########################
#Set working directory
setwd("C:/Users/rittere5/OneDrive - Michigan State University/Witchs_Broom_Project/landmarking/coords_files") #Work working directory
#setwd("C:/Users/elean/OneDrive - Michigan State University/Witchs_Broom_Project/landmarking/coords_files")

#Set colors
light1 <- c("#F6E7DF")
dark1 <- c("#F46666")
light2 <- c("#C4D1E9")
dark2 <- c("#40376E")

#Load data in by variety
m.files<-list.files()[grepl('M',list.files())]
m.tmp1<-read.csv(m.files[1],sep="",header=FALSE)
m.coords<-array(dim=c(dim(m.tmp1),length(m.files)))
for(i in seq_along(m.files)){
  m.coords[,,i]<-as.matrix(read.csv(m.files[i],sep="",header=FALSE))
}

d.files<-list.files()[grepl('D',list.files())]
d.tmp1<-read.csv(d.files[1],sep="",header=FALSE)
d.coords<-array(dim=c(dim(d.tmp1),length(d.files)))
for(i in seq_along(d.files)){
  d.coords[,,i]<-as.matrix(read.csv(d.files[i],sep="",header=FALSE))
}

## Merlot alone
#Run procGPA and restructure data
m.gpa <- procGPA(m.coords, reflect=TRUE, scale = TRUE)
shapepca(m.gpa, pcno=c(1,2,3,4), joinline=c(1,6, 14, 15, 16, 17, 18, 19, 20, 21, 13, 4), mag=0.5, type = "r") #c equals 3 when type="r"
m.pc <- as.data.frame(m.gpa$scores)
m.sample <- gsub( "-.*", "", m.files)
m.pc$sample <- m.sample
mshoot <- substring(m.files,5,5)
mtmpnode <- gsub( ".*coords", "", m.files)
mnode <- as.numeric(gsub(".txt", "", mtmpnode))
rm(mtmpnode)
m.pc$shoot <- mshoot
m.pc$node <- mnode

#Separate datasets for plotting
mwtpc <-m.pc[m.pc$sample=="MWT",]
mwbpc <-m.pc[m.pc$sample=="MWB",]

#Plot both Merlot samples, coloring each separately for node
mpcA <- ggplot(mwtpc, aes(x=PC1, y=PC2)) +
  geom_point(aes(color=node), size=1) +
  scale_color_gradient(name= "Merlot WT\nnode", low = light1, high = dark1, breaks = c(1,13), labels= c(1,13), guide = guide_colourbar(order = 1)) +
  scale_fill_gradient(low = light1, high = dark1, breaks = c(1,13), labels= c(1,13)) +
  stat_ellipse(data=mwtpc,aes(x=PC1, y=PC2),type = "norm", color=dark1, size=1) +
  new_scale_color() +
  new_scale_fill() +
  geom_point(data=mwbpc, aes(x=PC1, y=PC2, color=node), size=1, show.legend = F) +
  scale_color_gradient(name= "Merlot WB\nnode", low = light2, high = dark2, breaks = c(1,14), labels= c(1,14) , guide = guide_colourbar(order = 2)) +
  scale_fill_gradient(low = light2, high = dark2,  breaks = c(1,14), labels= c(1,14)) +
  stat_ellipse(data=mwbpc,aes(x=PC1, y=PC2),type = "norm", color=dark2, size=1) +
  theme_classic() +
  labs(x = "PC1: 23.0%", y = "PC2: 18.5%") +
  theme(axis.title.x=element_text(colour="black", size=12),
        axis.title.y=element_text(colour="black", size=12),
        axis.text.x=element_text(colour="black", size=10),
        axis.text.y = element_text(colour="black", size=10),
        legend.position = "bottom",
        legend.justification = "center",
        legend.title = element_text(colour="black", size=10),
        legend.key.size = unit(0.25, "cm"),
        legend.text = element_text(colour="black", size=10))

mpcB <- ggplot(mwtpc, aes(x=PC3, y=PC4)) +
  geom_point(aes(color=node), size=1, show.legend = F) +
  scale_color_gradient(name= "Merlot WT\nnode", low = light1, high = dark1, breaks = c(1,13), labels= c(1,13), guide = guide_colourbar(order = 1)) +
  scale_fill_gradient(low = light1, high = dark1, breaks = c(1,13), labels= c(1,13)) +
  stat_ellipse(data=mwtpc,aes(x=PC3, y=PC4),type = "norm", color=dark1, size=1) +
  new_scale_color() +
  new_scale_fill() +
  geom_point(data=mwbpc, aes(x=PC3, y=PC4, color=node), size=1) +
  scale_color_gradient(name= "Merlot WB\nnode", low = light2, high = dark2, breaks = c(1,14), labels= c(1,14) , guide = guide_colourbar(order = 2)) +
  scale_fill_gradient(low = light2, high = dark2,  breaks = c(1,14), labels= c(1,14)) +
  stat_ellipse(data=mwbpc,aes(x=PC3, y=PC4),type = "norm", color=dark2, size=1) +
  theme_classic() +
  labs(x = "PC3: 18.2%", y = "PC4: 8.3%") +
  theme(axis.title.x=element_text(colour="black", size=12),
        axis.title.y=element_text(colour="black", size=12),
        axis.text.x=element_text(colour="black", size=10),
        axis.text.y = element_text(colour="black", size=10),
        legend.position = "bottom",
        legend.justification = "center",
        legend.title = element_text(colour="black", size=10),
        legend.key.size = unit(0.25, "cm"),
        legend.text = element_text(colour="black", size=10))

plot_grid(mpcA, mpcB, ncol=2, nrow=1, rel_widths = c(1,1.4), align = "h", labels = "auto")

# #A different way to plot data
# light <- c("#EBEAEA")
# dark <- c("#486C99")
# ggplot(m.pc, aes(x=PC1, y=PC2)) +
#   geom_point(size=2, aes(color=node)) +
#   theme_classic() +
#   coord_fixed() +
#   scale_color_gradientn(colors = c(light, dark), breaks = c(1,14), labels= c(1,14)) +
#   scale_fill_gradientn(colors = c(light, dark), breaks = c(1,14), labels= c(1,14))

## Dakapo alone
#Run procGPA and restructure data
d.gpa <- procGPA(d.coords, reflect=TRUE, scale = TRUE)
shapepca(d.gpa, pcno=c(1,2,3,4), joinline=c(1,6, 14, 15, 16, 17, 18, 19, 20, 21, 13, 4), mag=0.5, type = "r") #c equals 3 when type="r"
d.pc <- as.data.frame(d.gpa$scores)
d.sample <- gsub( "-.*", "", d.files)
d.pc$sample <- d.sample
dshoot <- substring(d.files,5,5)
dtmpnode <- gsub( ".*coords", "", d.files)
dnode <- as.numeric(gsub(".txt", "", dtmpnode))
rm(dtmpnode)
d.pc$shoot <- dshoot
d.pc$node <- dnode

#Separate datasets for plotting
dwtpc <-d.pc[d.pc$sample=="DWT",]
dwbpc <-d.pc[d.pc$sample=="DWB",]

#Plot both Dakapo samples, coloring each separately for node
# dpcA <- ggplot(dwtpc, aes(x=PC1, y=PC2)) +
#   geom_point(aes(color=node), size=1) +
#   scale_color_gradient(name= "Dakapo WT\nnode", low = light1, high = dark1, breaks = c(1,13), labels= c(1,13), guide = guide_colourbar(order = 1)) +
#   scale_fill_gradient(low = light1, high = dark1, breaks = c(1,13), labels= c(1,13)) +
#   stat_ellipse(data=dwtpc,aes(x=PC1, y=PC2),type = "norm", color=dark1, size=1) +
#   new_scale_color() +
#   new_scale_fill() +
#   geom_point(data=dwbpc, aes(x=PC1, y=PC2, color=node), size=1) +
#   scale_color_gradient(name= "Dakapo WB\nnode", low = light2, high = dark2, breaks = c(1,14), labels= c(1,14) , guide = guide_colourbar(order = 2)) +
#   scale_fill_gradient(low = light2, high = dark2,  breaks = c(1,14), labels= c(1,14)) +
#   stat_ellipse(data=dwbpc,aes(x=PC1, y=PC2),type = "norm", color=dark2, size=1) +
#   theme_classic() +
#   labs(x = "PC1: 20.1%", y = "PC2: 18.3%") +
#   theme(axis.title.x=element_text(colour="black", size=10),
#         axis.title.y=element_text(colour="black", size=10),
#         axis.text.x=element_text(colour="black", size=8),
#         axis.text.y = element_text(colour="black", size=8),
#         legend.text = element_text(colour="black", size=8),
#         legend.position = "none")

dpcA <- ggplot(dwtpc, aes(x=PC1, y=PC2)) +
  geom_point(aes(color=node), size=1) +
  scale_color_gradient(name= "Dakapo WT\nnode", low = light1, high = dark1, breaks = c(1,13), labels= c(1,13), guide = guide_colourbar(order = 1)) +
  scale_fill_gradient(low = light1, high = dark1, breaks = c(1,13), labels= c(1,13)) +
  stat_ellipse(data=dwtpc,aes(x=PC1, y=PC2),type = "norm", color=dark1, size=1) +
  new_scale_color() +
  new_scale_fill() +
  geom_point(data=dwbpc, aes(x=PC1, y=PC2, color=node), size=1, show.legend = F) +
  scale_color_gradient(name= "Dakapo WB\nnode", low = light2, high = dark2, breaks = c(1,14), labels= c(1,14) , guide = guide_colourbar(order = 2)) +
  scale_fill_gradient(low = light2, high = dark2,  breaks = c(1,14), labels= c(1,14)) +
  stat_ellipse(data=dwbpc,aes(x=PC1, y=PC2),type = "norm", color=dark2, size=1) +
  theme_classic() +
  labs(x = "PC1: 20.1%", y = "PC2: 18.3%") +
  theme(axis.title.x=element_text(colour="black", size=12),
        axis.title.y=element_text(colour="black", size=12),
        axis.text.x=element_text(colour="black", size=10),
        axis.text.y = element_text(colour="black", size=10),
        legend.position = "bottom",
        legend.justification = "center",
        legend.title = element_text(colour="black", size=10),
        legend.key.size = unit(0.25, "cm"),
        legend.text = element_text(colour="black", size=10))

# dpcB <- ggplot(dwtpc, aes(x=PC3, y=PC4)) +
#   geom_point(aes(color=node), size=1) +
#   scale_color_gradient(name= "Dakapo WT\nnode", low = light1, high = dark1, breaks = c(1,13), labels= c(1,13), guide = guide_colourbar(order = 1)) +
#   scale_fill_gradient(low = light1, high = dark1, breaks = c(1,13), labels= c(1,13)) +
#   stat_ellipse(data=dwtpc,aes(x=PC3, y=PC4),type = "norm", color=dark1, size=1) +
#   new_scale_color() +
#   new_scale_fill() +
#   geom_point(data=dwbpc, aes(x=PC3, y=PC4, color=node), size=1) +
#   scale_color_gradient(name= "Dakapo WB\nnode", low = light2, high = dark2, breaks = c(1,14), labels= c(1,14) , guide = guide_colourbar(order = 2)) +
#   scale_fill_gradient(low = light2, high = dark2,  breaks = c(1,14), labels= c(1,14)) +
#   stat_ellipse(data=dwbpc,aes(x=PC3, y=PC4),type = "norm", color=dark2, size=1) +
#   theme_classic() +
#   labs(x = "PC3: 14.6%", y = "PC4: 10.2%") +
#   theme(axis.title.x=element_text(colour="black", size=10),
#         axis.title.y=element_text(colour="black", size=10),
#         axis.text.x=element_text(colour="black", size=8),
#         axis.text.y = element_text(colour="black", size=8),
#         legend.text = element_text(colour="black", size=8),
#         legend.title = element_text(colour="black", size=8),
#         legend.key.size = unit(0.25, "cm"))

dpcB <- ggplot(dwtpc, aes(x=PC3, y=PC4)) +
  geom_point(aes(color=node), size=1, show.legend=F) +
  scale_color_gradient(name= "Dakapo WT\nnode", low = light1, high = dark1, breaks = c(1,13), labels= c(1,13), guide = guide_colourbar(order = 1)) +
  scale_fill_gradient(low = light1, high = dark1, breaks = c(1,13), labels= c(1,13)) +
  stat_ellipse(data=dwtpc,aes(x=PC3, y=PC4),type = "norm", color=dark1, size=1) +
  new_scale_color() +
  new_scale_fill() +
  geom_point(data=dwbpc, aes(x=PC3, y=PC4, color=node), size=1) +
  scale_color_gradient(name= "Dakapo WB\nnode", low = light2, high = dark2, breaks = c(1,14), labels= c(1,14) , guide = guide_colourbar(order = 2)) +
  scale_fill_gradient(low = light2, high = dark2,  breaks = c(1,14), labels= c(1,14)) +
  stat_ellipse(data=dwbpc,aes(x=PC3, y=PC4),type = "norm", color=dark2, size=1) +
  theme_classic() +
  labs(x = "PC3: 14.6%", y = "PC4: 10.2%") +
  theme(axis.title.x=element_text(colour="black", size=12),
        axis.title.y=element_text(colour="black", size=12),
        axis.text.x=element_text(colour="black", size=10),
        axis.text.y = element_text(colour="black", size=10),
        legend.position = "bottom",
        legend.justification = "center",
        legend.title = element_text(colour="black", size=10),
        legend.key.size = unit(0.25, "cm"),
        legend.text = element_text(colour="black", size=10))

plot_grid(dpcA, dpcB, ncol=2, nrow=1, rel_widths = c(1,1.4), align = "h", labels = "auto")

pc.grid <- plot_grid(dpcA, mpcA, dpcB, mpcB, ncol=2, nrow=2, 
                     rel_heights = c(1,1.2), align="tblr", labels = c('c', 'd', 'e', 'f')) #Plotting with 2 rows

pc.grid <- plot_grid(dpcA, dpcB, mpcA, mpcB, ncol=4, nrow=1,
                     align="tblr", labels = c('c','', 'd', ''), rel_widths = c(1,1, 1,1)) #Plotting with everything on 1 row
          
plot_grid(mshape.grid, pc.grid, ncol=1, nrow=2, align = "tblr", rel_heights = c(1,1.25)) #Plotting with 2 row pc.grid

plot_grid(mshape.grid, pc.grid, ncol=1, nrow=2, align = "tblr", rel_heights = c(1,0.75)) #Plotting with 1 row pc.grid

# dpc1 <- ggplot(d.pc, aes(x=PC1, y=PC2)) +
#   geom_point(size=2, aes(color=sample)) +
#   theme_classic() +
#   coord_fixed() + 
#   stat_ellipse(aes(x=PC1, y=PC2,color=sample),type = "norm")
# 
#
# light <- c("#EBEAEA")
# dark <- c("#486C99")
# 
# dpc2 <- ggplot(d.pc, aes(x=PC1, y=PC2)) +
#   geom_point(size=2, aes(color=node)) +
#   theme_classic() +
#   coord_fixed() +
#   scale_color_gradientn(colors = c(light, dark), breaks = c(1,14), labels= c(1,14)) +
#   scale_fill_gradientn(colors = c(light, dark), breaks = c(1,14), labels= c(1,14))
# 
# plot_grid(dpc1, dpc2, ncol=2, nrow=1, align = "h", labels = "auto")

### Combine plots from running varieties seperately and plotting PCA values
#plot_grid(mpcA, mpcB, dpcA, dpcB, ncol=2, nrow=2, rel_widths = c(1,1), axis= "tblr",align = "hv", labels = "auto")

# ## All together
# # Set colors
# dwt <- c("#0B676F")
# dwb <- c("#77C3BF")
# mwt <- c("#50386e")
# mwb <- c("#7E7DB1")
# 
# files<-list.files()[grepl('coords\\d+\\.txt',list.files())]
# tmp1<-read.csv(files[1],sep="",header=FALSE)
# coords<-array(dim=c(dim(tmp1),length(files)))
# for(i in seq_along(files)){
#   coords[,,i]<-as.matrix(read.csv(files[i],sep="",header=FALSE))
# }
# 
# #Run procGPA and make eigenleaves with shapepca
# scaled <- procGPA(coords, reflect=TRUE, scale = TRUE)
# shapepca(scaled, pcno=c(1,2,3,4), joinline=c(1,6, 14, 15, 16, 17, 18, 19, 20, 21, 13, 4), mag=0.5, type = "r") #c equals 3 when type="r"
# 
# scaled.pc <- as.data.frame(scaled$scores)
# sample <- gsub( "-.*", "", files)
# scaled.pc$sample <- sample
# scaled.pc$sample <- factor(scaled.pc$sample, levels=c('DWT', 'DWB', 'MWT', 'MWB'))
# 
# p7 <- ggplot(scaled.pc, aes(x=PC1, y=PC2)) +
#   geom_point(size=1, aes(color=sample), alpha = 0.75) +
#   theme_classic() +
#   stat_ellipse(aes(x=PC1, y=PC2,color=sample),type = "norm", size = 1, alpha = 0.75) + 
#   scale_color_manual(values = c(dwt, dwb, mwt, mwb), labels=c('Dakapo WT', 'Dakapo WB', 'Merlot WT', 'Merlot WB'), name = "") +
#   theme(axis.title.x=element_text(colour="black", size=12),
#         axis.title.y=element_text(colour="black", size=12),
#         axis.text.x=element_text(colour="black", size=10),
#         axis.text.y = element_text(colour="black", size=10),
#         legend.text = element_text(colour="black", size = 12),
#         legend.position = "none") 
# 
# p8 <- ggplot(scaled.pc, aes(x=PC3, y=PC4)) +
#   geom_point(size=1, aes(color=sample) , alpha = 0.75) +
#   theme_classic() +
#   stat_ellipse(aes(x=PC3, y=PC4,color=sample),type = "norm", size = 1, alpha = 0.75) +
#   scale_color_manual(values = c(dwt, dwb, mwt, mwb), labels=c('Dakapo WT', 'Dakapo WB', 'Merlot WT', 'Merlot WB'), name = "") +
#   theme(axis.title.x=element_text(colour="black", size=12),
#         axis.title.y=element_text(colour="black", size=12),
#         axis.text.x=element_text(colour="black", size=10),
#         axis.text.y = element_text(colour="black", size=10),
#         legend.text = element_text(colour="black", size = 12)) +
#   guides(color = guide_legend(override.aes = list(size = 3)))
# 
# plot_grid(p7, p8, ncol=2, nrow=1, rel_widths = c(1,1.5), align = "h", labels = "auto")
########################## 10 CODE IN PROGRESS ##########################
# ARE THE WB LEAVES STUCK AS JUVENILES?
## RUN 1, 4A, AND 4B BEFORE RUNNING THE CODE BELOW:
df$node <- as.numeric(df$node)

ggplot(df, aes(x=factor(sample, level=c('DWT', 'DWB', 'MWT', 'MWB')), y=all_area)) + 
  geom_violin(trim=FALSE) +
  theme_classic() + 
  geom_point(position = position_jitter(seed = 19,width = 0.3), aes(color=node), size = 2)+ 
  scale_color_viridis()

dwtold <- df[(df$sample=='DWT') & (df$node==13 | df$node==12 | df$node==11 | df$node==10),]
dwtyoung <- df[(df$sample=='DWT') & (df$node==1 | df$node==2 | df$node==3 | df$node==4),]

dwbold <- df[(df$sample=='DWB') & (df$node==14 | df$node==13 | df$node==12 | df$node==11),]
dwbyoung <- df[(df$sample=='DWB') & (df$node==1 | df$node==2 | df$node==3 | df$node==4),]
dwball <- df[(df$sample=='DWB'),]

## Run t-test
a = dwtold$all_area
b = dwtyoung$all_area
c = dwbold$all_area
d = dwbyoung$all_area
e = dwball$all_area

t.test(a,b)
t.test(c,d)
t.test(b,e) #no difference

mwtold <- df[(df$sample=='MWT') & (df$node==12 | df$node==11 | df$node==10 | df$node==9),]
mwtyoung <- df[(df$sample=='MWT') & (df$node==1 | df$node==2 | df$node==3 | df$node==4),]

mwbold <- df[(df$sample=='MWB') & (df$node==12 | df$node==11 | df$node==10 | df$node==9),]
mwbyoung <- df[(df$sample=='MWB') & (df$node==1 | df$node==2 | df$node==3 | df$node==4),]
mwball <- df[(df$sample=='MWB'),]

## Run t-test
a = mwtold$all_area
b = mwtyoung$all_area
c = mwbold$all_area
d = mwbyoung$all_area
e = mwball$all_area

t.test(a,b)
t.test(c,d)
t.test(b,e) #no difference

# Looking at models of leaf development
p1 <- ggplot(df[(df$sample=='DWT'),], aes(x=node, y=all_area)) + geom_point() +
  ylab("DWT Leaf Area") + geom_smooth(method="lm",formula= y ~ x + I(x^2))
p2 <- ggplot(df[(df$sample=='DWB'),], aes(x=node, y=all_area)) + geom_point() +
  ylab("DWB Leaf Area")+ geom_smooth(method="lm",formula= y ~ x + I(x^2))
p3 <- ggplot(df[(df$sample=='MWT'),], aes(x=node, y=all_area)) + geom_point() +
  ylab("MWT Leaf Area")+ geom_smooth(method="lm",formula= y ~ x + I(x^2))
p4 <- ggplot(df[(df$sample=='MWB'),], aes(x=node, y=all_area)) + geom_point() +
  ylab("MWB Leaf Area")+ geom_smooth(method="lm",formula= y ~ x + I(x^2))
plot_grid(p1, p2, p3, p4 , nrow=2, ncol=2)

test<-lm(log(all_area)~sample+node:sample+I(node^2):sample-1,data=df)
summary(test)
install.packages("ggeffects")
library(ggeffects)
preds<-ggpredict(test,terms=c("node [1:14 by=0.1]","sample"))
plot(preds)
df$nodesq<-df$node^2
test2<-lm(log(all_area)~sample+node:sample+nodesq:sample-1,data=df)
hypothesis_test(test2,terms=c("sample"))
hypothesis_test(test2,terms=c("node","sample"))
hypothesis_test(test2,terms=c("nodesq","sample"))
