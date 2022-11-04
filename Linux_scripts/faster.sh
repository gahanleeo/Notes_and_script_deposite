#!/bin/bash

module load sratoolkit

fasterq-dump -t /lscratch/$SLURM_JOBID -O /data/leec20/1000_genome SRR13867038
gzip *.fastq
fasterq-dump -t /lscratch/$SLURM_JOBID -O /data/leec20/1000_genome SRR13867039
gzip *.fastq


for i in {41..57}
do
fasterq-dump -t /lscratch/$SLURM_JOBID -O /data/leec20/1000_genome SRR138670$i
gzip *.fastq

done

echo DONE GZIP! 

#
### for control dbGAP, need .ngc file ###

#for i in {696..740}
#do
#
#fasterq-dump --ngc <file.ngc> -t /lscratch/$SLURM_JOBID  -O . SRRXXXXX
#gzip *.fastq

#done

# excute example:
# sbatch --gres=lscratch:30  --cpus-per-task=6  myscript
