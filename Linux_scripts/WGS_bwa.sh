#!/bin/bash


module load bwa samtools

genome=/fdb/igenomes/Homo_sapiens/UCSC/hg38/Sequence/BWAIndex/genome.fa
read1=XXX_R1.fastq.gz
read2=XXX_R2.fastq.gz

bwa men -M -t 32 $genome $read1 $read2 | samtools sort -m 1706M -@ 12 -O BAM -o sorted.bamfile.bam
