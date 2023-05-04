#!/bin/sh -login


#SBATCH --time=99:59:59             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=15G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
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

#Set variables
mapper="minimap2"
ID=$(pwd | sed s/^.*\\/// | sed s/minimap2_merlotref_haplotigs_pbsv_// | sed 's/.*_//')
PU="ont"
PL="ont"
LB="lib1"

cd snps

#echo "Fix read groups in bam files"
#samtools addreplacerg \
#-r "@RG\tID:dakapowt\tLB:$LB\tPL:$PL\tSM:dakapowt\tPU:$PU" \
#-o dakapowt-rg.bam \
#$HOME/witchs-broom/results/2019-01-18-marked-dup-reads/dakapowt/dakapowt_marked_duplicates.bam

#samtools addreplacerg \
#-r "@RG\tID:dakapowb\tLB:$LB\tPL:$PL\tSM:dakapowb\tPU:$PU" \
#-o dakapowb-rg.bam \
#$HOME/witchs-broom/results/2019-01-18-marked-dup-reads/dakapowb/dakapowb_marked_duplicates.bam

#samtools addreplacerg \
#-r "@RG\tID:merlotwt\tLB:$LB\tPL:$PL\tSM:merlotwt\tPU:$PU" \
#-o merlotwt-rg.bam \
#$HOME/witchs-broom/results/2019-01-18-marked-dup-reads/merlotwt/merlotwt_marked_duplicates.bam

#samtools addreplacerg \
#-r "@RG\tID:merlotwb\tLB:$LB\tPL:$PL\tSM:merlotwb\tPU:$PU" \
#-o merlotwb-rg.bam \
#$HOME/witchs-broom/results/2019-01-18-marked-dup-reads/merlotwb/merlotwb_marked_duplicates.bam

#Alternative option, but it seems to not replace read groups, only add them, which doesn't work for freebayes it seems
#bamaddrg -b $HOME/witchs-broom/results/2019-01-18-marked-dup-reads/dakapowt/dakapowt_marked_duplicates.bam -s dakapowt -r dakapowt > dakapowt_marked_duplicates.bam

#bamaddrg -b $HOME/witchs-broom/results/2019-01-18-marked-dup-reads/dakapowb/dakapowb_marked_duplicates.bam -s dakapowb -r dakapowb > dakapowb_marked_duplicates.bam

#bamaddrg -b $HOME/witchs-broom/results/2019-01-18-marked-dup-reads/merlotwt/merlotwt_marked_duplicates.bam -s merlotwt -r merlotwt > merlowt_marked_duplicates.bam

#bamaddrg -b $HOME/witchs-broom/results/2019-01-18-marked-dup-reads/merlotwb/merlotwb_marked_duplicates.bam -s merlotwb -r merlotwb > merlowb_marked_duplicates.bam

echo "Index bam files"

samtools index -b dakapowt-rg.bam

samtools index -b dakapowb-rg.bam

samtools index -b merlotwt-rg.bam

samtools index -b merlotwb-rg.bam

echo "Call SNPs with freebayes"
freebayes \
-f /mnt/home/rittere5/witchs-broom/refs/new_grape_assembly/genome/Vvinifera.fa \
-g 1000 \
-r chr01:1-24233537 \
dakapowt-rg.bam \
dakapowb-rg.bam \
merlotwt-rg.bam \
merlotwb-rg.bam \
> Vvinifera_freebayes_snps_raw_chr01.vcf

echo "Done"
echo "Delete new BAM files if freebayes will not be re-run"
