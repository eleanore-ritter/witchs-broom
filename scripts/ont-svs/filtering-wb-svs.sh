#!/bin/bash --login
#SBATCH --time=03:59:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20GB
#SBATCH --job-name filtering
#SBATCH --output=%x-%j.SLURMout

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
species=$(pwd | sed s/^.*\\/data\\/// | sed s/\\/.*//)
genotype=$(pwd | sed s/.*\\/${species}\\/// | sed s/\\/.*//)
wb=$(pwd | sed s/.*\\/${genotype}\\/// | sed s/\\/.*//)
wt=$(pwd | sed s/.*\\/${genotype}\\/// | sed s/\\/.*// | sed s/wb/wt/)
caller=$(pwd | sed s/^.*\\///)
path1=$(pwd | sed s/wb/wt/g)
input=$(ls *.vcf)

#Declare samples
echo "WB sample is ${wb} and WT sample is ${wt}"

#Declare caller
echo "Caller is ${caller}"

#Extract first two lines of vcf and prepare for comparing

awk '{ print $1,$2 }' *.vcf | grep -v "#" | sort | uniq > ${wb}_${caller}.txt

awk '{ print $1,$2 }' ${path1}/*.vcf | grep -v "#" | sort | uniq > ${path1}/${wt}_${caller}.txt

#Get WB specific variants
comm -13 ${path1}/${wt}_${caller}.txt ${wb}_${caller}.txt | sed 's/ /\t/g' > ${wb}_${caller}_wbunique.txt

#Sort VCF file and remove header
grep "^#" ${input} > header
grep -v "^#" ${input} | sort -k1,1 -k2,2 > ${wb}_${caller}.sorted.vcf

#Get VCF lines for WB specific variants
awk -F'\t' 'NR==FNR{c[$1$2]++;next};c[$1$2] > 0' ${wb}_${caller}_wbunique.txt ${wb}_${caller}.sorted.vcf > ${wb}_${caller}_unique_test

#Only get variants that pass filter if possible
grep "PASS" ${wb}_${caller}_unique_test >${wb}_${caller}_unique_test1

#Turn previous output into VCF
cat header ${wb}_${caller}_unique_test1 > ${wb}_${caller}_unique.vcf

#Delete unnecessary files
rm ${wb}_${caller}_unique_test*
rm header
rm ${wb}_${caller}_wbunique.txt
rm ${wb}_${caller}.sorted.vcf
rm ${wb}_${caller}.txt

echo "Done"
