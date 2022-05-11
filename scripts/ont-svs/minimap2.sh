#!/bin/bash --login
#SBATCH --time=168:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=500GB
#SBATCH --job-name minimap2
#SBATCH --output=job_reports/%x-%j.SLURMout

#Set this variable to the path to wherever you have conda installed
conda="/mnt/home/rittere5/anaconda3/"

#THIS WILL NEED TO BE CHANGED FOR THE SAMPLES BEING COMPARED
sample=$(pwd | sed s/^.*\\///)

#Set variables
threads=4

#This should match the dataype in the misc/samples.csv file
#Options include:
#"ont" = Raw Nanopore
#"ont-cor" = Corrected Nanopore
#"pac" = raw PacBio
#"pac-cor" = Corrected PacBio
#"hifi" = PacBio HiFi
datatype="ont" 

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
path3="minimap2_${sample}"
fastq="${path2}/clean.fastq.gz"

#Declare samples
echo "sample is ${sample}, reference is fasta in ${path1}"
echo "minimap2 will map ${sample} to reference"

#Move to output directory
if ls ${path3} >/dev/null 2>&1
then
	echo "Output directory ${path3} already exists"
else
	mkdir ${path3}
        echo "Made output directory: ${path3}"
fi

#Set minimap2 options based on datatype
if [ ${datatype} = "ont" ]
then
	dt="map-ont"
	echo "Raw Nanopore reads, using minimap2 argument ${dt}"
elif [ ${datatype} = "pac" ]
then
	dt="map-pb"
	echo "Raw PacBio reads, using minimap2 argument ${dt}"
elif [ ${datatype} = "hifi" ]
then
	dt="map-hifi"
	echo "PacBio Hifi reads, using minimap2 argument ${dt}"
else
	echo "Do not recognize ${datatype}"
	echo "Please check and resubmit"
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
-ax ${dt} \
${path3}/Vvinifera.mmi \
${fastq} \
--MD \
-t ${threads} > ${path3}/aln.sam

#Make sorted bam file and remove sam file
echo "Creating sorted bam file"

samtools sort ${path3}/aln.sam > ${path3}/aln-sorted.bam
rm ${path3}/aln.sam

echo "Done"
