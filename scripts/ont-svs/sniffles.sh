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

#Set variables
threads=4
mapper="minimap2"

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
sample=$(pwd | sed s/^.*\\/// | sed s/${mapper}_//)

#Declare samples
echo "Sample is ${sample}"

#Check for mapped reads
echo "Checking for mapped reads"

if ls *.bam >/dev/null 2>&1
then
        echo "BAM file detected"
else
        echo "No mapped reads detected, run minimap2 and restart"
fi

#Make sniffles directory and change directory
mkdir sniffles
cd sniffles

#Run sniffles
echo "Running sniffles on ${sample}"
sniffles -m ../*.bam \
-v ${sample}_sniffles.vcf \
-t ${threads} \
-s 1

echo "Done"
