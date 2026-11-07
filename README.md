```{=html}
<!--
GA5 README template.
- Add your answers to each question's section below.
- For each question where we want you to add your commands,
  put the command(s) you ran in the terminal in the corresponding ```bash code block.
- Where we want to see a command's output, there is a plain ``` code block
  right below the command block: paste the output there.
- The code to run each step of the workflow goes in `protocol.md`, not here:
  you don't need to repeat it in this file.
- You don't need to paste the contents of your scripts into this file:
  we will look at the scripts in your `scripts` dir directly
  (so make sure you commit them!).
- Delete instructional comments like this one as you go.
-->
```

# GA5 answers - Abhijith Anil

------------------------------------------------------------------------

## Part A: Your project dir, Git repo, and protocol

### 1: Fill in the top of the protocol

<!-- No answer needed here -- we check `protocol.md` directly. -->

### 2: Markdown formatting

<!-- No answer needed here -- we check the formatting of both Markdown files. -->

### 3: Create subdirs, and copy the scripts

``` bash
mkdir -p scripts data/ref results
```

### 4: Initialize a Git repository, and commit your first files

<!-- No answer needed here -- we check the repo directly. -->

### 5: Download the reference transcriptome

<!-- Put the download command in `protocol.md`, not here. -->

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

<!-- Put the code to run TrimGalore in `protocol.md`, not here. -->

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

<!-- No answer needed here -- we check `protocol.md` directly. -->

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

<!-- No need to paste the script: we'll look at scripts/multiqc.sh and its Git history directly. -->

### 13: Run MultiQC

*Answer*: For each program, the number of reports that MultiQC found, and why it found this number:

### 14: The General Statistics table

*Answer*: The sample with the lowest Salmon mapping rate, and whether this matches your answer to question 11:

### 15: Adapter lengths

*Answer*: The most common adapter lengths, whether this surprised you, and why you think these lengths are the most common:

### 16: Ask Claude about the MultiQC report

*Answer*: What you asked, and what you learned from Claude's answer (in your own words):

------------------------------------------------------------------------

## Part E: Improving the workflow with genAI

### 17: Claude's review of your protocol and scripts

*Answer*: At least three of Claude's suggestions, and whether you agree or disagree with each one, and why:

### 18: Address a suggestion

*Answer*: Which suggestion(s) you addressed, and what you changed:

------------------------------------------------------------------------

## Part F: Publish your repo on GitHub

### 19: Create a GitHub repository and push

<!-- No answer needed here -- we check your GitHub repo directly. -->

### 20: Get a (test) DOI with Zenodo

*Answer*: Your Zenodo Sandbox DOI: