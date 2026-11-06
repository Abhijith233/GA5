#!/bin/bash
#SBATCH --account=PAS3493
#SBATCH --cpus-per-task=8
#SBATCH --time=30
#SBATCH --output=slurm-trimgalore-%j.out
#SBATCH --mail-type=FAIL
set -euo pipefail

# Run TrimGalore on the paired-end FASTQ files of one sample
# Usage: sbatch scripts/trimgalore.sh <R1 FASTQ file> <R2 FASTQ file> <output dir>

# Constants
TRIMGALORE_CONTAINER=oras://community.wave.seqera.io/library/trim-galore:2.3.0--a56e49e832976df4

# Copy the placeholder variables
fastq_r1="$1"
fastq_r2="$2"
outdir="$3"

# Initial logging
echo "# Starting script trimgalore.sh"
date
echo "# Input R1 FASTQ file:      $fastq_r1"
echo "# Input R2 FASTQ file:      $fastq_r2"
echo "# Output dir:               $outdir"
echo

# Create the output dir (with a subdir for Slurm logs)
mkdir -p "$outdir"/logs

# Run TrimGalore
apptainer exec "$TRIMGALORE_CONTAINER" trim_galore \
    --cores 8 \
    --paired \
    --fastqc \
    --output_dir "$outdir" \
    "$fastq_r1" \
    "$fastq_r2"

# Build the output file names:
sample_id=$(basename "$fastq_r1" _R1.fastq.gz)
R1_out_init="$outdir"/"$sample_id"_R1_val_1.fq.gz
R2_out_init="$outdir"/"$sample_id"_R2_val_2.fq.gz
R1_out_final="$outdir"/"$sample_id"_R1.fastq.gz
R2_out_final="$outdir"/"$sample_id"_R2.fastq.gz

# Rename the output files:
echo
echo "# Renaming the output files:"
mv -v "$R1_out_init" "$R1_out_final"
mv -v "$R2_out_init" "$R2_out_final"

# Final logging
echo
echo "# TrimGalore version:"
apptainer exec "$TRIMGALORE_CONTAINER" trim_galore --version
echo "# Successfully finished script trimgalore.sh"
date
