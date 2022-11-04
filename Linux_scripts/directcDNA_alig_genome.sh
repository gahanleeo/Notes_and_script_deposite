#!/bin/bash


module load minimap2
module load samtools || exit 1



for i in *.fastq.gz
do
minimap2 -ax splice /data/leec20/nanopore_seq/Homo_sapiens.GRCh37.dna.primary_assembly.fa.gz $i | samtools view -Sb - > /data/leec20/nanopore_seq/hepG2/align_with_genome_bam/$i.us.aln_genome.bam
echo done $i !!!!!!!!!!!! 
done


echo all DONE!!

