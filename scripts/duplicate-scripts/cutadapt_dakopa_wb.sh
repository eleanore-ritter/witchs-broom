#!/bin/sh -login


#SBATCH --time=07:59:59             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=10G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name cutadapt         # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout

#change to working directory
cd $PBS_O_WORKDIR
			
# run cutadapt to clean PE1 read file
# -f file format
# -q trim bases with quality less than 20 from beginning and end of read
# --trim-n trim "N" bases
# -m minimum read length after trimming in 30 bp
# -n remove up to 3 adapters from read ends
# -a Illumina adapter forward read
# -A Illumina adapter reverse read
# -o Output name for read 1
# -p Output name for read 2
cutadapt \
-q 20,20 \
--trim-n \
-m 30 \
-n 3 \
-a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
-A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
-o Dakopa_Witch_s_Broom_S4_L002_R1_001.cutadapt.fq.gz raw_sequences/Dakopa_Witch_s_Broom_S4_L002_R1_001.fastq.gz \
-p Dakopa_Witch_s_Broom_S4_L002_R2_001.cutadapt.fq.gz raw_sequences/Dakopa_Witch_s_Broom_S4_L002_R2_001.fastq.gz 
