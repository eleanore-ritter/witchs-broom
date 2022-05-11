#!/bin/bash --login
#SBATCH --time=168:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=500GB
#SBATCH --job-name nanosv
#SBATCH --output=job_reports/%x-%j.SLURMout

#Set this variable to the path to wherever you have conda installed
conda="/mnt/home/rittere5/anaconda3/"

#Set variables
threads=4
mapper="minimap2"
config="/mnt/gs18/scratch/users/rittere5/witchs-broom/scripts/config-nanosv.ini"

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

#Check for bam index
echo "Checking for bam index"

if ls *.bai >/dev/null 2>&1
then
        echo ".bai file detected"
else
        echo "No .bai file  detected, creating bam index now"
	samtools index -b *.bam
fi

#Make nanosv directory and change directories
mkdir nanosv
cd nanosv

#Run NanoSV
echo "Running NanoSV on ${sample1} and ${sample2}"

NanoSV -t ${threads} \
-c ${config} \
-o ${sample}_nanosv.vcf \
-s sambamba \
../*.bam

echo "Done"
