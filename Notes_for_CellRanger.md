# Cell Ranger 

mkfastq 

## where to look at sample lane? 

Inside the “RunInfo.xml” in the output folder after finishing running sequencer


## design gRNAs for CRISPRi

https://portals.broadinstitute.org/gpp/public/analysis-tools/sgrna-design-help-crisprai

## for chromosome 5:
Anti strand

 ```NC_000005.10:-:742380```

### working command for cell ranger count in Beowulf

```cellranger count --id b10 --fastqs=/data/leec20/RNA_seq_analysis_done/sc_covid/fastq_GSE157344/blood10  --transcriptome=$CELLRANGER_REF/refdata-gex-GRCh38-2020-A --localcores=$SLURM_CPUS_PER_TASK --localmem=34```

## rename the fastq file! 

[Sample Name]_S1_L00[Lane Number]_[Read Type]_001.fastq.gz

```cellranger count --id=test697 --sample=p697 --transcriptome=$CELLRANGER_REF/refdata-gex-GRCh38-2020-A --fastqs=/data/leec20/RNA_seq_analysis_done/sc_covid/fastq_GSE162086 --localcores=$SLURM_CPUS_PER_TASK --localmem=34```
