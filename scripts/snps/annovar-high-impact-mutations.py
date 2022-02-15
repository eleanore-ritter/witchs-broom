# Extracting high impact mutations from annovar outputs

#### In this situation, high impact mutations include: all exonic (aside from synonymous), all splicing, and INDELs in introns and UTRs 

#### Disclaimer: all imported files are already filtered

## Let's work with the exonic SNPs first 

# Import packages
import numpy as np
import pandas as pd

# Read in exonic data
data = pd.read_csv("DakapoWB.exonic_variant_function.filtered", sep='\t', header=None)
data.head()

data[1].unique()

data[1].value_counts()

# Exclude synonymous mutations
data2 = data[data[1] != 'synonymous SNV']
data2.head()

# Extract columns with SNP type, gene impacted, and zygosity
hiexons = data2.iloc[:, [1]+[2]+[8]]
hiexons.head()

hiexons.rename(columns={1: 'SNP_type', 2: 'Gene_impacted', 8 : 'Zygosity'}, inplace=True)
hiexons.head()

## Now let's work with the nonexonic variants

# Import all variants
nonexons = pd.read_csv("DakapoWB.variant_function.filtered", sep='\t', header=None)
nonexons.head()

nonexons[0].unique()

# Extract out intronic, UTR5, and UTR3 variants
nonsplicing = nonexons[(nonexons[0] == 'intronic') | (nonexons[0] == 'UTR5') | (nonexons[0] == 'UTR3')]
nonsplicing.head()

# Extract out splicing variants
splicing = nonexons[nonexons[0] == 'splicing']
splicing.head()

# Filter based on ref or alt alleles being more than 1 base pair (so variant is an INDEL)
filter = (nonsplicing[5].str.len() > 1) | (nonsplicing[6].str.len() > 1)

nonsplicing1 = nonsplicing[filter]
nonsplicing1.head()

frames = [nonsplicing1, splicing]
data3 = pd.concat(frames)

hinonexons = data3.iloc[:, [0]+[1]+[7]]
hinonexons.head()

hinonexons.rename(columns={0: 'SNP_type', 1: 'Gene_impacted', 7 : 'Zygosity'}, inplace=True)
hinonexons.head()

# Combine exonic and nonexonic high impact variants
frames1 = [hiexons, hinonexons]
hisnps = pd.concat(frames1)

hisnps.head()

# Write out results to file
hisnps.to_csv('high-impact-snps-dakapowb.csv', index=False)
