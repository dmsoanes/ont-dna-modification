# Modified Duplex Basecalling of ONT Data (5mC/5hmC at CpG sites)  
## Software used
Dorado (v0.6.0): https://github.com/nanoporetech/dorado  
POD5 format (including tools): https://github.com/nanoporetech/pod5-file-format  
Modkit (v0.2.4): https://github.com/nanoporetech/modkit  
Samtools (v1.13): https://www.htslib.org/  
NanoPlot (v1.41.6) :https://github.com/wdecoster/NanoPlot

## Conversion of fast5 to pod5 file format (if needed)
`pod5 convert fast5 ./[fast5]/*.fast5 --output [pod5]/ --one-to-one ./[fast5]/`  
> **[fast5]** - directory containing fast5 files  
> **[pod5]** - directory where pod5 files will be created

## Duplex basecalling with 5mC / 5hmC modification in CpG context (super-high accuracy, minimum qscore = 10)
`dorado duplex -r --modified-bases 5mCG_5hmCG --min-qscore 10 --reference [ref.fa] [dorado_installation]/models/dna_r10.4.1_e8.2_400bps_sup@v4.3.0 [pod5] > [aligned.bam]`  
> **[ref.fa]** - reference genome (fasta file of genome assembly)  
> **[dorado_installation]** - path to dorado installation  
> **[pod5]** - path to directory of pod5 files  
> **[aligned.bam]** - output bam file of reads aligned against reference genome  

## QC using NanoPlot
`dorado summary [aligned.bam] > [summary.txt]`  
> **[aligned.bam]** - output bam file of reads aligned against reference genome  
> **[summary.txt]** - summary file  

`NanoPlot --summary [summary.txt] -t 16 --loglength -o [nanoplot_qc]`  
> **[summary.txt]** - summary file  
> **[nanoplot_qc]** - output folder containing QC analysis

## Processing of bam file
Sort and filter bam file to include only primary aligned reads and generate statistics  
**Script:** [process_bam.sh](scripts/process_bam.sh) 

`process_bam.sh [aligned.bam]`  
> **[aligned.bam]** - bam file of reads aligned against reference genome
   
**Outputs:** 
> **[aligned_sorted_primary.bam]** - sorted bam file of primary reads aligned against reference genome  
> **[aligned_sorted_stats.txt]** - statistics of original bam file  
> **[aligned_sorted_primary_stats.txt]** - statistics of output bam file of primary reads  

## Aggregating methylation data (creating hemi-methylation bedMethyl table)
`modkit pileup-hemi [aligned_sorted_primary.bam] [aligned_sorted_primary.bed] --log-filepath [aligned_sorted_primary.log] --ref [ref.fa] --cpg -t 16 --filter-threshold C:0.75`
> **[aligned_sorted_primary.bam]** - sorted bam file of primary reads aligned against reference genome  
> **[aligned_sorted_primary.bed]** - output bedMethyl file showing counts of modified / unmodified bases at each CpG site 
> **[aligned_sorted_primary.log]** - logfile  
> **[ref.fa]** - reference genome (fasta file of genome assembly)

### Extracting % modifications into tab-delimited files for downstream analyses  

**Script:** [parse_bedmethyl_5mC_5hmC_duplex.pl](scripts/parse_bedmethyl_5mC_5hmC_duplex.pl)  

`perl parse_bedmethyl_5mC_5hmC_duplex.pl [aligned_sorted_primary.bed]`  
> **[aligned_sorted_primary.bed]** - hemi-methylation bedMethyl table
