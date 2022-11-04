#!/bin/bash

module load cellranger         || fail "could not load STAR module"


cellranger count --id patient702\
 --fastqs=/data/leec20/RNA_seq_analysis_done/sc_covid/fastq_GSE162086\
 --transcriptome=$CELLRANGER_REF/refdata-gex-GRCh38-2020-A\
 --sample=p702\
 --localcores=$SLURM_CPUS_PER_TASK\
 --localmem=34 --jobmode=slurm --maxjobs=20


echo 702 done


cellranger count --id patient703\
 --fastqs=/data/leec20/RNA_seq_analysis_done/sc_covid/fastq_GSE162086\
 --transcriptome=$CELLRANGER_REF/refdata-gex-GRCh38-2020-A\
 --sample=p703\
 --localcores=$SLURM_CPUS_PER_TASK\
 --localmem=34 --jobmode=slurm --maxjobs=20

echo all done!!

