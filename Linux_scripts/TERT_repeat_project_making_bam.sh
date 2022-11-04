#!bin/bash

module load samtools

for i in *.txt
do
  ff=`echo $i | sed 's/.txt//'`
  echo $ff
  samtools view ../../pacbio_bam_files_hg38/${ff}_pacbio.sorted.bam | grep -f ${i} > ../../sg_b/${ff}.r4.sam
  samtools view -H ../../pacbio_bam_files_hg38/${ff}_pacbio.sorted.bam > ../../sg_b/${ff}.header.txt
  cat ../../sg_b/${ff}.header.txt ../../sg_b/${ff}.r4.sam  | samtools view -S -b - > ../../sg_b/${ff}.r4.bam
  rm ../../sg_b/${ff}.header.txt ../../sg_b/${ff}.r4.sam
  echo "done! ${i}"
done


for i in *_1.txt
do
  ff=`echo $i | sed 's/_1.txt//'`
  echo $ff
  samtools view ../../pacbio_bam_files_hg38/${ff}_pacbio.sorted.bam | grep -f ${i} > ../../sg_b/${ff}.r4.sam
  samtools view -H ../../pacbio_bam_files_hg38/${ff}_pacbio.sorted.bam > ../../sg_b/${ff}.header.txt
  cat ../../sg_b/${ff}.header.txt ../../sg_b/${ff}.r4.sam  | samtools view -S -b - > ../../sg_b/${ff}.r4_1.bam
  rm ../../sg_b/${ff}.header.txt ../../sg_b/${ff}.r4.sam
  echo "done! ${i}"
done


for i in *_2.txt
do
  ff=`echo $i | sed 's/_2.txt//'`
  echo $ff
  samtools view ../../pacbio_bam_files_hg38/${ff}_pacbio.sorted.bam | grep -f ${i} > ../../sg_b/${ff}.r4.sam
  samtools view -H ../../pacbio_bam_files_hg38/${ff}_pacbio.sorted.bam > ../../sg_b/${ff}.header.txt
  cat ../../sg_b/${ff}.header.txt ../../sg_b/${ff}.r4.sam  | samtools view -S -b - > ../../sg_b/${ff}.r4_2.bam
  rm ../../sg_b/${ff}.header.txt ../../sg_b/${ff}.r4.sam
  echo "done! ${i}"
done
