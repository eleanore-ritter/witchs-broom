#!/bin/sh -login


#SBATCH --time=03:59:59             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=15G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name bcftools         # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout

bcftools annotate -Ov -x 'ID' -I +'%CHROM:%POS:%REF:%ALT' grape_og_alt12_pld4.annotated.vcf -o grape_pld4_bcf_annotated.vcf
...
