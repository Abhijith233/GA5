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
wget -P data/ref https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/016/801/865/GCF_016801865.2_TS_CPP_V2/GCF_016801865.2_TS_CPP_V2_rna.fna.gz
```

## Set up: Set file paths

``` bash
# Inputs:
fastq_dir=../garrigos/fastq
ref_transcripts=data/ref/GCF_016801865.2_TS_CPP_V2_rna.fna.gz

# Base output dir:
outdir=results
```

## Step 1: Read trimming with TrimGalore

```         
# Create output directory
mkdir -p "$outdir"/trimgalore

# Run Trim Galore for each sample
for r1_fastq in "$fastq_dir"/S6*_R1.fastq.gz
do
    r2_fastq="${r1_fastq/_R1/_R2}"

    sbatch scripts/trimgalore.sh \
        "$r1_fastq" \
        "$r2_fastq" \
        "$outdir"/trimgalore
done
```

## Step 2: Creating a transcriptome index with Salmon

```         
# Create a Salmon index 
sbatch scripts/salmon_index.sh \    
"$ref_transcripts" \    
"$outdir"/salmon_index
```

## Step 3: Pseudo-alignment and quantification with Salmon

```         
# Define input and output directories 
fastq_dir=results/trimgalore 
index_dir=results/salmon_index 
outdir=results/salmon_quant  

# Create the output directory 
mkdir -p "$outdir"  

# Run Salmon quantification for each sample 
for r1_fastq in "$fastq_dir"/S6*_R1.fastq.gz 
do     
r2_fastq="${r1_fastq/_R1/_R2}"      
sbatch scripts/salmon_quant.sh \        
"$r1_fastq" \         
"$r2_fastq" \         
"$index_dir" \       
"$outdir" done

# Display the header and the top three transcripts by NumReads
(head -n 1 results/salmon_quant/S63/quant.sf
tail -n +2 results/salmon_quant/S63/quant.sf | sort -k5,5nr | head -n 3)

# Identify the gene corresponding to the top transcript
zgrep -F "XM_039591534.2" data/ref/GCF_016801865.2_TS_CPP_V2_rna.fna.gz

# Getting the mapping rates from Salmon quantification log files
grep "mapping rate" results/salmon_quant/*/logs/salmon_quant.log
```

## Step 4: Summarizing the results of all steps with MultiQC

```         
# Run MultiQC on the entire results directory 
indir=results 
outdir=results/multiqc  
sbatch scripts/multiqc.sh "$indir" "$outdir"
```