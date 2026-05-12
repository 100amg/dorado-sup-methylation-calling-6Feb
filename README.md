# Dorado SUP Methylation Calling Pipeline

Pipeline for Oxford Nanopore SUP (Super Accuracy) basecalling, move table generation, and direct methylation calling using Dorado modified-base models.

---

# Overview

This workflow processes Oxford Nanopore `.pod5` raw signal files using the Dorado SUP basecalling model with native modified-base calling enabled.

The workflow performs:

* SUP basecalling
* Direct methylation calling
* Reference-guided alignment
* Move table generation
* BAM sorting and indexing

The generated BAM outputs contain:

* aligned reads
* move tables
* MM methylation tags
* ML methylation probability tags
* 5mC calls
* 5hmC calls

The workflow corresponds specifically to:

| Step | Script                          | Purpose                                      |
| ---- | ------------------------------- | -------------------------------------------- |
| 1    | `run_dorado_sup_methylation.sh` | SUP basecalling + direct methylation calling |

`run_dorado_sup_methylation.sh` performs SUP basecalling, direct methylation calling, reference alignment, move-table generation, BAM sorting, and BAM indexing using Dorado native modified-base calling.

---

# Repository Structure

```text id="jlwmt5"
dorado-sup-methylation-pipeline/
│
├── README.md
│
├── run_dorado_sup_methylation.sh
│
├── reference.fasta
│
├── reference.fasta.fai
│
└── .gitignore
```

---

# Required Input Files

The workflow requires:

* `.pod5` files
* Reference FASTA
* FASTA index (`.fai`)

Example:

```text id="3kuxmi"
project/
├── pod5_files/
│   ├── sample1.pod5
│   └── sample2.pod5
├── reference.fasta
├── reference.fasta.fai
```

---

# Dorado SUP Models Used

## SUP Basecalling Model

```text id="xklj5i"
dna_r10.4.1_e8.2_400bps_sup@v5.0.0
```

---

## Modified-Base Model

```text id="7jlwm0"
dna_r10.4.1_e8.2_400bps_sup@v5.0.0_5mCG_5hmCG@v3
```

---

# Workflow

## Step 1 — SUP Basecalling and Direct Methylation Calling

Edit the following variables inside:

```text id="jlwm8y"
run_dorado_sup_methylation.sh
```

Set:

```bash id="jlwmzs"
POD5_DIR=
OUTPUT_DIR=
REFERENCE=
BASE_MODEL=
METHYL_MODEL=
```

Run:

```bash id="jlwm83"
chmod +x scripts/run_dorado_sup_methylation.sh

bash scripts/run_dorado_sup_methylation.sh
```

Expected outputs:

```text id="jlwmj0"
sample_sup_methylation.sorted.bam
sample_sup_methylation.sorted.bam.bai
```

---

# Verifying Methylation Tags

Inspect BAM contents:

```bash id="jlwmk4"
samtools view sample_Dorado.sorted.bam | head
```

Successful methylation calling produces tags such as:

```text id="jlwmh7"
MM:Z:
ML:B:C
```

These tags confirm successful modified-base calling.

---

# Verifying Outputs

List generated BAM files:

```bash id="jlwm93"
ls -lh OUTPUT_DIRECTORY/
```

Check BAM statistics:

```bash id="jlwmq8"
samtools flagstat sample_Dorado.sorted.bam
```

Count aligned reads:

```bash id="jlwm8v"
samtools view -c sample_Dorado.sorted.bam
```

---

# Full Documentation

Detailed workflow documentation is available here:

[Google Docs Documentation](PASTE_GOOGLE_DOC_LINK_HERE)
