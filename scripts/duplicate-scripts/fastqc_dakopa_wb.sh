#!/bin/sh -login


#SBATCH --time=05:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1          # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=10G            # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name fastqc      # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x-%j.SLURMout

#change to working directory
cd $PBS_O_WORKDIR
			
fastqc -o /mnt/home/rittere5/ch_rotation/fastqc_cleaned_reads/ \
-f fastq -t 1 Dakopa_Witch_s_Broom_S4_L002_R1_001.cutadapt.fq.gz \
Dakopa_Witch_s_Broom_S4_L002_R2_001.cutadapt.fq.gz

