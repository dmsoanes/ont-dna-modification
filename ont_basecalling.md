# Basecalling ONT sequence data using Dorado
### Software used
Dorado (v0.6.0): https://github.com/nanoporetech/dorado  
POD5 format (including tools): https://github.com/nanoporetech/pod5-file-format  
Modkit (v0.2.4): https://github.com/nanoporetech/modkit  
Samtools (v1.13): https://www.htslib.org/

### Conversion of fast5 to pod5 file format (if needed)
`pod5 convert fast5 ./<fast5>/*.fast5 --output <pod5>/ --one-to-one ./<fast5>/`  
**\<fast5\>** - directory containing fast5 files  
**\<pod5\>** - directory where pod5 files will be created

### Basecalling with 5mC / 5hmC modification in CpG context (super-high accuracy, minimum qscore = 10)
dorado basecaller -r --modified-bases 5mCG_5hmCG --min-qscore 10 --reference ~/Documents/references/human/GRCh38/GRCh38.primary_assembly.genome.fa ~/installs/dorado-0.6.0-linux-x64/models/dna_r10.4.1_e8.2_400bps_sup@v4.3.0 pod5_test > dorado_benchmarking/P20001_NeuN_5mCG_5hmCG_sup_10_aligned_test_dorado_0.6.0.bam
