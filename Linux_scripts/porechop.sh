#!/bin/bash


module load porechop


for i in *.fastq
do
porechop -i $i -o trimmed/trim_"$i" --threads=$SLURM_CPUS_PER_TASK
done


echo all DONE!!

