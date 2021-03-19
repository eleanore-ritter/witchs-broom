#!/bin/sh -login


#SBATCH --time=03:59:59             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=15G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name awk              # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout

#change to working directory
cd $PBS_O_WORKDIR

awk '$3 ~ "0/0/0/0"' dakopawt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/0/1/1"' dakopawt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/0/2/2"' dakopawt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "1/1/1/1"' dakopawt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "1/1/0/0"' dakopawt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "1/1/2/2"' dakopawt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "2/2/2/2"' dakopawt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "2/2/0/0"' dakopawt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "2/2/1/1"' dakopawt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "1/1/3/3"' dakopawt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "3/3/3/3"' dakopawt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "3/3/0/0"' dakopawt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "3/3/1/1"' dakopawt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/0/3/3"' dakopawt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/1/1/1"' dakopawt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/1/0/1"' dakopawt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/1/0/2"' dakopawt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/0/0/0"' dakopawb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/0/1/1"' dakopawb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/0/2/2"' dakopawb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "1/1/1/1"' dakopawb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "1/1/0/0"' dakopawb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "1/1/2/2"' dakopawb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "2/2/2/2"' dakopawb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "2/2/0/0"' dakopawb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "2/2/1/1"' dakopawb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "1/1/3/3"' dakopawb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "3/3/3/3"' dakopawb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "3/3/0/0"' dakopawb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "3/3/1/1"' dakopawb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/0/3/3"' dakopawb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/1/1/1"' dakopawb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/1/0/1"' dakopawb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/1/0/2"' dakopawb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/0/0/0"' merlotwt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/0/1/1"' merlotwt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/0/2/2"' merlotwt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "1/1/1/1"' merlotwt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "1/1/0/0"' merlotwt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "1/1/2/2"' merlotwt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "2/2/2/2"' merlotwt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "2/2/0/0"' merlotwt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "2/2/1/1"' merlotwt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "1/1/3/3"' merlotwt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "3/3/3/3"' merlotwt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "3/3/0/0"' merlotwt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "3/3/1/1"' merlotwt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/0/3/3"' merlotwt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/1/1/1"' merlotwt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/1/0/1"' merlotwt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/1/0/2"' merlotwt_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/0/0/0"' merlotwb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/0/1/1"' merlotwb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/0/2/2"' merlotwb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "1/1/1/1"' merlotwb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "1/1/0/0"' merlotwb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "1/1/2/2"' merlotwb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "2/2/2/2"' merlotwb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "2/2/0/0"' merlotwb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "2/2/1/1"' merlotwb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "1/1/3/3"' merlotwb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "3/3/3/3"' merlotwb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "3/3/0/0"' merlotwb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "3/3/1/1"' merlotwb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/0/3/3"' merlotwb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/1/1/1"' merlotwb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/1/0/1"' merlotwb_alt12_pld4.unique_snps.txt | wc -l
awk '$3 ~ "0/1/0/2"' merlotwb_alt12_pld4.unique_snps.txt | wc -l
...
