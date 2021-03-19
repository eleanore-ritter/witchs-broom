#!/bin/sh -login


#SBATCH --time=03:59:59             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=5                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=15G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name jitterbug        # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout

source activate py2 #Activates python 2.7 for jitterbug

python $HOME/programs/jitterbug/jitterbug.py $HOME/grape_project/data/sorted_reads/Merlot_WT_bwamem_1_sorted.bam \
$HOME/grape_project/new_grape_assembly/annotations/TEs.gff3 \
--numCPUs 5 

...
