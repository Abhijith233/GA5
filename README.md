```         
[![DOI](https://sandbox.zenodo.org/badge/1384068864.svg)](https://handle.test.datacite.org/10.5072/zenodo.637475)
```

# GA5 answers - Abhijith Anil

------------------------------------------------------------------------

## Part A: Your project dir, Git repo, and protocol

### 1: Fill in the top of the protocol

### 2: Markdown formatting

### 3: Create subdirs, and copy the scripts

``` bash
mkdir -p scripts data/ref results
```

### 4: Initialize a Git repository, and commit your first files

### 5: Download the reference transcriptome

Code to count the number of transcripts:

``` bash
zcat data/ref/GCF_016801865.2_TS_CPP_V2_rna.fna.gz | grep -c "^>"
```

The output of the command was:

```         
28624
```

*Answer*: The number of transcripts in the file: 28624

------------------------------------------------------------------------

## Part B: Read trimming

### 6: Run TrimGalore

*Answer*: Whether all batch jobs succeeded, and how you checked that (and any problems you encountered, and how you solved them): All seven batches were completed successfully. The status of job was checked using squeue -u \$USER -l command. Inorder to see all the files have 'successfully finished' message, tail command was utilized (tail slurm-trimgalore-\*.out). Also fastq files ,and trimming reports were formed in output directory.

------------------------------------------------------------------------

## Part C: Transcript quantification with Salmon

### 7: Create the Salmon index

Code to check the size of the index dir:

``` bash
du -sh results/salmon_index/
```

The output of the command was:

```         
1.1G    results/salmon_index/
```

*Answer*: How long it took to create the index, and how you found out: It took approximately 8du -sh results/salmon_index/ minutes to create the index. I found it out using the tail command where it states starting time as 06:28:57 and finished time at the end as 06:36:45.

*Answer*: The size of the index dir: 1.1 GB

### 8: Run Salmon for all samples

### 9: The transcripts with the most reads

*Answer*: What the `NumReads` column contains: NumReads coloumn contains the number of reads.

``` bash
(head -n 1 results/salmon_quant/S63/quant.sf
tail -n +2 results/salmon_quant/S63/quant.sf | sort -k5,5nr | head -n 3)
```

The output of the command was:

```         
Name    Length  EffectiveLength TPM     NumReads
XM_039591534.2  6566    6315.086        14518.656821    24004.889
XM_039573735.1  6445    6194.086        5342.073324     8663.254
XM_039573733.1  6591    6340.086        2876.480244     4774.749
```

### 10: The gene of the top transcript

``` bash
zgrep -F "XM_039591534.2" data/ref/GCF_016801865.2_TS_CPP_V2_rna.fna.gz
```

The output of the command was:

```         
>XM_039591534.2 PREDICTED: Culex pipiens pallens vitellogenin-A1-like (LOC120426760), mRNA
```

*Answer*: The gene that the top transcript belongs to: It belongs to gene vitellogenin-A1-like (LOC120426760) in Culex.

### 11: Mapping rates

``` bash
grep "mapping rate" results/salmon_quant/*/logs/salmon_quant.log
```

The output of the command was:

```         
results/salmon_quant/S63/logs/salmon_quant.log:mapping rate: 82.4560%
results/salmon_quant/S64/logs/salmon_quant.log:mapping rate: 81.9152%
results/salmon_quant/S65/logs/salmon_quant.log:mapping rate: 79.1055%
results/salmon_quant/S66/logs/salmon_quant.log:mapping rate: 81.9350%
results/salmon_quant/S67/logs/salmon_quant.log:mapping rate: 83.0459%
results/salmon_quant/S68/logs/salmon_quant.log:mapping rate: 78.8070%
results/salmon_quant/S69/logs/salmon_quant.log:mapping rate: 82.1824%
```

*Answer*: The sample with the lowest mapping rate: S68

------------------------------------------------------------------------

## Part D: Summarizing all steps with MultiQC

### 12: Update your MultiQC script

### 13: Run MultiQC

*Answer*: For each program, the number of reports that MultiQC found, and why it found this number: Multiqc found reports from Salmon, Trimgalore and Fastqc. It found 7 salmon metareports, 7 fragment length distribution and 7 library format counts as salmon formed one report of each type for seven samples. It found 14 trim galore reports and 14 fastqc reports as the samples are paired ending having R1 and R2 so 14 reports.

### 14: The General Statistics table

*Answer*: The sample with the lowest Salmon mapping rate, and whether this matches your answer to question 11: Sample 68 has the lowest mapping rate. Yes this matches the answer to question 11 where the same result was seen.

### 15: Adapter lengths

*Answer*: The most common adapter lengths, whether this surprised you, and why you think these lengths are the most common: The most common adapter length distribution is shown at 1 bp. It was surprising to see that these larger number of reads had only 1 bp adapter match. Then it was understood that Trim Galore has a default stringency of 1 bp accepting even single bases overlaps. Some of these could also be random sequence matches rather than adapter contamination.

### 16: Ask Claude about the MultiQC report

*Answer*: What you asked, and what you learned from Claude's answer (in your own words): I asked Salmon Why is salmon mapping rate differs from sample to sample? And it answered it depends on the RNA quality, library prep efficiency, adapter trimming leftovers, sequencing depth/error rate differences, and biological variation. Then I asked what is the generally acceptable mapping rate percentage? It said 80-85%+ is good/excellent, 70-80% acceptable and \<60-70%: investigate (contamination, wrong reference/species, poor library). Then I asked what factors could explain why one sample has a lower mapping rate than the others? It gave answer as Sample/library quality, contamination, Technical/sequencing and Biological.

------------------------------------------------------------------------

## Part E: Improving the workflow with genAI

### 17: Claude's review of your protocol and scripts

*Answer*: At least three of Claude's suggestions, and whether you agree or disagree with each one, and why: 1. Correct the formatting of Salmon quantification commands: I agree with this suggestion that because the step 3 had formatting issues which could make it difficult to copy. 2. Include instructions for checking job completion: I agree to this instruction because the protocol should explain to users to confirm the previous job has completed before starting next workflow. 3. Explain the sample selection pattern: I agree because the S6\*\_R1.fastq.gz selects the 7 samples from larger data set. Keeping this selection makes it clearer which samples are selected.

### 18: Address a suggestion

*Answer*: Which suggestion(s) you addressed, and what you changed: With the help of claude rewrote the the for/sbatch loop with correct line breaks so its copy pasteable, split quant.sf/zgrep commands in separate blocks. Added wait until jobs finish, check logs after step 1, 2 and 3 and before step 4. Fixed usage comment and added missing (`SBATCH --cpus-per-task=4` / `--time=20)` directives in multiqc.sh.

------------------------------------------------------------------------

## Part F: Publish your repo on GitHub

### 19: Create a GitHub repository and push

### 20: Get a (test) DOI with Zenodo

*Answer*: Your Zenodo Sandbox DOI:

```         
[![DOI](https://sandbox.zenodo.org/badge/1384068864.svg)](https://handle.test.datacite.org/10.5072/zenodo.637475)
```