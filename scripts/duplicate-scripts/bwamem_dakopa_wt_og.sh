#!/bin/sh -login


#SBATCH --time=35:59:59             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=15G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name bwamem           # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout

ID=$(zcat /mnt/home/rittere5/grape_project/data/trimmed_sequences/Dakopa_Wild_Type_S3_L002_R1_001.cutadapt.fq.gz | head -1 | cut -d ':' -f 3,4 | tr ':' '.')
PU=$(zcat /mnt/home/rittere5/grape_project/data/trimmed_sequences/Dakopa_Wild_Type_S3_L002_R1_001.cutadapt.fq.gz | head -1 | cut -d ':' -f 3,4,10 | tr ':' '.')
SM="DakopaWT"
PL="ILLUMINA"
LB="lib1"

#change to working directory
cd $PBS_O_WORKDIR

bwa mem \
-M \
-R "@RG\tID:$ID\tLB:$LB\tPL:$PL\tSM:$SM\tPU:$PU" \
Vvinifera.12X.fa \
$HOME/grape_project/data/trimmed_sequences/Dakopa_Wild_Type_S3_L002_R1_001.cutadapt.fq.gz \
$HOME/grape_project/data/trimmed_sequences/Dakopa_Wild_Type_S3_L002_R2_001.cutadapt.fq.gz > Dakopa_WT_bwamem_og.bam
....

