#!/bin/sh -login


#SBATCH --time=12:59:59                          # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                                # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1                      # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1                        # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=19G                                # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name picard_samsort                # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout

# Use Samtools to sort reads
java -Xmx19G -jar /mnt/home/rittere5/programs/picard.jar SortSam \
I=Dakopa_WT_bwamem.bam \
O=Dakopa_WT_bwamem_sorted.bam \
SORT_ORDER=coordinate

# Use PicardTools to mark duplicates
java -Xmx19G -jar /mnt/home/rittere5/programs/picard.jar MarkDuplicates \
VALIDATION_STRINGENCY=LENIENT \
I=Dakopa_WT_bwamem_1_sorted.bam \
O=Dakopa_WT_marked_duplicates.bam \
M=Dakopa_WT_marked_dup_metrics.txt

# Create index file for haplotype caller
samtools index Dakopa_WT_marked_duplicates.bam

# Use Haplotype Caller to call SNPs in individual samples
module load GATK/3.8-1-0-gf15c1c3ef-Java-1.8.0_112
java -jar $EBROOTGATK/GenomeAnalysisTK.jar \
-R Vvinifera.fa \
-T HaplotypeCaller \
-I Dakopa_WT_marked_duplicates.bam \
--emitRefConfidence GVCF \
-nct 5 \
-o dakopawt_output.raw.snps.indels.g.vcf

# Combine SNPs into one file
module load GATK/3.8-1-0-gf15c1c3ef-Java-1.8.0_112
java -jar $EBROOTGATK/GenomeAnalysisTK.jar \
-T CombineGVCFs \
-R Vvinifera.fa \
--variant dakopawb_output.raw.snps.indels.g.vcf \
--variant dakopawt_output.raw.snps.indels.g.vcf \
--variant merlotwt_output.raw.snps.indels.g.vcf \
--variant merlotwb_output.raw.snps.indels.g.vcf \
-o grape_combined.g.vcf

# Genotype SNPs
module load GATK/3.8-1-0-gf15c1c3ef-Java-1.8.0_112
java -jar $EBROOTGATK/GenomeAnalysisTK.jar \
-T GenotypeGVCFs \
-R Vvinifera.fa \
--variant grape_combined.g.vcf \
-o grape_genotyped.vcf

# Filter variants
module load Java/1.8.0_112

mkdir tmp

java -Xmx15G -jar /mnt/home/rittere5/programs/gatk-4.0.12.0/gatk-package-4.0.12.0-local.jar \
VariantFiltration \
--reference Vvinifera.fa \
--output grape.filtered.vcf \
--variant grape_genotyped.vcf \
--filter-expression "MQ<40.00" \
--filter-name MQ40 \
--filter-expression "FS<60.0" \
--filter-name FS60 \
--filter-expression "QD<2.0" \
--filter-name QD2 \
--filter-expression "MQRankSum<-12.5" \
--filter-name MQRank12 \
--filter-expression "ReadPosRankSum<-8.0" \
--filter-name ReadPosRankSum

rm -r tmp

# Annotate SNPs with snpEff
## First, build database if needed
cd /mnt/home/rittere5/programs/snpeff/snpEff
java -Xmx15G -jar snpEff.jar build -gff3 -v vvinifera12.2
## Now annotate SNPs
java -Xmx15G -jar /mnt/home/rittere5/programs/snpeff/snpEff/snpEff.jar -v vvinifera12.2 grape.filtered.vcf > grape.annotated.vcf

#Done! Should have an output file containing SNPs.
...
