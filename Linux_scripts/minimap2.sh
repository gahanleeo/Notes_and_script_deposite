#!/bin/bash


module load samtools || exit 1
module load minimap2


for i in *.fastq
do
minimap2 -ax splice --junc-bed /data/leec20/nanopore_seq/hg19_refgene.bed /data/leec20/nanopore_seq/hg19.fa $i | samtools sort -o $i.sorted.bam
echo done $i !!!!!!!!!!!!!!!
done


echo all DONE!!
