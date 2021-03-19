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

java -Xmx15G -jar /mnt/home/rittere5/programs/gatk-4.0.12.0/gatk-package-4.0.12.0-local.jar \
-T GenotypeConcordance \
-R ../Vvinifera.12X.fa \
-eval dakopawb_alt_12_pld4.raw.snps.indels.g.vcf \
-comp dakopawt_alt_12_pld4.raw.snps.indels.g.vcf \
-o output.grp \
--ignoreFilters \
...
