#!/usr/bin/bash

#script to take bam file and sort it, filter it to only include primary alignments and output flagstat stats

#usage process_bam.sh <bam file>

bam_file=$1

stem=$(basename $bam_file .bam)

echo "Processing bam file $1"

#sort bam file
echo "Sorting bam file"
samtools sort -o ${stem}_sorted.bam -@ 16 $bam_file

#index sorted bam file
echo "Indexing bam file"
samtools index -@ 16 ${stem}_sorted.bam

#Generating stats from bam file
echo "Generating stats from bam file"
samtools stats -@ 16 ${stem}_sorted.bam |grep ^SN | cut -f 2- > ${stem}_sorted_stats.txt

#Filter bam file to only include primary alignments
echo "Filtering bam file to only include primary alignments"
samtools view -bF 2308 -@ 16 ${stem}_sorted.bam > ${stem}_sorted_primary.bam

#index sorted bam file
echo "Indexing bam file"
samtools index -@ 16 ${stem}_sorted_primary.bam

#Generating stats from bam file
echo "Generating stats from bam file"
samtools stats -@ 16 ${stem}_sorted_primary.bam |grep ^SN | cut -f 2- > ${stem}_sorted_primary_stats.txt
