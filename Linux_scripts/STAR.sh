#!/bin/bash

module load samtools || fail "could not load samtools module"
module load STAR         || fail "could not load STAR module"

## remember to check the length of fastq seq
GENOME=/fdb/STAR_current/UCSC/hg38/genes-100

for i in {704..789}

do
STAR --runThreadN $SLURM_CPUS_PER_TASK\
 --genomeDir $GENOME\
 --readFilesIn "SRR15042$i"_1.fastq.gz "SRR15042$i"_2.fastq.gz\
 --readFilesCommand zcat --outSAMtype BAM SortedByCoordinate\
 --outTmpDir=/lscratch/$SLURM_JOB_ID/STARtmp\
 --outFileNamePrefix /data/leec20/RNA_seq_analysis_done/GSE179448_covidpat_CD4_fastq/result/"SRR$i"

echo "done $i STAR"
done

echo OH YEAH!
