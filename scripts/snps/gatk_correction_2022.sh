#!/bin/sh -login


#SBATCH --time=99:59:59             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=15G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name gatk             # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout

#change to working directory
cd $PBS_O_WORKDIR

module load Java/1.8.0_112

mkdir tmp

gunzip /mnt/home/rittere5/witchs-broom/results/2019-01-23-combined-snps/grape_combined.g.vcf.gz

echo "Genotyping SNPs"
module load GATK/3.8-1-0-gf15c1c3ef-Java-1.8.0_112
java -jar $EBROOTGATK/GenomeAnalysisTK.jar \
-T GenotypeGVCFs \
-R /mnt/home/rittere5/witchs-broom/refs/new_grape_assembly/genome/Vvinifera.fa \
--variant /mnt/home/rittere5/witchs-broom/results/2019-01-23-combined-snps/grape_combined.g.vcf \
-o grape_genotyped.2022.vcf

echo "Filtering variants"
java -Xmx15G -jar /mnt/home/rittere5/programs/gatk-4.0.12.0/gatk-package-4.0.12.0-local.jar \
VariantFiltration \
--reference /mnt/home/rittere5/witchs-broom/refs/new_grape_assembly/genome/Vvinifera.fa \
--output grape.filtered.2022.vcf \
--variant grape_genotyped.2022.vcf \
--filter-expression "MQ<40.00" \
--filter-name MQ40 \
--filter-expression "FS>60.0" \
--filter-name FS60 \
--filter-expression "QD<2.0" \
--filter-name QD2 \
--filter-expression "MQRankSum<-12.5" \
--filter-name MQRank12 \
--filter-expression "ReadPosRankSum<-8.0" \
--filter-name ReadPosRankSum  

rm -r tmp

echo "Done"
