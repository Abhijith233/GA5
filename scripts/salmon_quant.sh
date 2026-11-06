#!/bin/bash
#SBATCH --account=PAS3493
#SBATCH --cpus-per-task=8
#SBATCH --time=30
#SBATCH --mail-type=FAIL
#SBATCH --output=slurm-salmon_quant-%j.out
set -euo pipefail

# Quantify transcript expression with Salmon for the paired-end FASTQ files of one sample
# Usage: sbatch scripts/salmon_quant.sh <R1 FASTQ file> <R2 FASTQ file> <Salmon index dir> <output dir>

# Constants
SALMON_CONTAINER=oras://community.wave.seqera.io/library/salmon:2.8.0--3c08cbdc1b311e75

# Copy the placeholder variables
R1="$1"
R2="$2"
index_dir="$3"
outdir="$4"

# Infer the "sample ID" - we need this for the output dir specification
sample_id=$(basename "$R1" _R1.fastq.gz)

# Initial logging
echo "# Starting script salmon_quant.sh"
date
echo "# Input R1 FASTQ file:            $R1"
echo "# Input R2 FASTQ file:            $R2"
echo "# Input Salmon index:             $index_dir"
echo "# Output dir:                     $outdir"
echo "# Sample ID (inferred):           $sample_id"
echo

# Create the output dir (with a subdir for Slurm logs)
mkdir -p "$outdir"/logs

# Run Salmon
apptainer exec "$SALMON_CONTAINER" salmon quant \
    --index "$index_dir" \
    --libType A \
    --mates1 "$R1" \
    --mates2 "$R2" \
    --threads 8 \
    --output "$outdir"/"$sample_id"

#? - Note: keeping this command as simple as possible -
#?   if using Salmon in your research, then look into, e.g., the --gcBias and
#?   --seqBias options as well.
#? - Explanation of some of the options used:
#?   --libType A                     => Automatically infer the library type (e.g., strandedness)
#?   --mates1 / --mates2             => The R1 and R2 FASTQ files of a paired-end sample
#?   --output "$outdir"/"$sample_id" => Each sample gets its own output dir

# Final logging
echo
echo "# Used Salmon version:"
apptainer exec "$SALMON_CONTAINER" salmon --version
echo "# Successfully finished script salmon_quant.sh"
date
