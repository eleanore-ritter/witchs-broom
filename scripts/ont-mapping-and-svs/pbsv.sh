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

#Set variables
mapper="minimap2"
ID=$(pwd | sed s/^.*\\/// | sed s/${mapper}_pbsv// | sed 's/.*_//')
PU="ont"
PL="ont"
LB="lib1"

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
sample=$(pwd | sed s/^.*\\/// | sed s/minimap2_pbsv// | sed 's/.*_//')
bamfile=$(ls *.bam)
path1="$HOME/witchs-broom/refs/new_grape_assembly/genome"
path2="${path1}/${sample1}/assembly"

#Declare samples
echo "Sample is ${sample} and reference is at ${path1}"

#Check for mapped reads
echo "Checking for mapped reads"

if ls *.bam >/dev/null 2>&1
then
        echo "BAM file detected"
else
        echo "No mapped reads detected, run minimap2 and restart"
fi

#Make pbsv directory and change directories
mkdir pbsv
cd pbsv

#Add read group tags to mapped reads
#echo "Adding read group tags to bam file"

#samtools addreplacerg \
#-r "@RG\tID:$ID\tLB:$LB\tPL:$PL\tSM:${sample2}\tPU:$PU" \
#-o ${bamfile}-rg.bam \
#../${bamfile}

#Run pbsv
echo "Running pbsv to discover signatures of structural variantion on ${sample}"
pbsv discover ../*rg.bam \
${sample}.svsig.gz

echo "Calling structural variants and assigning genotypes with pbsv"
pbsv call \
${path1}/*.fa \
*.svsig.gz \
${sample}.var.vcf

echo "Done"
