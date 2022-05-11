#!/bin/bash --login
#SBATCH --time=168:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=200GB
#SBATCH --job-name pbsv
#SBATCH --output=job_reports/%x-%j.SLURMout

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

#The following shouldn't need to be changed, but should set automatically
variety=$(pwd | sed s/^.*\\///)
path1="$HOME/witchs-broom/refs/new_grape_assembly/genome"

#Declare samples
echo "Variety is ${variety} and reference is at ${path1}"

#Make pbsv directory and change directories
mkdir pbsv-joint-test
cd pbsv-joint-test

echo "Calling structural variants and assigning genotypes with pbsv"
pbsv call \
${path1}/*.fa \
../dakapowt/minimap2_pbsv_dakapowt/pbsv/dakapowt.svsig.gz \
../dakapowb/minimap2_pbsv_dakapowb/pbsv/dakapowb.svsig.gz \
${variety}.var.vcf

echo "Done"
