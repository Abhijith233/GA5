#!/bin/bash
#SBATCH --account=PAS3493
#SBATCH --cpus-per-task=8
#SBATCH --time=60
#SBATCH --mail-type=FAIL
#SBATCH --output=slurm-salmon_index-%j.out
set -euo pipefail

# Create a Salmon index for a transcriptome FASTA file
# Usage: sbatch scripts/salmon_index.sh <transcriptome FASTA file> <output dir>

# Constants
SALMON_CONTAINER=oras://community.wave.seqera.io/library/salmon:2.8.0--3c08cbdc1b311e75

# Copy the placeholder variables
transcripts="$1"
outdir="$2"

# Initial logging
echo "# Starting script salmon_index.sh"
date
echo "# Input transcriptome FASTA file: $transcripts"
echo "# Output dir:                     $outdir"
echo

# Create the output dir (with a subdir for Slurm logs)
mkdir -p "$outdir"/logs

# Run Salmon
apptainer exec "$SALMON_CONTAINER" salmon index \
    --transcripts "$transcripts" \
    --index "$outdir" \
    --threads 8

#? - Note: This command was kept as simple as possible - if using Salmon in your research,
#?   look into a "decoy-aware" index, which adds the genome sequence as "decoys"
#?   (see https://salmon.readthedocs.io/en/latest/salmon.html#preparing-transcriptome-indices-mapping-based-mode)
#? - Explanation of some of the options used:
#?   --transcripts  => The transcriptome FASTA file (can be gzipped)
#?   --index        => The output dir for the index

# Final logging
echo
echo "# Used Salmon version:"
apptainer exec "$SALMON_CONTAINER" salmon --version
echo "# Successfully finished script salmon_index.sh"
date
