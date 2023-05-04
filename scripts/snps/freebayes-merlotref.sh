#!/bin/sh -login


#SBATCH --time=99:59:59             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=500G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name freebayes        # you can give your job a name for easier identification (same as -J)
#SBATCH --output=job_reports/%x_%j.SLURMout

#Set this variable to the path to wherever you have conda installed
conda="/mnt/home/rittere5/anaconda3/"

#Change to current directory
cd ${PBS_O_WORKDIR}

#Export paths to conda
export PATH="${conda}/envs/variant-calling/bin:${PATH}"
export LD_LIBRARY_PATH="${conda}/envs/variant-calling/lib:${LD_LIBRARY_PATH}"

#Set temporary directories for large memory operations
export TMPDIR=$(pwd | sed s/data.*/data/)
export TMP=$(pwd | sed s/data.*/data/)
export TEMP=$(pwd | sed s/data.*/data/)

cd snps/wgs

echo "Call SNPs with freebayes"
freebayes \
-f /mnt/gs21/scratch/rittere5/witchs-broom/ref/merlot/VITVvi_vMerlFPS15_v1.1.haplotigs.fasta \
-g 1000 \
merlotwt-rg.bam \
merlotwb-rg.bam \
> Merlot_merlotref_freebayes_snps_wgs_raw.vcf

echo "Done"
