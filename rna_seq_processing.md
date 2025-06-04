# Processing of RNA-seq data  
## Software used
fastp (v0.23.1): https://github.com/OpenGene/fastp  
STAR (v2.7.10b): https://github.com/alexdobin/STAR  
TPMCalculator (v0.0.3): https://github.com/ncbi/TPMCalculator  

## Processing of raw sequencing reads (150 base paired-end)  
Adapter and poor-quality sequences (mean_quality < 22) were trimmed from raw reads. Reads of less than 75 bases in length after trimming were discarded.  
`fastp --detect_adapter_for_pe --cut_tail --cut_tail_mean_quality=22 --length_required=75 --trim_front1=0 --thread=16 --in1=raw_read1.fastq.gz --in2=raw_read2.fastq.gz --out1=trimmed_read1.fastq.gz --out2=trimmed_read2.fastq.gz`  

# Alignment to reference genome  
Create STAR index from reference genome  
`STAR --runThreadN 16 --runMode genomeGenerate --genomeDir [STAR_index] --genomeFastaFiles [ref.fa] --sjdbGTFfile [ref.gtf] --sjdbOverhang 150`  
> **[ref.fa]** - reference genome (fasta file of genome assembly)  
> **[ref.gtf]** - reference genome annotation(gtf file)  
> **[STAR_index]** - folder where STAR index will be created  

STAR --runThreadN 16 --genomeDir /lustre/home/dmsoanes/references/gencode_v44/STAR_index_150 --readFilesIn ${stem}R1_001_fastp.fastq.gz ${stem}R2_001_fastp.fastq.gz --readFilesCommand zcat --outFileNamePrefix ../STAR_alignment/${stem} --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts
