# Phasing of ONT reads and visualisation of imprinting  
## Software used  
Clair3 (v1.0.3): https://github.com/HKU-BAL/Clair3    
Samtools (v1.13): https://www.htslib.org/    
methylartist (v1.3.1): https://github.com/adamewing/methylartist  
## Phasing of ONT reads
`run_clair3.sh --bam_fn=P20001_NeuN_5mCG_5hmCG_sup_10_aligned_sorted_primary.bam --ref_fn="/lustre/home/dmsoanes/references/gencode_v44/GRCh38.primary_assembly.genome.fa" --threads=16 --platform="ont" --model_path="/lustre/home/dmsoanes/mambaforge/envs/clair3/bin/models/r1041_e82_400bps_sup_v420" --output="clair3_NeuN_S1" --min_coverage=10 --use_whatshap_for_final_output_haplotagging --use_whatshap_for_final_output_phasing --enable_phasing`
