#!/bin/bash

#hisat2 -p $SLURM_CPUS_PER_TASK -x $HISAT_INDEXES/grch38/genome -q /data/leec20/rnaseq_test/SRR32_out.fastq \
#-S /data/leec20/output1.sam

#hisat2 -p $SLURM_CPUS_PER_TASK -x $HISAT_INDEXES/grch38/genome -q /data/leec20/rnaseq_test/SRR33_out.fastq -S /data/leec20/output2.sam

module load bowtie/2 || exit 1
module load samtools || exit 1


for i in {32,34}
do

bowtie2 --phred33 -x /fdb/igenomes/Homo_sapiens/UCSC/hg19/Sequence/Bowtie2Index/genome --threads=$(( SLURM_CPUS_PER_TASK - 4 ))\
 --no-unal --end-to-end --very-sensitive\
 -1 "SRR114789$i"_1.fastq.gz -2 "SRR114789$i"_2.fastq.gz\
 | samtools view -q30 -Sb - > "$i"_unsort_hg19.bam

echo done $i !!! 
done


for i in {33,35}
do

bowtie2 --phred33 -x /fdb/igenomes/Homo_sapiens/UCSC/hg19/Sequence/Bowtie2Index/genome --threads=$(( SLURM_CPUS_PER_TASK - 4 ))\
 --no-unal --end-to-end --very-sensitive\
 -U "SRR114789$i".fastq.gz\
 | samtools view -q30 -Sb - > "$i"_unsort_hg19.bam

echo done $i !!!
done

for i in {36..39}
do
bowtie2 --phred33 -x /fdb/igenomes/Homo_sapiens/UCSC/hg19/Sequence/Bowtie2Index/genome --threads=$(( SLURM_CPUS_PER_TASK - 4 ))\
 --no-unal --end-to-end --very-sensitive\
 -1 "SRR114789$i"_1.fastq.gz -2 "SRR114789$i"_2.fastq.gz\
 | samtools view -q30 -Sb - > "$i"_unsort_hg19.bam
done

echo all bowtie2 done!!!

