#!/bin/bash

module load samtools/1.6 || fail "could not load samtools module"
module load STAR         || fail "could not load STAR module"

GENOME=/fdb/STAR_current/UCSC/hg38/genes-100


for i in {63,64,67}
do
STAR --runThreadN $SLURM_CPUS_PER_TASK\
 --genomeDir $GENOME\
 --readFilesIn "SRR108285$i".fastq.gz\
 --readFilesCommand zcat --outSAMtype BAM SortedByCoordinate --sjdbOverhang 100\
 --limitBAMsortRAM 56416411870\
 --outTmpDir=/lscratch/$SLURM_JOB_ID/STARtmp\
 --outFileNamePrefix /data/leec20/PRJNA598976/"$i"_single_RNAseq

echo single ok$i
done

echo done single! 

