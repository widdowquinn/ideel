# `ideel`

> Indels are not ideal - quick test for interrupted ORFs in bacterial/microbial genomes.

- Original author: [Mick Watson](https://github.com/mw55309)
- Original blog post: ["Stop Publishing Bad Genomes", Mick Watson (2018)](http://www.opiniomics.org/on-stuck-records-and-indel-errors-or-stop-publishing-bad-genomes/)
- Original repository: [mw55309/ideel](https://github.com/mw55309/ideel)

`ideel` is a `snakemake` workflow that processes a set of genomes (the *input*) and predicts coding sequences (CDS) with the `prodigal` gene-calling software. 

The conceptual translations for these sequences are compared to (by default) the complete `SWISSPROT` database using the `diamond` sequence search tool. If you do not have a copy of this, it will be downloaded and prepared for you. 

The length of each query protein is compared to its best `SWISSPROT` hit, and a `query length`/`hit length` ratio calculated. 

Two histograms are produced, showing the distribution of this ratio for all predicted conceptual translations.

The tool is useful to help diagnose genome assemblies where there are a significant proportion of truncated coding sequences, having a premature stop codon. This can be a feature of long-read-only assemblies. Candidates are shown in the histogram as the proteins with `query length`/`hit length` ratio <≈ 0.9.

----------------------------------
## Dependencies

- Snakemake
- Prodigal
- Diamond
- R
## How to use this tool

### 0. (Optionally) create a `conda` environment

Creating a `conda` environment is a quick and effective way to manage software and dependency installation. To create a new environment with all the dependencies for `ideel`, you could use the commands:

```bash
conda create --name ideel python=3.8 -y
conda activate ideel
conda install snakemake prodigal diamond r -y
```


###  1. Clone this repository

You can use `git` to clone the repository:

```bash
git clone git@github.com:widdowquinn/ideel.git
```

Alternatively, you can download the repository as a `.zip` file and extract it to your local hard drive:

```bash
wget https://github.com/widdowquinn/ideel/archive/refs/heads/master.zip
unzip master.zip
```

### 2. Change directory to the repository root

Then, at the command-line/terminal, issue:

```bash
cd ideel
```

### 3. Run `ideel`


By default `ideel` expects your input genomes to be in the directory `genomes` under the repository root. Create that directory, and place your genomes in it. Then issue the following command to run `snakemake` at the command-line:

```
snakemake -jN
```

where `N` is the number of threads you would like `ideel` to use.

The output files (histograms of the counts of genomes that match the sequence database with the indicated query length/hit length ratio) are placed by default in the directory `figures`.