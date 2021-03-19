#!/bin/sh -login


#SBATCH --time=100:59:59            # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=80G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name smoove           # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout


#change to working directory
cd $PBS_O_WORKDIR

export PATH=/mnt/home/rittere5/anaconda3/envs/lumpy/bin:$PATH
export LD_LIBRARY_PATH="$HOME/anaconda3/envs/lumpy/lib:$LD_LIBRARY_PATH"

smoove call -x --name dakapo-pn --fasta $HOME/witchs-broom/refs/new_grape_assembly/genome/Vvinifera.fa \
-p 1 \
--genotype $HOME/witchs-broom/results/2019-01-18-marked-dup-reads/dakapowb/dakapowb_marked_duplicates.bam \
$HOME/witchs-broom/results/2019-01-18-marked-dup-reads/dakapowt/dakapowt_marked_duplicates.bam
....
