#!/bin/bash --login
#SBATCH --time=96:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=80GB
#SBATCH --job-name edta
#SBATCH --output=job_reports/%x-%j.SLURMout

cd $PBS_O_WORKDIR
export PATH="$HOME/anaconda3/envs/edta/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/anaconda3/envs/edta/lib:$LD_LIBRARY_PATH"

#Set tmp directories
export TMPDIR=$PBS_O_WORKDIR
export TMP=$PBS_O_WORKDIR
export TEMP=$PBS_O_WORKDIR

#Define variables
sample = Vvinifera-new

#Run EDTA
echo "Running EDTA for $sample"
perl $HOME/anaconda3/envs/edta/bin/EDTA.pl \
	--genome $HOME/witchs-broom/refs/new_grape_assembly/genome/Vvinifera.fa \
	--species others \
	--step all \
	--overwrite 1 \
	--cds cds.fa \
	--sensitive 0 \
	--anno 1 \
	--evaluate 0 \
	--threads 10

