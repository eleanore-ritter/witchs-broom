#!/bin/sh -login


#SBATCH --time=167:59:59            # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --nodes=1                   # number of different nodes - could be an exact number or a range of nodes (same as -N)
#SBATCH --ntasks-per-node=1         # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=80G                   # memory required per allocated CPU (or core) - amount of memory (in bytes)
#SBATCH --job-name liftoff             # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x_%j.SLURMout

#change to working directory
cd $PBS_O_WORKDIR

export PATH=/mnt/home/rittere5/anaconda3/envs/witchsbroom_py3/bin:$PATH
export LD_LIBRARY_PATH="$HOME/anaconda3/envs/witchsbroom_py3/lib:$LD_LIBRARY_PATH"

liftoff -t $HOME/witchs-broom/refs/new_grape_assembly/genome/Vvinifera.fa \
-r $HOME/witchs-broom/refs/old_grape_assembly/genome/Vvinifera_145_Genoscope.12X.fa \
-g $HOME/witchs-broom/refs/old_grape_assembly/annotations/Vvinifera_145_Genoscope.12X.gene.gff3 \
-o old_grape_lifted.gff \
-copies \
-dir temp
...
