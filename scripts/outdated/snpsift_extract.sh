#!/bin/sh -login


#SBATCH --time=40:59:59             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=19G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name snpsift          # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout

#change to working directory
cd $PBS_O_WORKDIR

java -Xmx19G -jar /mnt/home/rittere5/programs/snpeff/snpEff/SnpSift.jar \
extractFields grape.casecontrol.vcf CHROM POS ID REF ALT FILTER Cases Controls CC_DOM \
CC_REC CC_ALL CC_GENO  CC_TREND \
"ANN[*].ALLELE" "ANN[*].EFFECT" "ANN[*].IMPACT:" "ANN[*].GENE:" "ANN[*].GENEID:" > grape.casecontrol.extracted_1.txt
...
