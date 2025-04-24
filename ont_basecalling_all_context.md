# Modified Basecalling of ONT Data (5mC/5hmC all context)  
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

## Basecalling with 5mC / 5hmC modification in all contexts (super-high accuracy, minimum qscore = 10)
`dorado basecaller -r --modified-bases 5mC_5hmC --min-qscore 10 --reference [ref] [dorado_installation]/models/dna_r10.4.1_e8.2_400bps_sup@v4.3.0 [pod5] > [aligned.bam]`  
> **[ref]** - path to reference genome  
> **[dorado_installation]** - path to dorado installation  
> **[pod5]** - path to directory of pod5 files  
> **[aligned.bam]** - output bam file of reads aligned against reference genome  

## QC using NanoPlot
`dorado summary [aligned.bam] > [summary.txt]`  
> **[aligned.bam]** - output bam file of reads aligned against reference genome

`NanoPlot --summary [summary.txt] -t 16 --loglength -o [nanoplot_qc]`  
> **[summary.txt]** - summary file  
> **[nanoplot_qc]** - output folder containing QC analysis

## Processing of bam file
Sort and filter bam file to include only primary aligned reads and generate statistics  
**Script:** [process_bam.sh](scripts/process_bam.sh) 

`process_bam.sh [aligned.bam]`  
> **[aligned.bam]** - output bam file of reads aligned against reference genome
   
**Outputs:** 
> **[aligned_sorted_primary.bam]** - sorted bam file of primary reads aligned against reference genome  
> **[aligned_sorted_stats.txt]** - statistics of input bam file  
> **[aligned_sorted_primary_stats.txt]** - statistics of output bam file 
