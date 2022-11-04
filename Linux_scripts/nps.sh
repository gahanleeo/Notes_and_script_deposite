#!/bin/bash


module load samtools || exit 1



samtools merge A549_IFNB_hg19.final.bam *.bam


echo all DONE!!
