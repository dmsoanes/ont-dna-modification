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

`samtools index -@ 16 [phased_output_convert.bam]`  

>**[phased_output.bam]** - sorted bam file of primary reads aligned against reference genome tagged with phase information
>**[phased_output_convert.bam]** - output file in which h has been converted to m  

## Create compressed, index GTF file
Download GTF file showing genes from genome assembly used in alignment  
Create compressed, indexed GTP file using bgzip and tabix which are part of Samtools package

`(grep "^#" [genome_assembly.annotation.gtf]; grep -v "^#" [genome_assembly.annotation.gtf] | sort -t"`printf '\t'`" -k1,1 -k4,4n) | bgzip > [genome_assembly.annotation.gtf.gz]`  

`tabix -p gff [genome_assembly.annotation.gtf.gz]`  
>**[genome_assembly.annotation.gtf]** - gtf file containing genome annotation  
>**[genome_assembly.annotation.gtf.gz]** - bgzip compressed gtf file
## Visualisation of imprinted region
Example code for creating plot using methylartist showing levels of modification in each phase.  
More details at https://github.com/adamewing/methylartist

`methylartist region -b [phased_output_convert.bam] -g [genome_assembly.annotation.gtf.gz] --labelgenes --phased --ref [ref.fa] --motif CG -i chr20:31514428-31577923 -l 31547027-31548129`
>**[genome_assembly.annotation.gtf.gz]** - bgzip compressed gtf file  
>**[phased_output_convert.bam]** - sorted bam file of primary reads aligned against reference genome tagged with phase information (5mC and 5hmC merged)  
>**[ref.fa]** - reference genome (fasta file of genome assembly)  
>**-i chr20:31514428-31577923** - chromosomal region covered in plot 
>**-l 31547027-31548129** - highlighted region (optional)
