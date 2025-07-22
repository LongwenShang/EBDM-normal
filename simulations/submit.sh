#!/bin/bash
#SBATCH -J EBDM_sim
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH -t 00:10:00
#SBATCH --account=your-account-name  # (Optional) specify your SLURM account

# Load R module (adjust according to your cluster environment)
module load r

# Optional: set R_LIBS if required by your cluster
# mkdir -p ~/.local/R/$EBVERSIONR/
# export R_LIBS=~/.local/R/$EBVERSIONR/

Rscript --max-ppsize=500000 ./main.R $1