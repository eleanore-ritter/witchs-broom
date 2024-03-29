#!/bin/sh -login


#SBATCH --time=15:59:59             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=15G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name combine_gcvfs    # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout

module load GATK/3.8-1-0-gf15c1c3ef-Java-1.8.0_112
java -jar $EBROOTGATK/GenomeAnalysisTK.jar \
-T CombineGVCFs \
-R Vvinifera.fa \
--variant dakopawb_output.raw.snps.indels.g.vcf \
--variant dakopawt_output.raw.snps.indels.g.vcf \
--variant merlotwt_output.raw.snps.indels.g.vcf \
--variant merlotwb_output.raw.snps.indels.g.vcf \
-o grape_combined.g.vcf

...