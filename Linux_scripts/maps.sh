#!/bin/bash

module load samtools bwa

source /data/$USER/conda/etc/profile.d/conda.sh

conda activate textimport

# command line

genome=/fdb/igenomes/Mus_musculus/UCSC/mm10/Sequence/BWAIndex/genome.fa

sh MAPS/bin/Arima-MAPS_v2.0.sh -C 1 -p broad -I fastq/sc_mai/SC829846_CGATGT_L001 -O /data/leec20/hichip_CHiC_project/MAPS_arima_HiChIP/mm10_output -o mm10 -b $genome -t 24 -f 1

echo done!


