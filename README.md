# VEP
Coding to use Variant Effect Predictor (VEP) on command line with Splicing predictors such as dbscSNV, MaxEntScan, SpliceAI. And also annotating 5' UTR variants with 5' UTR annotator. 

# Background
The Ensembl Variant Effect Predictor is a powerful toolset for the analysis, annotation, and prioritization of genomic variants in coding and non-coding regions:
- McLaren W, Gil L, Hunt SE, Riat HS, Ritchie GR, Thormann A, Flicek P, Cunningham F. The Ensembl Variant Effect Predictor. Genome Biology Jun 6;17(1):122. (2016) doi:10.1186/s13059-016-0974-4

# Requirements
Conda or Mamba installed (64-bit for lixux)

- $ wget -c https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh
- $ sha256sum (filename)
- $ bash (filename)

# Installation
Via Conda or Mamba:
  
- $ conda install -c bioconda -c conda-forge ensembl-vep
- $ mamba install -c bioconda -c conda-forge ensembl-vep (faster way)
  
Download your Human Genome Reference sequence:
- GRCh37/hg19 (release 106): 
  $ wget -c http://ftp.ensembl.org/pub/grch37/release-106/variation/vep/homo_sapiens_vep_106_GRCh37.tar.gz 
  $ tar -xzf homo_sapiens_vep_106_GRCh37.tar.gz

Download the Fasta sequence of Human Genome:
$ wget -c http://ftp.ensembl.org/pub/grch37/current/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.dna.primary_assembly.fa.gz /
$ gzip -d Homo_sapiens.GRCh37.dna.primary_assembly.fa.gz /
$ bgzip Homo_sapiens.GRCh37.dna.primary_assembly.fa 


# Usage
## Basic Usage
