# Snakemake pipeline for MNase-seq data


@author Jianyu Yang, Pennsylvania State University

# Dependency

- miniconda
- snakemake(>=5.1.2)

# Quick Start

- Put the gzipped fastq data into the data folder
- Modify the samples.tsv and units.tsv file corresponding to the data
- excute the following command in the root directory of the project, you'll see an output folder with all generated files!
    ```
    snakemake --use-conda --cores
    ```

# Introduction

This pipeline aims for standard MNase-seq fastq files handling, which consists of 
- Standard Procedure:
    - reads trimming
    - bowtie2 mapping
    - mark duplicates
    - reads filtering by samtools and python script
- QC:
    - multiqc report
    - fragment size frequency report

Written in [Snakemake](https://snakemake.readthedocs.io/en/stable/index.html), which is a very powerful workflow management system

