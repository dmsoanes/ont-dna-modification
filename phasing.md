# Phasing of ONT reads and visualisation of imprinting  
## Software used  
Clair3 (v1.0.3): https://github.com/HKU-BAL/Clair3  
Modkit (v0.2.4): https://github.com/nanoporetech/modkit  
Samtools (v1.13): https://www.htslib.org/    
methylartist (v1.3.1): https://github.com/adamewing/methylartist  
## Phasing of ONT reads
`run_clair3.sh --bam_fn=[aligned_sorted_primary.bam] --ref_fn="[ref.fa]" --threads=16 --platform="ont" --model_path="[clair3_installation]/bin/models/r1041_e82_400bps_sup_v420" --output="[clair3_aligned_sorted_primary]" --min_coverage=10 --use_whatshap_for_final_output_haplotagging --use_whatshap_for_final_output_phasing --enable_phasing`
>**[aligned_sorted_primary.bam]** - sorted bam file of primary reads aligned against reference genome  
>**[ref.fa]** - reference genome (fasta file of genome assembly)  
>**[clair3_installation]** - path to clair3 installation  
>**[clair3_aligned_sorted_primary]** - existing directory for output of data

**Outputs:** 
>**[phased_output.bam]** - sorted bam file of primary reads aligned against reference genome tagged with phase information  
## Merging of 5mC/5hmC (optional)
Use modkit adjust-mods to convert h (5hmC) to m (5mC), simplifies methylartist plots

`modkit adjust-mods [phased_output.bam] [phased_output_convert.bam] --convert h m -t 16`  
>**[phased_output.bam]** - sorted bam file of primary reads aligned against reference genome tagged with phase information
>**[phased_output_convert.bam]** - output file in which h has been converted to m  

## Visualisation of imprinted region
Create compressed, index GTF file
