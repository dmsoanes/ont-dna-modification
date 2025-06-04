# Processing of RNA-seq data  
## Software used
fastp (v0.23.1): https://github.com/OpenGene/fastp  
STAR (v2.7.10b): https://github.com/alexdobin/STAR  
TPMCalculator (v0.0.3): https://github.com/ncbi/TPMCalculator  

## Processing of raw sequencing reads
`fastp --detect_adapter_for_pe --cut_tail --cut_tail_mean_quality=22 --length_required=75 --trim_front1=0 --thread=8 --in1=raw_read1.fastq.gz --in2=raw_read2.fastq.gz --out1=trimmed_read1.fastq.gz --out2=trimmed_read2.fastq.gz`

