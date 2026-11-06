#!/bin/bash
set -euo pipefail

# Run MultiQC to summarize the output of other programs (e.g. FastQC) in an input dir
# Usage: bash scripts/multiqc.sh <input dir> <output dir>

# Constants
MULTIQC_CONTAINER=oras://community.wave.seqera.io/library/multiqc:1.35--562c547b518ebe20

# Copy the placeholder variables
indir="$1"
outdir="$2"

# Initial logging
echo "# Starting script multiqc.sh"
date
echo "# Input dir:                      $indir"
echo "# Output dir:                     $outdir"
echo

# Create the output dir (with a subdir for Slurm logs)
mkdir -p "$outdir"/logs

# Run MultiQC
apptainer exec "$MULTIQC_CONTAINER" multiqc \
    --outdir "$outdir" \
    "$indir"

# Final logging
echo
echo "# Used MultiQC version:"
apptainer exec "$MULTIQC_CONTAINER" multiqc --version
echo "# Successfully finished script multiqc.sh"
date
