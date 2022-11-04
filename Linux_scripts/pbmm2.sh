#!/bin/bash

module load samtools

source /data/$USER/conda/etc/profile.d/conda.sh

conda activate PacBio

# command line

hg38=/fdb/igenomes/Homo_sapiens/UCSC/hg38/Sequence/WholeGenomeFasta/genome.fa
for i in *.fastq.gz
do
file=`echo $i | sed 's/.fastq.gz//'`
pbmm2 align $hg38 ${i} ${file}.sorted.bam -j 24 -m 10G --sort --preset CCS --rg '@RG\tID:myid\tSM:mysample' --log-level DEBUG

echo "done done"

done


