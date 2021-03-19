#!/bin/sh -login


#SBATCH --time=35:59:59             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=5                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=15G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name jitterbug        # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout     # job output filename

export PATH=/mnt/home/rittere5/anaconda3/envs/witchsbroom_py2.7/bin:$PATH
export LD_LIBRARY_PATH="$HOME/anaconda3/envs/witchsbroom_py2.7/lib:$LD_LIBRARY_PATH"

sample=merlotwb

# Run jitterbug on mapped sample to generate TE insertion annotations
python $HOME/programs/jitterbug/jitterbug.py \
merlotwb_bwamem_sorted.bam \
../edta/Vvinifera.fa.mod.EDTA.TEanno.gff3 \
--numCPUs 5 # Activate jitterbug, input file, TE annotation file, and the number of CPUs

# Run jitterbug filter to filter TE insertion annotations identified by jitterbug
python $HOME/programs/jitterbug/tools/jitterbug_filter_results_func.py \
-g jitterbug.TE_insertions_paired_clusters.gff3 \
-c jitterbug.filter_config.txt \
-o $sample.TE_insertions_paired_clusters.filtered.gff3 #Activate jitterbug, TE gff3 input file, filter file, and output file
...
