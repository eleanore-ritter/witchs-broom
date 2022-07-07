#!/bin/sh -login


#SBATCH --time=99:59:59             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=15G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name annovar           # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout

#change to working directory
cd $PBS_O_WORKDIR

echo "Running annovar on DakapoWT"
perl $HOME/programs/annovar/annotate_variation.pl \
--buildver VV -v --outfile DakapoWT filtered.2022.DakopaWT.avinput $HOME/programs/annovar/VVdb

echo "Running annovar on DakapoWB"
perl $HOME/programs/annovar/annotate_variation.pl \
--buildver VV -v --outfile DakapoWB filtered.2022.DakopaWB.avinput $HOME/programs/annovar/VVdb

echo "Running annovar on MerlotWT"
perl $HOME/programs/annovar/annotate_variation.pl \
--buildver VV -v --outfile MerlotWT filtered.2022.MerlotWT.avinput $HOME/programs/annovar/VVdb

echo "Running annovar on MerlotWB"
perl $HOME/programs/annovar/annotate_variation.pl \
--buildver VV -v --outfile MerlotWB filtered.2022.MerlotWB.avinput $HOME/programs/annovar/VVdb

echo "Done"
