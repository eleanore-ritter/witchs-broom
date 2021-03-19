#!/bin/sh -login


#SBATCH --time=42:59:59             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=5                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=15G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name bwaaln           # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout


#change to working directory
cd $PBS_O_WORKDIR

lumpyexpress \
-B $HOME/grape_project/data/raw_mapped_reads/Dakopa_WT_bwamem_1.bam, $HOME/grape_project/data/raw_mapped_reads/Dakopa_WB_bwamem.bam \
-o dakopa_wtwb_svs.vcf
....