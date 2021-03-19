#!/bin/sh -login


#SBATCH --time=12:59:59                          # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                                # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1                      # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1                        # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=19G                                # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name picard_samsort                # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout

java -Xmx19G -jar /mnt/home/rittere5/programs/picard.jar SortSam \
I=Dakopa_WT_bwamem.bam \
O=Dakopa_WT_bwamem_sorted.bam \
SORT_ORDER=coordinate
...
