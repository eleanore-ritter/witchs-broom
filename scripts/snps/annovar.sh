#!/bin/sh -login


#SBATCH --time=03:59:59             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=15G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name annovar           # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout

#change to working directory
cd $PBS_O_WORKDIR

#List Variables
sample=$(pwd | sed s/^.*\\///)

perl $HOME/programs/annovar/annotate_variation.pl \
--buildver VV -v --outfile $sample grape.$sample.avinput $HOME/programs/annovar/VVdb
...
