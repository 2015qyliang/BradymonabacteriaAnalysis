## Step_1

### Download and install [vsearch](https://github.com/torognes/vsearch)

The version in this study was v2.8.4

## Step_2

### Prepare database for vsearch pipeline

- 16S rRNA taxonomy database -- SILVA_132_NR99

```
# bash
vsearch --makeudb_usearch SILVA_132_NR99.fasta --output vsearchsilva.udb
```

## Step_3

### Prepare FASTQ files

```
# bash
mkdir 0.fqfile 1.filtedfile 2.nonchimerfile 3.uniquesfile 4.otusfile 5.otutabfile 6.taxfile
```

'0.fqfile' folder were used to store FASTQ***.fastq files.

Using [pear](https://www.h-its.org/downloads/pear-academic/) ([download link](https://github.com/Grelot/bioinfo_singularity_recipes/raw/master/packages/pear-0.9.11-linux-x86_64.tar.gz)) to merge PE fastq files...  

[Tara Ocean releated link](http://ocean-microbiome.embl.de/data/) (download 16SrRNA.miTAGs.tgz, and unzip)

## Step_3

```
# bash
pyhton 01.VsearchFlow.py 3-6 HighThroughtAnalysis
sh 02.summaryRarefaction.sh
sh 03.summaryOTUsTax.sh
python 05.SummaryOrderRelativeAbundanceRound5.py
sh 07.freshFormatTaxOtutab.sh
python 08.getOrderRelativeAbundance.py
Rscript 09.summaryAlphaDiversity.R
Rscript 11.summaryBetaDiversity.R
```

