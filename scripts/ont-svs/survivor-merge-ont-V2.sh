#!/bin/sh -login


#SBATCH --time=100:00:00            # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=25G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name survivor_merge_V2     # you can give your job a name for easier identification (same as -J)
#SBATCH --output=job_reports/%x_%j.SLURMout

#Set conda path
conda="/mnt/home/rittere5/anaconda3/"

#Can modify these settings to change stringency
maxdis=300

#Change to current directory
cd ${PBS_O_WORKDIR}

#Export paths to conda
export PATH="${conda}/envs/svs/bin:${PATH}"
export LD_LIBRARY_PATH="${conda}/envs/svs/lib:${LD_LIBRARY_PATH}"

#Variables should not need to be changed
sample=$(pwd | sed s/^.*\\///)
path1="merged_svs"

#Change directory
cd ${path1}

#Merge SVs called from ont reads
echo "All inputs should already be filtered by user. Check survivor input files if unsure."

echo "Making ont-svs-merged file by merging sniffles, nanosv, and pbsv - SVs must match for two programs"

SURVIVOR merge survivor_ont ${maxdis} 2 1 1 0 30 ${sample}_ont-merged-svs_V1.vcf

echo "Making ont-svs-merged file by merging sniffles, nanosv, and pbsv - SVs must match for three programs"

SURVIVOR merge survivor_ont ${maxdis} 3 1 1 0 30 ${sample}_ont-merged-svs_V2.vcf

echo "Done"
