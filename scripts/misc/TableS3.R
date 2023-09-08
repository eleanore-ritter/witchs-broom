setwd("C:/Users/rittere5/OneDrive - Michigan State University/Witchs_Broom_Project/final-snps-2023/") #Work working directory
#setwd("C:/Users/elean/OneDrive - Michigan State University/Witchs_Broom_Project/final-snps-2023/")

library(biomaRt)
library(dplyr)

############# MAKING DAKAPO WB SNP CANDIDATE LIST #############
# Load data
dict <- read.csv("DakapoWB.variant_function.dict", sep = '\t', header = FALSE)
unq <- read.csv("dwb-unq-geno-snps-coords-FINAL.txt", sep = '\t', header = FALSE)
hi <- read.csv("dwb-high-impact-coords-NO-nonsynonymous", sep ="\t", header = FALSE)
genotypes <- read.csv("dwb-snps-coords-genotypes.txt", sep = "\t", header = FALSE)
vviatha <- read.csv("../gene_list/sorted-old-grape-lifted-arabidopsis.m8", header = FALSE, sep = "\t")
vtypes <- read.csv("dwb-variant-types.csv", header = TRUE)

# Rename columns
colnames(unq) <- c("V11")
colnames(hi) <- c("V11")
colnames(genotypes) <- c("V11", "WB_genotype", "WT_genotype")

# Merge data initially
data <- merge(dict, unq, by = "V11", all.y = TRUE)
hidata <- merge(data, hi, by = "V11")
rm(dict)

# Modify gene names to match consistently
hidata$V2 <- gsub(".Genoscope12X*", "", gsub("GSVIVT", "GSVIVG", gsub("\\(.*", "", hidata$V2)))
vviatha$V1 <- gsub(".Genoscope12X*", "", gsub("GSVIVT", "GSVIVG", gsub("\\(.*", "", vviatha$V1)))
vviatha$V2 <- gsub("\\..*", "", vviatha$V2)

# Merge variants and genotypes
data2 <- merge(hidata, vtypes, by = "V11")
data3 <- merge(data2, genotypes, by = "V11")

#Add in Arabidopsis orthologs
data4 <- merge(data3, vviatha, by.x = "V2", by.y = "V1", all.x = TRUE)

#Get TAIR IDs
atha.genes <- data4$V2.y
atha.genes <- na.omit(atha.genes)
atha.genes <- paste(atha.genes, ".1", sep="")

ensembl_plants = useMart(biomart="plants_mart", host = "plants.ensembl.org")

datasets <- listDatasets(ensembl_plants)
ensembl = useDataset("athaliana_eg_gene", ensembl_plants)

results1 <- getBM(attributes=c('ensembl_gene_id','tair_symbol'),
                  filters = 'tair_locus_model',           
                  values = atha.genes, 
                  mart = ensembl,
                  uniqueRows = TRUE)
results2 <- results1[!duplicated(results1$ensembl_gene_id), ] # Remove duplicates

data5 <- merge(data4, results2, by.x = "V2.y", by.y = "ensembl_gene_id", all.x = TRUE)
data5$Length <- c("SNP/INDEL")
data5$Variety <- c("Dakapo")

data6D <- data5[ , c("Variety", "V11.x", "Variant_Type", "Length", "WB_genotype", "WT_genotype", "V2", "V2.y", "tair_symbol")]
colnames(data6D) <- c("Variety", "Position", "Variant_Type", "Length", "WB_Genotype", "WT_Genotype", "Grape_Gene_Impacted", "Arabidopsis_Ortholog", "TAIR_Symbol_for_Arabidopsis_Ortholog")

rm(list=setdiff(ls(), "data6D"))

############# MAKING MERLOT WB SNP CANDIDATE LIST #############
# Load data
dict <- read.csv("MerlotWB.variant_function.dict", sep = '\t', header = FALSE)
unq <- read.csv("mwb-unq-geno-snps-coords-FINAL.txt", sep = '\t', header = FALSE)
hi <- read.csv("mwb-high-impact-coords-NO-nonsynonymous", sep ="\t", header = FALSE)
genotypes <- read.csv("mwb-snps-coords-genotypes.txt", sep = "\t", header = FALSE)
vviatha <- read.csv("../gene_list/sorted-old-grape-lifted-arabidopsis.m8", header = FALSE, sep = "\t")
vtypes <- read.csv("mwb-variant-types.csv", header = TRUE)

# Rename columns
colnames(unq) <- c("V11")
colnames(hi) <- c("V11")
colnames(genotypes) <- c("V11", "WB_genotype", "WT_genotype")

# Merge data initially
data <- merge(dict, unq, by = "V11", all.y = TRUE)
hidata <- merge(data, hi, by = "V11")
rm(dict)

# Modify gene names to match consistently
hidata$V2 <- gsub(".Genoscope12X*", "", gsub("GSVIVT", "GSVIVG", gsub("\\(.*", "", hidata$V2)))
vviatha$V1 <- gsub(".Genoscope12X*", "", gsub("GSVIVT", "GSVIVG", gsub("\\(.*", "", vviatha$V1)))
vviatha$V2 <- gsub("\\..*", "", vviatha$V2)

# Merge variants and genotypes
data2 <- merge(hidata, vtypes, by = "V11")
data3 <- merge(data2, genotypes, by = "V11")

#Add in Arabidopsis orthologs
data4 <- merge(data3, vviatha, by.x = "V2", by.y = "V1", all.x = TRUE)

#Get TAIR IDs
atha.genes <- data4$V2.y
atha.genes <- na.omit(atha.genes)
atha.genes <- paste(atha.genes, ".1", sep="")

ensembl_plants = useMart(biomart="plants_mart", host = "plants.ensembl.org")

datasets <- listDatasets(ensembl_plants)
ensembl = useDataset("athaliana_eg_gene", ensembl_plants)

results1 <- getBM(attributes=c('ensembl_gene_id','tair_symbol'),
                  filters = 'tair_locus_model',           
                  values = atha.genes, 
                  mart = ensembl,
                  uniqueRows = TRUE)
results2 <- results1[!duplicated(results1$ensembl_gene_id), ] # Remove duplicates

data5 <- merge(data4, results2, by.x = "V2.y", by.y = "ensembl_gene_id", all.x = TRUE)
data5$Length <- c("SNP/INDEL")
data5$Variety <- c("Merlot")

data6M <- data5[ , c("Variety", "V11.x", "Variant_Type", "Length", "WB_genotype", "WT_genotype", "V2", "V2.y", "tair_symbol")]
colnames(data6M) <- c("Variety", "Position", "Variant_Type", "Length", "WB_Genotype", "WT_Genotype", "Grape_Gene_Impacted", "Arabidopsis_Ortholog", "TAIR_Symbol_for_Arabidopsis_Ortholog")

# Clean up environment

############# MAKING DAKAPO WB SV CANDIDATE LIST #############
# Load data
data <- read.csv("Dakapo-joint-merged-V3.annotated.txt", sep = '\t', header = FALSE)
data$Position <- paste(data$V1, data$V2, sep = ":")
data$Variety <- c("Dakapo")

starts<-regexpr("SVTYPE=",data$V8)
stops<-gregexpr(";",data$V8)
starts<-starts+attr(starts,"match.length")
stops<-sapply(seq_along(stops),function(ii) min(stops[[ii]][stops[[ii]]>starts[ii]]))-1
data$Variant_Type <- substr(data$V8,start=starts,stop=stops)
data$Variant_Type <- sub("^", "SV:", data$Variant_Type )

temp <- substr(data$V10,1,3)
temp2 <- substr(data$V11,1,3)
temp3 <- paste(temp, temp2, sep =";")
data$WB_Genotype <- temp3

starts<-regexpr("SVLEN=",data$V8)
stops<-gregexpr(";",data$V8)
starts<-starts+attr(starts,"match.length")
stops<-sapply(seq_along(stops),function(ii) min(stops[[ii]][stops[[ii]]>starts[ii]]))-1
data$Length <- substr(data$V8,start=starts,stop=stops)

data$Grape_Gene_Impacted <- gsub("ID=", "", gsub("\\..*", "", gsub("GSVIVT", "GSVIVG", data$V20)))

#Add in Arabidopsis orthologs
vviatha <- read.csv("../gene_list/sorted-old-grape-lifted-arabidopsis.m8", header = FALSE, sep = "\t")
vviatha$V1 <- gsub(".Genoscope12X*", "", gsub("GSVIVT", "GSVIVG", gsub("\\(.*", "", vviatha$V1)))
vviatha$V2 <- gsub("\\..*", "", vviatha$V2)
data1 <- merge(data, vviatha, by.x = "Grape_Gene_Impacted", by.y = "V1", all.x = TRUE)

#Get TAIR IDs
atha.genes <- data1$V2.y
atha.genes <- na.omit(atha.genes)
atha.genes <- paste(atha.genes, ".1", sep="")

ensembl_plants = useMart(biomart="plants_mart", host = "plants.ensembl.org")

datasets <- listDatasets(ensembl_plants)
ensembl = useDataset("athaliana_eg_gene", ensembl_plants)

results1 <- getBM(attributes=c('ensembl_gene_id','tair_symbol'),
                  filters = 'tair_locus_model',           
                  values = atha.genes, 
                  mart = ensembl,
                  uniqueRows = TRUE)
results2 <- results1[!duplicated(results1$ensembl_gene_id), ] # Remove duplicates

data2 <- merge(data1, results2, by.x = "V2.y", by.y = "ensembl_gene_id", all.x = TRUE)

# Get genotypes for WT: paste -d '\t' temp.new.1 temp.new.2 | sort -k 1 | uniq > dwt-genotypes-sniffles.txt
dwt <- read.csv("dwt-genotypes-sniffles.txt", sep = '\t', header = FALSE)
colnames(dwt) <- c("Position", "DWT_Sniffles_Genotype")
data3 <- merge(data2, dwt, by = "Position")

dwt2 <- read.csv("dwt-survivor-pbsv-dict.txt", sep = '\t', header = FALSE)
tmp_vcf<-readLines("Dakapo.var.filtered.vcf")
tmp_vcf_data<-read.table("Dakapo.var.filtered.vcf", stringsAsFactors = FALSE)
tmp_vcf<-tmp_vcf[-(grep("#CHROM",tmp_vcf)+1):-(length(tmp_vcf))]
vcf_names<-unlist(strsplit(tmp_vcf[length(tmp_vcf)],"\t"))
names(tmp_vcf_data)<-vcf_names
pbsv <- tmp_vcf_data
rm(tmp_vcf, tmp_vcf_data)
tmp_data1 <- merge(dwt2, pbsv, by.x = "V2", by.y = "ID")
data4 <- merge(data3, tmp_data1, by.x="Position", by.y = "V1")

data4$dakapowt <- substr(data4$dakapowt, 1, 3)
data4$WT_Genotype <- paste(data4$DWT_Sniffles_Genotype, data4$dakapowt, sep = ";")

data5DSV <- data4[ , c("Variety", "Position", "Variant_Type", "Length", "WB_Genotype", "WT_Genotype", "Grape_Gene_Impacted", "V2.y", "tair_symbol")]
colnames(data5DSV) <- c("Variety", "Position", "Variant_Type", "Length", "WB_Genotype", "WT_Genotype", "Grape_Gene_Impacted", "Arabidopsis_Ortholog", "TAIR_Symbol_for_Arabidopsis_Ortholog")

# Remove genotypes that match between callers

test1<-cbind(data5DSV,do.call('rbind', strsplit(as.character(data5DSV$WB_Genotype), ';', fixed=TRUE)))
colnames(test1) <- c("Variety", "Position", "Variant_Type", "Length", "WB_Genotype", "WT_Genotype", "Grape_Gene_Impacted", "Arabidopsis_Ortholog", "TAIR_Symbol_for_Arabidopsis_Ortholog", "WB.sniffles", "WB.pbsv")

test2<-cbind(test1,do.call('rbind', strsplit(as.character(test1$WT_Genotype), ';', fixed=TRUE)))
colnames(test2) <- c("Variety", "Position", "Variant_Type", "Length", "WB_Genotype", "WT_Genotype", "Grape_Gene_Impacted", "Arabidopsis_Ortholog", "TAIR_Symbol_for_Arabidopsis_Ortholog", "WB.sniffles", "WB.pbsv", "WT.sniffles", "WT.pbsv")

test3 <- test2[test2$WB.sniffles != test2$WT.sniffles,]
test4 <- test3[test3$WB.pbsv != test3$WT.pbsv,]

# Remove columns where no genotype was called

test5 <- test4[!grepl("\\./\\.", test4$WT_Genotype),] 

test6 <- test5 %>% distinct()

# Final dataframe

data6DSV <- test6[ , c("Variety", "Position", "Variant_Type", "Length", "WB_Genotype", "WT_Genotype", "Grape_Gene_Impacted", "Arabidopsis_Ortholog", "TAIR_Symbol_for_Arabidopsis_Ortholog")]

# Clean up environment

############# MAKING MERLOT WB SV CANDIDATE LIST #############
# Load data
data <- read.csv("Merlot-joint-merged-V3.annotated.txt", sep = '\t', header = FALSE)
data$Position <- paste(data$V1, data$V2, sep = ":")
data$Variety <- c("Merlot")

starts<-regexpr("SVTYPE=",data$V8)
stops<-gregexpr(";",data$V8)
starts<-starts+attr(starts,"match.length")
stops<-sapply(seq_along(stops),function(ii) min(stops[[ii]][stops[[ii]]>starts[ii]]))-1
data$Variant_Type <- substr(data$V8,start=starts,stop=stops)
data$Variant_Type <- sub("^", "SV:", data$Variant_Type )

temp <- substr(data$V10,1,3)
temp2 <- substr(data$V11,1,3)
temp3 <- paste(temp, temp2, sep =";")
data$WB_Genotype <- temp3

starts<-regexpr("SVLEN=",data$V8)
stops<-gregexpr(";",data$V8)
starts<-starts+attr(starts,"match.length")
stops<-sapply(seq_along(stops),function(ii) min(stops[[ii]][stops[[ii]]>starts[ii]]))-1
data$Length <- substr(data$V8,start=starts,stop=stops)

data$Grape_Gene_Impacted <- gsub("ID=", "", gsub("\\..*", "", gsub("GSVIVT", "GSVIVG", data$V20)))

#Add in Arabidopsis orthologs
vviatha <- read.csv("../gene_list/sorted-old-grape-lifted-arabidopsis.m8", header = FALSE, sep = "\t")
vviatha$V1 <- gsub(".Genoscope12X*", "", gsub("GSVIVT", "GSVIVG", gsub("\\(.*", "", vviatha$V1)))
vviatha$V2 <- gsub("\\..*", "", vviatha$V2)
data1 <- merge(data, vviatha, by.x = "Grape_Gene_Impacted", by.y = "V1", all.x = TRUE)

#Get TAIR IDs
atha.genes <- data1$V2.y
atha.genes <- na.omit(atha.genes)
atha.genes <- paste(atha.genes, ".1", sep="")

ensembl_plants = useMart(biomart="plants_mart", host = "plants.ensembl.org")

datasets <- listDatasets(ensembl_plants)
ensembl = useDataset("athaliana_eg_gene", ensembl_plants)

results1 <- getBM(attributes=c('ensembl_gene_id','tair_symbol'),
                  filters = 'tair_locus_model',           
                  values = atha.genes, 
                  mart = ensembl,
                  uniqueRows = TRUE)
results2 <- results1[!duplicated(results1$ensembl_gene_id), ] # Remove duplicates

data2 <- merge(data1, results2, by.x = "V2.y", by.y = "ensembl_gene_id", all.x = TRUE)

# Get genotypes for WT: paste -d '\t' temp.new.1 temp.new.2 | sort -k 1 | uniq > dwt-genotypes-sniffles.txt
mwt <- read.csv("mwt-genotypes-sniffles.txt", sep = '\t', header = FALSE)
colnames(mwt) <- c("Position", "MWT_Sniffles_Genotype")
data3 <- merge(data2, mwt, by = "Position")

mwt2 <- read.csv("mwt-survivor-pbsv-dict.txt", sep = '\t', header = FALSE)
tmp_vcf<-readLines("Merlot.var.filtered.vcf")
tmp_vcf_data<-read.table("Merlot.var.filtered.vcf", stringsAsFactors = FALSE)
tmp_vcf<-tmp_vcf[-(grep("#CHROM",tmp_vcf)+1):-(length(tmp_vcf))]
vcf_names<-unlist(strsplit(tmp_vcf[length(tmp_vcf)],"\t"))
names(tmp_vcf_data)<-vcf_names
pbsv <- tmp_vcf_data
rm(tmp_vcf, tmp_vcf_data)
tmp_data1 <- merge(mwt2, pbsv, by.x = "V2", by.y = "ID")
data4 <- merge(data3, tmp_data1, by.x="Position", by.y = "V1")

data4$merlotwt <- substr(data4$merlotwt, 1, 3)
data4$WT_Genotype <- paste(data4$MWT_Sniffles_Genotype, data4$merlotwt, sep = ";")

data5MSV <- data4[ , c("Variety", "Position", "Variant_Type", "Length", "WB_Genotype", "WT_Genotype", "Grape_Gene_Impacted", "V2.y", "tair_symbol")]
colnames(data5MSV) <- c("Variety", "Position", "Variant_Type", "Length", "WB_Genotype", "WT_Genotype", "Grape_Gene_Impacted", "Arabidopsis_Ortholog", "TAIR_Symbol_for_Arabidopsis_Ortholog")

# Remove genotypes that match between callers

test1<-cbind(data5MSV,do.call('rbind', strsplit(as.character(data5MSV$WB_Genotype), ';', fixed=TRUE)))
colnames(test1) <- c("Variety", "Position", "Variant_Type", "Length", "WB_Genotype", "WT_Genotype", "Grape_Gene_Impacted", "Arabidopsis_Ortholog", "TAIR_Symbol_for_Arabidopsis_Ortholog", "WB.sniffles", "WB.pbsv")

test2<-cbind(test1,do.call('rbind', strsplit(as.character(test1$WT_Genotype), ';', fixed=TRUE)))
colnames(test2) <- c("Variety", "Position", "Variant_Type", "Length", "WB_Genotype", "WT_Genotype", "Grape_Gene_Impacted", "Arabidopsis_Ortholog", "TAIR_Symbol_for_Arabidopsis_Ortholog", "WB.sniffles", "WB.pbsv", "WT.sniffles", "WT.pbsv")

test3 <- test2[test2$WB.sniffles != test2$WT.sniffles,]
test4 <- test3[test3$WB.pbsv != test3$WT.pbsv,]

# Remove columns where no genotype was called

test5 <- test4[!grepl("\\./\\.", test4$WT_Genotype),] 

test6 <- test5 %>% distinct()

# Final dataframe

data6MSV <- test6[ , c("Variety", "Position", "Variant_Type", "Length", "WB_Genotype", "WT_Genotype", "Grape_Gene_Impacted", "Arabidopsis_Ortholog", "TAIR_Symbol_for_Arabidopsis_Ortholog")]

# Clean up environment

############################# ADD ALL DATAFRAMES TOGETHER #############################
temp1 <- rbind(data6D, data6DSV)
temp2 <- rbind(data6M, data6MSV)
TableS3 <- rbind(temp1, temp2)
TableS3.V2 <- unique(TableS3)
write.csv(TableS3.V2, "TableS3_final.csv", row.names = FALSE)

temp3 <- data6DSV$Grape_Gene_Impacted
temp4 <- data6D$Grape_Gene_Impacted
temp5 <- c(temp3, temp4)
dakapo.genes <- as.data.frame(unique(temp5))
colnames(dakapo.genes) <- c("gene")

rm(temp3, temp4, temp5)

temp3 <- data6MSV$Grape_Gene_Impacted
temp4 <- data6M$Grape_Gene_Impacted
temp5 <- c(temp3, temp4)
merlot.genes <- as.data.frame(unique(temp5))
colnames(merlot.genes) <- c("gene")

in.common <- as.data.frame(intersect(dakapo.genes$gene, merlot.genes$gene))
