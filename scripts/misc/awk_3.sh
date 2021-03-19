#!/bin/sh -login


#SBATCH --time=03:59:59             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=15G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name awk_join_dakopawb     # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout

#change to working directory
cd $PBS_O_WORKDIR

awk '$2 == "0"' join_dakopawb_moderate | wc -l
awk '$2 == "1"' join_dakopawb_moderate | wc -l
awk '$2 == "2"' join_dakopawb_moderate | wc -l
awk '$2 == "3"' join_dakopawb_moderate | wc -l
awk '$2 == "01"' join_dakopawb_moderate | wc -l
awk '$2 == "02"' join_dakopawb_moderate | wc -l
awk '$2 == "03"' join_dakopawb_moderate | wc -l
awk '$2 == "12"' join_dakopawb_moderate | wc -l
awk '$2 == "13"' join_dakopawb_moderate | wc -l
awk '$2 == "23"' join_dakopawb_moderate | wc -l
awk '$2 == "012"' join_dakopawb_moderate | wc -l
awk '$2 == "013"' join_dakopawb_moderate | wc -l
awk '$2 == "023"' join_dakopawb_moderate | wc -l
awk '$2 == "123"' join_dakopawb_moderate | wc -l
awk '$2 == "...."' join_dakopawb_moderate | wc -l
...