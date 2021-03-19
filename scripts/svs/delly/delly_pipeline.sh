#!/bin/sh -login


#SBATCH --time=100:00:00            # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=5                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=15G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name delly            # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout


#change to working directory
cd $PBS_O_WORKDIR

# Run delly call
delly call \
-g $HOME/witchs-broom/refs/new_grape_assembly/genome/Vvinifera.fa \
-o delly_dakapo_pn.bcf \
$HOME/witchs-broom/results/2019-01-18-marked-dup-reads/dakapowt/dakapowt_marked_duplicates.bam \
$HOME/witchs-broom/results/2019-01-18-marked-dup-reads/dakapowb/dakapowb_marked_duplicates.bam

# Run delly filter
delly filter \
-o delly_dakapo_pn.pre.bcf \
-f somatic \
-s samples_1.tsv \
delly_dakapo_pn.bcf

# Run delly call again
delly call \
-g $HOME/witchs-broom/refs/new_grape_assembly/genome/Vvinifera.fa \
-v delly_dakapo_pn.pre.bcf \
-o delly_dakapo_pn.geno.bcf \
$HOME/witchs-broom/results/2019-01-18-marked-dup-reads/dakapowt/dakapowt_marked_duplicates.bam \
$HOME/witchs-broom/results/2019-01-18-marked-dup-reads/dakapowb/dakapowb_marked_duplicates.bam

# Run delly filter again
delly filter \
-o delly_dakapo_pn.somatic.bcf \
-f somatic \
-s samples_1.tsv \
delly_dakapo_pn.geno.bcf
....
