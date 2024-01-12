setwd("C:/Users/rittere5/OneDrive - Michigan State University/Witchs_Broom_Project/ont-svs/") #Work working directory
setwd("C:/Users/elean/OneDrive - Michigan State University/Witchs_Broom_Project/ont-svs/")

#V3 are genotypically distinct SVs
#V4 are novel SVs
#Variants within 1KB were excluded from the manuscript in order to only retain variants with a high likelihood to impact gene function

################### GET OVERLAP BETWEEN VVI AND ATHA ###################
dg1 <- read.csv("dakapowb_ont-merged-svs_V3.vcf.genes_list.txt", header = FALSE)
dg2 <- read.csv("dakapowb_ont-merged-svs_V4.vcf.genes_list.txt", header = FALSE) #EMPTY FILE - IT'S FINE
dg3 <- read.csv("dakapowb_ont-merged-svs_V3.vcf.1kbgenes_list.txt", header = FALSE) 
dg4 <- read.csv("dakapowb_ont-merged-svs_V4.vcf.1kbgenes_list.txt", header = FALSE)

mg1 <- read.csv("merlotwb_ont-merged-svs_V3.vcf.genes_list.txt", header = FALSE)
mg2 <- read.csv("merlotwb_ont-merged-svs_V4.vcf.genes_list.txt", header = FALSE)
mg3 <- read.csv("merlotwb_ont-merged-svs_V3.vcf.1kbgenes_list.txt", header = FALSE) 
mg4 <- read.csv("merlotwb_ont-merged-svs_V4.vcf.1kbgenes_list.txt", header = FALSE)


vviatha <- read.csv("../gene_list/sorted-old-grape-lifted-arabidopsis.m8", header = FALSE, sep = "\t")

# Get Atha overlap for merlot
## For V3 overlapping genes
lookup<-gsub('GSVIV.','',gsub('\\.Genoscope12X','',vviatha$V1))
lookup[duplicated(lookup)]
inds<-lapply(gsub('GSVIV.','',mg1[[1]]),function(ii) which(ii==lookup))
foo<-function(ind){
  if(length(ind)==0){
    rep(NA,ncol(vviatha))
  }else{
    vviatha[ind,]
  }
}
mres1<-do.call(rbind,lapply(inds,foo))
lens<-lengths(inds)
lens[lens==0]<-1
mres1$V1<-rep(mg1[[1]],lens)

## For V4 overlapping genes
lookup<-gsub('GSVIV.','',gsub('\\.Genoscope12X','',vviatha$V1))
lookup[duplicated(lookup)]
inds<-lapply(gsub('GSVIV.','',mg2[[1]]),function(ii) which(ii==lookup))
foo<-function(ind){
  if(length(ind)==0){
    rep(NA,ncol(vviatha))
  }else{
    vviatha[ind,]
  }
}
mres2<-do.call(rbind,lapply(inds,foo))
lens<-lengths(inds)
lens[lens==0]<-1
mres2$V1<-rep(mg2[[1]],lens)

## For V3 genes within 1kb 
lookup<-gsub('GSVIV.','',gsub('\\.Genoscope12X','',vviatha$V1))
lookup[duplicated(lookup)]
inds<-lapply(gsub('GSVIV.','',mg3[[1]]),function(ii) which(ii==lookup))
foo<-function(ind){
  if(length(ind)==0){
    rep(NA,ncol(vviatha))
  }else{
    vviatha[ind,]
  }
}
mres3<-do.call(rbind,lapply(inds,foo))
lens<-lengths(inds)
lens[lens==0]<-1
mres3$V1<-rep(mg3[[1]],lens)

## For V4 genes within 1kb 
lookup<-gsub('GSVIV.','',gsub('\\.Genoscope12X','',vviatha$V1))
lookup[duplicated(lookup)]
inds<-lapply(gsub('GSVIV.','',mg4[[1]]),function(ii) which(ii==lookup))
foo<-function(ind){
  if(length(ind)==0){
    rep(NA,ncol(vviatha))
  }else{
    vviatha[ind,]
  }
}
mres4<-do.call(rbind,lapply(inds,foo))
lens<-lengths(inds)
lens[lens==0]<-1
mres4$V1<-rep(mg4[[1]],lens)

# Get Atha overlap for dakapo
## For V3 overlapping genes
lookup<-gsub('GSVIV.','',gsub('\\.Genoscope12X','',vviatha$V1))
lookup[duplicated(lookup)]
inds<-lapply(gsub('GSVIV.','',dg1[[1]]),function(ii) which(ii==lookup))
foo<-function(ind){
  if(length(ind)==0){
    rep(NA,ncol(vviatha))
  }else{
    vviatha[ind,]
  }
}
dres1<-do.call(rbind,lapply(inds,foo))
lens<-lengths(inds)
lens[lens==0]<-1
dres1$V1<-rep(dg1[[1]],lens)

## NO V4 overlapping genes for Dakapo

## For V3 genes within 1kb 
lookup<-gsub('GSVIV.','',gsub('\\.Genoscope12X','',vviatha$V1))
lookup[duplicated(lookup)]
inds<-lapply(gsub('GSVIV.','',dg3[[1]]),function(ii) which(ii==lookup))
foo<-function(ind){
  if(length(ind)==0){
    rep(NA,ncol(vviatha))
  }else{
    vviatha[ind,]
  }
}
dres3<-do.call(rbind,lapply(inds,foo))
lens<-lengths(inds)
lens[lens==0]<-1
dres3$V1<-rep(dg3[[1]],lens)

## For V4 genes within 1kb 
lookup<-gsub('GSVIV.','',gsub('\\.Genoscope12X','',vviatha$V1))
lookup[duplicated(lookup)]
inds<-lapply(gsub('GSVIV.','',dg4[[1]]),function(ii) which(ii==lookup))
foo<-function(ind){
  if(length(ind)==0){
    rep(NA,ncol(vviatha))
  }else{
    vviatha[ind,]
  }
}
dres4<-do.call(rbind,lapply(inds,foo))
lens<-lengths(inds)
lens[lens==0]<-1
dres4$V1<-rep(dg4[[1]],lens)

################### CLEAN UP VVI TO ATHA GENE FILE ###################
# NOTE: Only cleaning up dres1, dres4, mres1, and mres2 for now

# Get unique genes for dres1
## Clean up col1 and col2
col1 <- dres1$V1
test1 <- sapply(col1,function(ii) gsub("\\..*","",ii))
dres1$V1 <- test1
rm(col1,test1)
col2 <- dres1$V2
test2 <- sapply(col2,function(ii) gsub("\\..*","",ii))
dres1$V2 <- test2
rm(col2,test2)
# Keep only unique rows
dres1 <- unique(dres1)

# Get unique genes for dres4
## Clean up col1 and col2
col1 <- dres4$V1
test1 <- sapply(col1,function(ii) gsub("\\..*","",ii))
dres4$V1 <- test1
rm(col1,test1)
col2 <- dres4$V2
test2 <- sapply(col2,function(ii) gsub("\\..*","",ii))
dres4$V2 <- test2
rm(col2,test2)
# Keep only unique rows
dres4 <- unique(dres4)

# Get unique genes for mres1
## Clean up col1 and col2
col1 <- mres1$V1
test1 <- sapply(col1,function(ii) gsub("\\..*","",ii))
mres1$V1 <- test1
rm(col1,test1)
col2 <- mres1$V2
test2 <- sapply(col2,function(ii) gsub("\\..*","",ii))
mres1$V2 <- test2
rm(col2,test2)
# Keep only unique rows
mres1 <- unique(mres1)

# Get unique genes for mres2
## Clean up col1 and col2
col1 <- mres2$V1
test1 <- sapply(col1,function(ii) gsub("\\..*","",ii))
mres2$V1 <- test1
rm(col1,test1)
col2 <- mres2$V2
test2 <- sapply(col2,function(ii) gsub("\\..*","",ii))
mres2$V2 <- test2
rm(col2,test2)
# Keep only unique rows
mres2 <- unique(mres2)

################### GET BIOMART ANNOTATIONS FOR DAKAPO GENE LISTS ###################
library(biomaRt)

# For dres1
## Read in genes
atha <- dres1$V2
atha <- paste(atha, ".1", sep="")

## Load Ensembl Plants into biomaRt
ensembl_plants = useMart(biomart="plants_mart", host = "plants.ensembl.org")

## Select dataset to use
datasets <- listDatasets(ensembl_plants)
ensembl = useDataset("athaliana_eg_gene", ensembl_plants)

## Figure out what filters and attributes will be used
#filters = listFilters(ensembl)
#filters[25,]
#attributes = listAttributes(ensembl)
#attributes[5,]

## Use getBM to get attributes for values
results1 <- getBM(attributes=c('ensembl_gene_id', 'description','tair_symbol'),
                  filters = 'tair_locus_model',           
                  values = atha, 
                  mart = ensembl)

## Combine with vvi genes
genes_ann <- cbind(dres1,results1[match(dres1$V2,results1$ensembl_gene_id),])
rm(dres1, datasets, ensembl, ensembl_plants, results1, atha)

## Extract and rename columns
genes_ann <- genes_ann[c(1,2,14,15)]
colnames(genes_ann)[1] <- "Vitis_vinifera"
colnames(genes_ann)[2] <- "Arabidopsis_thaliana"
dg1_ann <- genes_ann

## Save new file
#write.csv(dg1_ann, file="dakapowb_ont-merged-svs_V3_atha_annotated.csv")
rm(genes_ann)

# For dres4
## Read in genes
atha <- dres4$V2
atha <- paste(atha, ".1", sep="")

## Load Ensembl Plants into biomaRt
ensembl_plants = useMart(biomart="plants_mart", host = "plants.ensembl.org")

## Select dataset to use
datasets <- listDatasets(ensembl_plants)
ensembl = useDataset("athaliana_eg_gene", ensembl_plants)

## Figure out what filters and attributes will be used
#filters = listFilters(ensembl)
#filters[25,]
#attributes = listAttributes(ensembl)
#attributes[5,]

## Use getBM to get attributes for values
results1 <- getBM(attributes=c('ensembl_gene_id', 'description','tair_symbol'),
                  filters = 'tair_locus_model',           
                  values = atha, 
                  mart = ensembl)

## Combine with vvi genes
genes_ann <- cbind(dres4,results1[match(dres4$V2,results1$ensembl_gene_id),])
rm(dres4, datasets, ensembl, ensembl_plants, results1, atha)

## Extract and rename columns
genes_ann <- genes_ann[c(1,2,14,15)]
colnames(genes_ann)[1] <- "Vitis_vinifera"
colnames(genes_ann)[2] <- "Arabidopsis_thaliana"
dg4_ann <- genes_ann

## Save new file
#write.csv(genes_ann, file="")
rm(genes_ann)

################### GET BIOMART ANNOTATIONS FOR MERLOT ###################
library(biomaRt)

# For mres1
## Read in genes
atha <- mres1$V2
atha <- paste(atha, ".1", sep="")

## Load Ensembl Plants into biomaRt
ensembl_plants = useMart(biomart="plants_mart", host = "plants.ensembl.org")

## Select dataset to use
datasets <- listDatasets(ensembl_plants)
ensembl = useDataset("athaliana_eg_gene", ensembl_plants)

## Figure out what filters and attributes will be used
#filters = listFilters(ensembl)
#filters[25,]
#attributes = listAttributes(ensembl)
#attributes[5,]

## Use getBM to get attributes for values
results1 <- getBM(attributes=c('ensembl_gene_id', 'description','tair_symbol'),
                  filters = 'tair_locus_model',           
                  values = atha, 
                  mart = ensembl)

## Combine with vvi genes
genes_ann <- cbind(mres1,results1[match(mres1$V2,results1$ensembl_gene_id),])
rm(mres1, datasets, ensembl, ensembl_plants, results1, atha)

## Extract and rename columns
genes_ann <- genes_ann[c(1,2,14,15)]
colnames(genes_ann)[1] <- "Vitis_vinifera"
colnames(genes_ann)[2] <- "Arabidopsis_thaliana"
mg1_ann <- genes_ann

## Save new file
#write.csv(mg1_ann, file="merlotwb_ont-merged-svs_V3_atha_annotated.csv")
rm(genes_ann)

# For mres2
## Read in genes
atha <- mres2$V2
atha <- paste(atha, ".1", sep="")

## Load Ensembl Plants into biomaRt
ensembl_plants = useMart(biomart="plants_mart", host = "plants.ensembl.org")

## Select dataset to use
datasets <- listDatasets(ensembl_plants)
ensembl = useDataset("athaliana_eg_gene", ensembl_plants)

## Figure out what filters and attributes will be used
#filters = listFilters(ensembl)
#filters[25,]
#attributes = listAttributes(ensembl)
#attributes[5,]

## Use getBM to get attributes for values
results1 <- getBM(attributes=c('ensembl_gene_id', 'description','tair_symbol'),
                  filters = 'tair_locus_model',           
                  values = atha, 
                  mart = ensembl)

## Combine with vvi genes
genes_ann <- cbind(mres2,results1[match(mres2$V2,results1$ensembl_gene_id),])
rm(mres2, datasets, ensembl, ensembl_plants, results1, atha)

## Extract and rename columns
genes_ann <- genes_ann[c(1,2,14,15)]
colnames(genes_ann)[1] <- "Vitis_vinifera"
colnames(genes_ann)[2] <- "Arabidopsis_thaliana"
mg2_ann <- genes_ann

## Save new file
#write.csv(mg2_ann, file="merlotwb_ont-merged-svs_V4_atha_annotated.csv")
rm(genes_ann)

################### FIND GENES OVERLAPPING BETWEEN WB SAMPLES ###################
shared <- read.csv("wb_genes_shared_V3.txt", header = FALSE)
test <- cbind(mg1_ann,shared[match(mg1_ann$Vitis_vinifera,shared$V1),])
test2 <- test[!is.na(test$`shared[match(mg1_ann$Vitis_vinifera, shared$V1), ]`),]
shared <- test2[c(1,2,3,4)]
#write.csv(shared, file="wb_genes_shared_V3_atha_annotated.csv")

################### GET A GENE ###################
data <- read.csv("vvi_to_atha_genes.csv", nrows=100, row.names = 1)
data[data$Vitis_vinifera == "Vitvi15g01739",]
data$Vitis_vinifera%in%vector