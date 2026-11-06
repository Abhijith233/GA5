# RNA-seq analysis of *Culex pipiens*

-   Author: Abhijith Anil

-   Date created: 11/5/2026

-   Date last modified: \<???\>

-   This was run at the Pitzer cluster of the Ohio Supercomputer Center (<https://www.osc.edu>)

-   OSC working dir:

    ```         
    /fs/ess/PAS3493/people/abhijith12/GA5
    ```

-   GitHub repository: \<???\>

## Prerequisites

-   **Input files**:

    -   Paired-end RNA-seq reads are in `../garrigos/fastq`

-   **Software**:

    -   The scripts run programs using Apptainer containers, with links contained inside the scripts.
    -   If running at OSC, no software installations are needed.
    -   If you're not at OSC, you need to have Apptainer and Slurm installed.

-   Run all code from the working dir listed above. You don't need to create the output dirs, because the scripts will do so.

-   Each script writes a Slurm log file (`slurm-<script>-<jobID>.out`) to the working dir. After the jobs of a step have finished, check these logs for errors, then move them into a `logs/` dir within that step's output dir.

## Set up: Download the reference transcriptome FASTA file from NCBI

``` bash
# Downloaded on <???>
<???>
```

## Set up: Set file paths

``` bash
# Inputs:
fastq_dir=<???>
ref_transcripts=<???>

# Base output dir:
outdir=results
```

## Step 1: Read trimming with TrimGalore

\<???\>

## Step 2: Creating a transcriptome index with Salmon

\<???\>

## Step 3: Pseudo-alignment and quantification with Salmon

\<???\>

## Step 4: Summarizing the results of all steps with MultiQC

\<???\>