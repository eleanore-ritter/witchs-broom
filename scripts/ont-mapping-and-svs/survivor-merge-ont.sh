#!/bin/sh -login


#SBATCH --time=03:59:00            # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=25G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name survivor_merge     # you can give your job a name for easier identification (same as -J)
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
variety=$(pwd | sed s/^.*\\///)
path1="survivor-joint"

#Change directory
cd ${path1}

#Merge SVs called from ont reads
echo "All inputs should already be filtered by user. Check survivor input files if unsure."

echo "Making ${variety}-joint-merged-V1.vcf file by merging sniffles and pbsv - SVs must match for both programs"

SURVIVOR merge survivor-V3 ${maxdis} 2 1 1 0 30 ${variety}-joint-merged-V3.vcf

echo "Done"
