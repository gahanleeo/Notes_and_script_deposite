#!/bin/bash

# install igvtool using conda:
# https://anaconda.org/bioconda/igvtools

# or use igvtools on Biowulf:
https://hpc.nih.gov/apps/IGV.html


# 1. go to the folder which has bam files in it
# 2. create a output folder at upper level
# 3. set SNP location ex: chr12:112911065-112911065
# NOTE: be sure to check chromome name in bam files, "chr12" or just "12", need to change SNP loctaion accordingly


# make a output folder in upper folder
mkdir ../output_files

# in the folder where bam files located
# the last commnad is hg38 or hg19 according to genome reference
for i in *.bam
do
igvtools count -w 1 --bases --query chr12:112911065-112911065 $i ../output_files/$i.wig hg38
done

# go to output folder
cd ../output_files
# extract the 4th row of the wig file which contain nucleotide count, and add bam file name in the first column:
for i in *.wig
do
awk '{print FILENAME (NF?"\t":"") $0}' $i|awk 'NR==4' > $i.txt
done
# Finally, combine all .txt file into one txt file, which can be open using excel
cat *.txt > all_genotyping.txt
rm *.wig*
