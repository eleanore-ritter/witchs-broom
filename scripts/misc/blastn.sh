#!/bin/bash --login
#SBATCH --time=03:59:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=200GB
#SBATCH --job-name blastn
#SBATCH --output=%x-%j.SLURMout

#Set this variable to the path to wherever you have conda installed
conda="${HOME}/anaconda3"

#Change to current directory
cd ${PBS_O_WORKDIR}
#Export paths to conda
export PATH="${conda}/envs/maker/bin:${PATH}"
export LD_LIBRARY_PATH="${conda}/envs/maker/lib:${LD_LIBRARY_PATH}"

#Set temporary directories for large memory operations
export TMPDIR=$(pwd)
export TMP=$(pwd)
export TEMP=$(pwd)

#Make blast db
echo "Make blast db"
makeblastdb \
-in $HOME/witchs-broom/refs/new_grape_assembly/genome/Vvinifera.fa \
-dbtype nucl \
-parse_seqids \
-out Vvinifera

echo "Running blastn"
blastn \
-query scd1-ins-seq-igv-upper.fa \
-task blastn \
-db Vvinifera \
-out scd1-ins

echo "Done"
