#!/bin/sh -login


#SBATCH --time=03:59:59             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=19G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name snpsift          # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout

#change to working directory
cd $PBS_O_WORKDIR

#echo "Getting DWB specific SNPs"

#cat grape.filtered.2022.vcf | java -Xmx19G -jar /mnt/home/rittere5/programs/snpeff/snpEff/SnpSift.jar \
#filter "!(isRef(GEN[0]))" > temp.vcf

#cat temp.vcf | java -Xmx19G -jar /mnt/home/rittere5/programs/snpeff/snpEff/SnpSift.jar \
#filter "(isRef(GEN[1]))" > dwb-specific-snps.vcf

#cat temp.vcf | java -Xmx19G -jar /mnt/home/rittere5/programs/snpeff/snpEff/SnpSift.jar \
#filter "!(isVariant(GEN[1]) & isHom(GEN[1]))" > temp2.vcf

#cat temp2.vcf | java -Xmx19G -jar /mnt/home/rittere5/programs/snpeff/snpEff/SnpSift.jar \
#filter "(isVariant(GEN[0]) & isRef(GEN[1]))|(isHom(GEN[0]) & isHet(GEN[1]))" > dwb-unq-geno-snps.vcf

#wc -l temp.vcf
#rm temp.vcf

#wc -l temp2.vcf
#rm temp2.vcf

echo "Getting MWB specific SNPs"

cat grape.filtered.2022.vcf | java -Xmx19G -jar /mnt/home/rittere5/programs/snpeff/snpEff/SnpSift.jar \
filter "!(isRef(GEN[2]))" > temp.vcf

cat temp.vcf | java -Xmx19G -jar /mnt/home/rittere5/programs/snpeff/snpEff/SnpSift.jar \
filter "(isRef(GEN[3]))" > mwb-specific-snps.vcf

cat temp.vcf | java -Xmx19G -jar /mnt/home/rittere5/programs/snpeff/snpEff/SnpSift.jar \
filter "!(isVariant(GEN[3]) & isHom(GEN[3]))" > temp2.vcf

cat temp2.vcf | java -Xmx19G -jar /mnt/home/rittere5/programs/snpeff/snpEff/SnpSift.jar \
filter "(isVariant(GEN[2]) & isRef(GEN[3]))|(isHom(GEN[2]) & isHet(GEN[3]))" > mwb-unq-geno-snps.vcf

wc -l temp.vcf
rm temp.vcf

wc -l temp2.vcf
rm temp2.vcf

echo "Getting DWT specific SNPs"

cat grape.filtered.2022.vcf | java -Xmx19G -jar /mnt/home/rittere5/programs/snpeff/snpEff/SnpSift.jar \
filter "!(isRef(GEN[1]))" > temp.vcf

cat temp.vcf | java -Xmx19G -jar /mnt/home/rittere5/programs/snpeff/snpEff/SnpSift.jar \
filter "(isRef(GEN[0]))" > dwt-specific-snps.vcf

cat temp.vcf | java -Xmx19G -jar /mnt/home/rittere5/programs/snpeff/snpEff/SnpSift.jar \
filter "!(isVariant(GEN[0]) & isHom(GEN[0]))" > temp2.vcf

cat temp2.vcf | java -Xmx19G -jar /mnt/home/rittere5/programs/snpeff/snpEff/SnpSift.jar \
filter "(isVariant(GEN[1]) & isRef(GEN[0]))|(isHom(GEN[1]) & isHet(GEN[0]))" > dwt-unq-geno-snps.vcf

wc -l temp.vcf
rm temp.vcf

wc -l temp2.vcf
rm temp2.vcf

echo "Getting MWT specific SNPs"

cat grape.filtered.2022.vcf | java -Xmx19G -jar /mnt/home/rittere5/programs/snpeff/snpEff/SnpSift.jar \
filter "!(isRef(GEN[3]))" > temp.vcf

cat temp.vcf | java -Xmx19G -jar /mnt/home/rittere5/programs/snpeff/snpEff/SnpSift.jar \
filter "(isRef(GEN[2]))" > mwt-specific-snps.vcf

cat temp.vcf | java -Xmx19G -jar /mnt/home/rittere5/programs/snpeff/snpEff/SnpSift.jar \
filter "!(isVariant(GEN[2]) & isHom(GEN[2]))" > temp2.vcf

cat temp2.vcf | java -Xmx19G -jar /mnt/home/rittere5/programs/snpeff/snpEff/SnpSift.jar \
filter "(isVariant(GEN[3]) & isRef(GEN[2]))|(isHom(GEN[3]) & isHet(GEN[2]))" > mwt-unq-geno-snps.vcf

wc -l temp.vcf
rm temp.vcf

wc -l temp2.vcf
rm temp2.vcf

echo "Done"
