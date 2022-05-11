#!/bin/bash --login
#SBATCH --time=168:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=500GB
#SBATCH --job-name sniffles
#SBATCH --output=job_reports/%x-%j.SLURMout

#Set this variable to the path to wherever you have conda installed
conda="/mnt/home/rittere5/anaconda3/"

#Change to current directory
cd ${PBS_O_WORKDIR}
#Export paths to conda
export PATH="${conda}/envs/sniffles2/bin:${PATH}"
export LD_LIBRARY_PATH="${conda}/envs/sniffles2/lib:${LD_LIBRARY_PATH}"

#Set temporary directories for large memory operations
export TMPDIR=$(pwd | sed s/data.*/data/)
export TMP=$(pwd | sed s/data.*/data/)
export TEMP=$(pwd | sed s/data.*/data/)

#The following shouldn't need to be changed, but should set automatically
variety=$(pwd | sed s/^.*\\///)

#Declare samples
echo "Variety is ${variety}"

#Make sniffles directory and change directory
mkdir sniffles-multi
cd sniffles-multi

#Run sniffles
echo "Running sniffles on dakapowb"
sniffles --input ../merlotwb/minimap2_merlotwb/*.bam \
--snf merlotwb.snf

echo "Running sniffles on dakapowt"
sniffles --input ../merlotwt/minimap2_merlotwt/*.bam \
--snf merlotwt.snf

echo "Running combined calling on dakapowt and dakapowb"
sniffles --input merlotwb.snf merlotwt.snf \
--vcf merlot_sniffles.vcf

echo "Done"
