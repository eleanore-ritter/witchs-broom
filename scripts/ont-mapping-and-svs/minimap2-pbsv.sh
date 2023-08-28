#!/bin/bash --login
#SBATCH --time=168:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=500GB
#SBATCH --job-name minimap2-pbsv
#SBATCH --output=job_reports/%x-%j.SLURMout

#Set this variable to the path to wherever you have conda installed
conda="/mnt/home/rittere5/anaconda3/"

#THIS WILL NEED TO BE CHANGED FOR THE SAMPLES BEING COMPARED
sample=$(pwd | sed s/^.*\\///)
dt="map-ont"

#Set variables
threads=4
ID=$(pwd | sed s/^.*\\///)
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
path1="$HOME/witchs-broom/refs/new_grape_assembly/genome"
path2="fastq/ont"
path3="minimap2_pbsv_${sample}"
fastq="${path2}/clean.fastq.gz"


#Declare samples
echo "sample is ${sample}"
echo "minimap2 will map ${sample} reads to reference at ${path1}"

#Move to output directory
if ls ${path3} >/dev/null 2>&1
then
	echo "Output directory ${path3} already exists"
else
	mkdir ${path3}
        echo "Made output directory: ${path3}"
fi

#Make minimap2 index
echo "Checking for minimap2 index"

if ls ${path3}/*.mmi >/dev/null 2>&1
then
        echo "Index detected"
else
        echo "No index detected, creating index"
        minimap2 \
                -x ${dt} \
                -d ${path3}/Vvinifera.mmi \
                ${path1}/*.fa
fi
	
#Run minimap2
echo "Running minimap2"

minimap2 \
-a --MD --eqx -L -O 5,56 -E 4,1 -B 5 --secondary=no -z 400,50 -r 2k -Y \
${path3}/Vvinifera.mmi \
${fastq} \
-t ${threads} > ${path3}/aln.sam

#Make sorted bam file and remove sam file
echo "Creating sorted bam file"

cd ${path3}

samtools sort aln.sam > aln-sorted.bam
rm aln.sam

samtools addreplacerg \
-r "@RG\tID:$ID\tLB:$LB\tPL:$PL\tSM:${sample}\tPU:$PU" \
-o aln-sorted-rg.bam \
aln-sorted.bam

echo "Done"
