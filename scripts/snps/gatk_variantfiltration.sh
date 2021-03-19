#!/bin/sh -login


#SBATCH --time=30:59:59             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=15G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name gatk_vf          # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout

#change to working directory
cd $PBS_O_WORKDIR

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

...
