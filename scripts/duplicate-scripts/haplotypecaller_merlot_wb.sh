#!/bin/sh -login


#SBATCH --time=30:59:59                  # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                        # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1              # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=5                # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=15G                        # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name haplotype_caller      # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout

module load GATK/3.8-1-0-gf15c1c3ef-Java-1.8.0_112
java -jar $EBROOTGATK/GenomeAnalysisTK.jar \
-R Vvinifera.fa \
-T HaplotypeCaller \
-I Merlot_WB_marked_duplicates.bam \
--emitRefConfidence GVCF \
-nct 5 \
-o merlotwb_output.raw.snps.indels.g.vcf

...
