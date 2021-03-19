#!/bin/sh -login


#SBATCH --time=40:59:59             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=12G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name bedtools         # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout

#change to working directory
cd $PBS_O_WORKDIR

bedtools intersect \
-a jitterbug_dakopa_wt/dakopawb.jitterbug.TE_insertions_paired_clusters.filtered.gff3 \
-b jitterbug_dakopa_wt/dakopawt.jitterbug.TE_insertions_paired_clusters.filtered.gff3 \
-nonamecheck \
-v \
> dakopawb_bedtools_different_TEs.gff3
...
