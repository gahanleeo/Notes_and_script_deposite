#!/bin/bash


module load samtools || exit 1
module load ngmlr


for i in *.fastq
do
ngmlr -t $SLURM_CPUS_PER_TASK -r /data/leec20/nanopore_seq/HG38.fa -q $i -x ont |samtools sort -o bams/$i.sorted.bam
echo done $i !!!!!!!!!!!!!!!
done


echo all DONE!!
