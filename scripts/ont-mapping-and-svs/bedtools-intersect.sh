#!/bin/bash --login
#SBATCH --time=03:59:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20GB
#SBATCH --job-name bedtools
#SBATCH --output=%x-%j.SLURMout

#Set this variable to the path to wherever you have conda installed
conda="/mnt/home/rittere5/anaconda3/"

#Set variables
gff="/mnt/gs18/scratch/users/rittere5/witchs-broom/ref/Vvinifera-lifted.gff"
gff1kb="/mnt/gs18/scratch/users/rittere5/witchs-broom/ref/Vvinifera-lifted-1kb.gff"

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
input1=$(ls *V3.vcf)

#Annotate V3 VCF

echo "Annotating ${input1} with ${gff}"
bedtools intersect -b ${gff} -a ${input1} -wo > ${input1}.annotated.txt
awk -F'\t' '{print $21}' ${input1}.annotated.txt | sed 's/ID=//g' | sed 's/\..*//g' | sed 's/GSVIVT/GSVIVG/g' | sort | uniq > ${input1}.genes_list.txt

echo "Annotating ${input1} with ${gff1kb}"
bedtools intersect -b ${gff1kb} -a ${input1} -wo > ${input1}.1kbannotated.txt
awk -F'\t' '{print $21}' ${input1}.1kbannotated.txt | sed 's/ID=//g' | sed 's/\..*//g' | sed 's/GSVIVT/GSVIVG/g' | sort | uniq > ${input1}.1kbgenes_list.txt

echo "Done"
