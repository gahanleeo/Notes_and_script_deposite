## links:
https://nci-iteb.github.io/tumor_epidemiology_approaches/sessions/session_4/practical

- Course detail: 
![[DCEG_course_detail.png|250]]


## GATK pipeline

### course step 1 command:

```
#!/bin/bash

#### Data preprocess for somatic short variant discovery using GATK workflow ###

module load samtools
module load bwa
module load fastp
module load GATK/4.3.0.0
module load picard/2.27.3

GATK_Bundle=/fdb/GATK_resource_bundle/hg38-v0
GENOME=$GATK_Bundle/Homo_sapiens_assembly38.fasta

SAMPLE=$1
INDIR=$2
DIR=$3
logs=$DIR/logs
read1=$INDIR/${SAMPLE}_R1.fastq.gz
read2=$INDIR/${SAMPLE}_R2.fastq.gz
id=$SAMPLE
lb=$id
sm=$id

SECONDS=0

echo -e "sample:$SAMPLE\nindir:$INDIR\noutdir:$DIR"

if [ ! -d "$DIR" ]; then
        mkdir -p $DIR
fi
if [ ! -d "$logs" ]; then
        mkdir -p $logs
fi
### Perform adaptor trimming on fastq files ###
fastp -i $read1 -I $read2 \
      --stdout --thread 2 \
      -j ${logs}/fastp-${SAMPLE}.json \
      -h ${logs}/fastp-${SAMPLE}.html \
      2> ${logs}/fastp-${SAMPLE}.log | \
bwa mem -M -t 8 \
      -R "@RG\tID:$id\tPL:ILLUMINA\tLB:$lb\tSM:$sm" \
      $GENOME - 2> ${logs}/bwa-${SAMPLE}.log | \
samtools sort -T /lscratch/$SLURM_JOB_ID/ -m 2G -@ 4 -O BAM \
      -o $DIR/${SAMPLE}_sort.bam  2> ${logs}/samtools-${SAMPLE}.log

###/lscratch/$SLURM_JOBID
duration=$SECONDS
echo "Alignment completed. $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."

### Duplicate marking in coordinate-sorted raw BAM files ###
java -Xmx2g -jar $PICARDJARPATH/picard.jar MarkDuplicates \
     -I $DIR/${SAMPLE}_sort.bam \
    -O /dev/stdout \
    -M marked_dup_metrics.txt 2> ${logs}/markdup-${SAMPLE}.log \
|java -Xmx2g -jar $PICARDJARPATH/picard.jar SortSam \
      -I /dev/stdin -O $DIR/${SAMPLE}_markdup_sorted.bam \
      -SORT_ORDER coordinate 2>> ${logs}/markdup-${SAMPLE}.log

duration=$SECONDS
echo "Duplicate marking completed. $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."

DBSNP=/fdb/GATK_resource_bundle/hg38/dbsnp_138.hg38.vcf.gz
INDEL=/fdb/GATK_resource_bundle/hg38-v0/Homo_sapiens_assembly38.known_indels.vcf.gz
GOLD_INDEL=/fdb/GATK_resource_bundle/hg38-v0/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz

### Recaliberating base quality score###
gatk --java-options "-Djava.io.tmpdir=/lscratch/$SLURM_JOBID -Xms6G -Xmx6G -XX:ParallelGCThreads=2" BaseRecalibrator \
  -I $DIR/${SAMPLE}_markdup_sorted.bam \
  -R $GENOME \
  -O  $DIR/${SAMPLE}_markdup_bqsr.report \
  --known-sites $DBSNP \
  --known-sites $INDEL \
  --known-sites $GOLD_INDEL \
  > ${logs}/BQSR-${SAMPLE}.log 2>&1

gatk --java-options "-Djava.io.tmpdir=/lscratch/$SLURM_JOBID -Xms6G -Xmx6G -XX:ParallelGCThreads=2" ApplyBQSR \
  -I $DIR/${SAMPLE}_markdup_sorted.bam  \
  -R $GENOME \
  --bqsr-recal-file  $DIR/${SAMPLE}_markdup_bqsr.report \
  -O  $DIR/${SAMPLE}_markdup_bqsr.bam \
  >> ${logs}/BQSR-${SAMPLE}.log 2>&1

duration=$SECONDS
echo "Base recaliration completed. $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."


```

- The command line `> ${logs}/BQSR-${SAMPLE}.log 2>&1` redirects ‘standard error’ messages - denoted by file descriptor ‘2’ - to the ‘standard output’ - denoted by file descriptor ‘1’, and writes both mesagges to the log file BQSR-${SAMPLE}.log, which will be otherwise output to the screen.

### course step 2 command:

```
#!/bin/bash

#### Call somatic short variant discovery using MuTect2 and filtering ###

module load samtools
module load bwa
module load fastp
module load GATK/4.3.0.0
module load picard/2.27.3

GATK_Bundle=/fdb/GATK_resource_bundle/hg38-v0
GENOME=$GATK_Bundle/Homo_sapiens_assembly38.fasta
COMMONVAR=/data/classes/DCEG_Somatic_Workshop/Practical_session_4/Reference/small_exac_common_3.hg38.vcf.gz

NSAMPLE=$1
TSAMPLE=$2
PREFIX=$3
INDIR=$4
DIR=$5
logs=$DIR/logs

BAM_NORMAL=$INDIR/${NSAMPLE}_markdup_bqsr.bam
BAM_TUMOR=$INDIR/${TSAMPLE}_markdup_bqsr.bam
BASE_TUMOR=`samtools view -H $BAM_TUMOR |awk '$1~/^@RG/ {for (i=1;i<=NF;i++) {if ($i~/SM/) {split($i,aa,":"); print aa[2]}}}'|sort|uniq`
BASE_NORMAL=`samtools view -H $BAM_NORMAL | awk '$1~/^@RG/ {for (i=1;i<=NF;i++) {if ($i~/SM/) {split($i,aa,":"); print aa[2]}}}'|sort|uniq`

OUT_VCF=$DIR/${PREFIX}.vcf
OUT_FILTERED_VCF=$DIR/${PREFIX}_filtered.vcf
OUT_PASSED_VCF=$DIR/${PREFIX}_passed.vcf
OUT_STATS=$DIR/${PREFIX}.vcf.stats

SECONDS=0

if [ ! -d "$DIR" ]; then
        mkdir -p $DIR
fi
if [ ! -d "$logs" ]; then
        mkdir -p $logs
fi
### SNV and Indel calling  ###
gatk --java-options "-Djava.io.tmpdir=/lscratch/$SLURM_JOBID -Xms20G -Xmx20G -XX:ParallelGCThreads=1" Mutect2 \
  -R $GENOME \
  -I $BAM_NORMAL \
  -I $BAM_TUMOR \
  -normal $BASE_NORMAL \
  -tumor $BASE_TUMOR \
  -O $OUT_VCF \
  > ${logs}/Mutect2-${PREFIX}.log 2>&1

duration=$SECONDS
echo "MuTect2 completed. $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."

### Filtering the MuTect2 variant calls ###
### Estimate cross-sample contamination  ###

gatk --java-options "-Xms10G -Xmx10G -XX:ParallelGCThreads=2" GetPileupSummaries \
   -I $BAM_TUMOR \
   -V $COMMONVAR \
   -L $COMMONVAR \
   -O $DIR/${TSAMPLE}_pileups.table \
   > ${logs}/VarFilter-${PREFIX}.log 2>&1

gatk --java-options "-Xms10G -Xmx10G -XX:ParallelGCThreads=2" GetPileupSummaries \
   -I $BAM_NORMAL \
   -V $COMMONVAR \
   -L $COMMONVAR \
   -O $DIR/${NSAMPLE}_pileups.table \
   >> ${logs}/VarFilter-${PREFIX}.log 2>&1

gatk --java-options "-Xms10G -Xmx10G -XX:ParallelGCThreads=2" CalculateContamination \
     -I $DIR/${TSAMPLE}_pileups.table \
     -matched $DIR/${NSAMPLE}_pileups.table \
     -tumor-segmentation $DIR/${TSAMPLE}_segments.table \
     -O $DIR/${TSAMPLE}_calculatecontamination.table \
     >> ${logs}/VarFilter-${PREFIX}.log 2>&1

### Filter variants  ###

gatk --java-options "-Djava.io.tmpdir=/lscratch/$SLURM_JOBID -Xms20G -Xmx20G -XX:ParallelGCThreads=2" FilterMutectCalls \
  -R $GENOME \
  --contamination-table $DIR/${TSAMPLE}_calculatecontamination.table \
  --stats $OUT_STATS \
  --tumor-segmentation $DIR/${TSAMPLE}_segments.table \
  -O $OUT_FILTERED_VCF \
  -V $OUT_VCF \
  >> ${logs}/VarFilter-${PREFIX}.log 2>&1
awk '($1 ~/^#/) || ($7 ~ /PASS/) {print}' $OUT_FILTERED_VCF >$OUT_PASSED_VCF

###/lscratch/$SLURM_JOBID
duration=$SECONDS
echo "Filtering completed. $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
```

- ```grep -v``` will extract all lines that do NOT contain a specific pattern. The pattern we specify is “^#”, which is lines starting with the “#” symbol. This will exclude all the header lines in the VCF file. Then we redirect the output to the command wc -l which calculates the number of lines.

## step3,  Annotation of somatic short variants

- [Funcotator](https://gatk.broadinstitute.org/hc/en-us/articles/360035889931-Funcotator-Information-and-Tutorial)
```
#!/bin/bash

#### Annotate VCF file with Funcotator ###

module load samtools
module load GATK/4.3.0.0

GATK_Bundle=/fdb/GATK_resource_bundle/hg38-v0
GENOME=$GATK_Bundle/Homo_sapiens_assembly38.fasta
FUNCOTATORDB=/fdb/GATK_resource_bundle/funcotator/funcotator_dataSources.v1.7.20200521s

PREFIX=$1
INDIR=$2
DIR=$3
logs=$DIR/logs
IN_VCF=$INDIR/${PREFIX}_passed.vcf
OUT_ANNOT_MAF=$DIR/${PREFIX}_funcotator.maf

if [ ! -d "$DIR" ]; then
        mkdir -p $DIR
fi
if [ ! -d "$logs" ]; then
        mkdir -p $logs
fi

SECONDS=0

gatk --java-options "-Xms10G -Xmx10G -XX:ParallelGCThreads=2" Funcotator -R $GENOME \
     -V $IN_VCF \
     -O $OUT_ANNOT_MAF \
     --output-file-format MAF \
     --data-sources-path $FUNCOTATORDB \
     --ref-version hg38

duration=$SECONDS
echo "Annotation completed. $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
```

- ANNOVAR
```
#!/bin/bash

#### Annotate VCF file with ANNOVAR ###
module load annovar/2020-06-08

PREFIX=$1
INDIR=$2
DIR=$3
logs=$DIR/logs
IN_VCF=$INDIR/${PREFIX}_passed.vcf

if [ ! -d "$DIR" ]; then
        mkdir -p $DIR
fi
if [ ! -d "$logs" ]; then
        mkdir -p $logs
fi

echo $IN_VCF
echo $INDIR
echo $DIR
SECONDS=0

cd $DIR
convert2annovar.pl -format vcf4 $IN_VCF -includeinfo >${PREFIX}.avinput
table_annovar.pl  ${PREFIX}.avinput $ANNOVAR_DATA/hg38 \
	-buildver hg38 -out ${PREFIX} -remove \
	-protocol refGene,cytoBand,exac03,avsnp147,dbnsfp30a -operation g,r,f,f,f \
	-nastring . -csvout -polish

duration=$SECONDS
echo "Annotation completed. $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
```


The Funcotator output is in the MAF format, the first several columns are the basic features of the mutation: genomic coordinates, reference and variant alleles, variant classifications and types. The variant classifications and types could be used to prioritize candidate driver mutations.

The ANNOVAR output is in VCF format. The first several columns include basic information about the variants. The columns of ‘Func.refGene’ and ‘ExonicFunc.refGene’ could be used to prioritize candidate driver mutations. The column ‘AAChange.refGene’ provides similar information to the protein changes annotated by Funcotator.

## visulaization

##### maftools: Summarize, Analyze and Visualize MAF Files

https://www.bioconductor.org/packages/devel/bioc/vignettes/maftools/inst/doc/maftools.html


-   For VCF files or simple tabular files, easy option is to use [vcf2maf](https://github.com/mskcc/vcf2maf) utility which will annotate VCFs, prioritize transcripts, and generates an MAF. Recent updates to gatk has also enabled [funcotator](https://gatk.broadinstitute.org/hc/en-us/articles/360035889931-Funcotator-Information-and-Tutorial) to genrate MAF files.
    
-   If you’re using [ANNOVAR](http://annovar.openbioinformatics.org/en/latest/) for variant annotations, maftools has a handy function `annovarToMaf` for converting tabular annovar outputs to MAF.

[R scripts for maftool GATK](file:/Users/leec20/Desktop/scripts/R_scripts/maftool_GATK_FINAL_20230111.R)

---
## 01/25/23 - SV calling

- ### [Manta](https://github.com/Illumina/manta), use for illumina short read pair-end seq dataset

- Also in biowulf module list 

- python scrips, first use configManta.py to setting input,ref,etc

```
configManta.py \
normalBam=/data/classes/DCEG_Somatic_Workshop/Practical_session_6/data/NSLC-0463-B01.bam \
tumorBam=/data/classes/DCEG_Somatic_Workshop/Practical_session_6/data/NSLC-0463-T01.bam \
referenceFasta=/data/classes/DCEG_Somatic_Workshop/Practical_session_6/reference/Homo_sapiens_assembly38.fasta \
--runDir NSLC-0463

```

- then use ``runWorkflow.py`` in the runDir to run the script 
```
runWorkflow.py -m local -j 2 >NSLC-0463.log 2>&1
```

- once done after checking `tree -sh result` 
- to check vcf file, can use `bcftools` 

```
module load bcftools

bcftools view  NSLC-0463/results/variants/somaticSV.vcf.gz |grep -v "^##"

```

This command runs the **bcftools view** command, which is used to display the contents of a VCF file. The **|** operator pipes the output of the **bcftools view** command to the grep command, which is used to filter the output. The **-v** option inverts the sense of the match, so that the grep command prints only the lines that do not match the pattern “^##”.

### Visualization using svviz

- in biowulf too! 

```
svviz -t bkend \
-b /data/classes/DCEG_Somatic_Workshop/Practical_session_6/data/NSLC-0463-B01.bam \
-b /data/classes/DCEG_Somatic_Workshop/Practical_session_6/data/NSLC-0463-T01.bam \
/data/classes/DCEG_Somatic_Workshop/Practical_session_6/reference/Homo_sapiens_assembly38.fasta chr2 42299403 + chr2 29225011 - \
--export NSLC-0463_EML4-ALK_fusion.svg \
--annotation /data/classes/DCEG_Somatic_Workshop/Practical_session_6/reference/genes.gtf

```



This command runs the svviz tool with a number of options and arguments. The **-t bkend** option specifies the type of SV being visualized (in this case, “bkend” stands for “breakend”). The **-b** options specify the paths to the normal and tumor BAM files, respectively. The next three arguments specify the reference genome, the coordinates of the structural variation, and the orientation of the sequences, respectively. The **–export** option specifies the name of the file where the visualization should be saved, and the **–annotation** option specifies the path to a GTF file with gene annotations.

## SV Annotation

- NIRVANA

```

nirvana -c $NIRVANA_DATA/Cache/GRCh38/Both \
--sd $NIRVANA_DATA/SupplementaryAnnotation/GRCh38 \
-r $NIRVANA_DATA/References/Homo_sapiens.GRCh38.Nirvana.dat \
-i NSLC-0463/results/variants/somaticSV.vcf.gz \
-o NSLC-0463

```

The output is `JSON` files, it's had to utilite, so using R to convert those files.

In R:
```
library(jsonlite)
library(tidyverse)

jsondata <- fromJSON('NSLC-0463.json.gz')

## extract the Header
jsondata %>% .[[1]] %>% as.data.frame() %>% as_tibble()

## extract the positions and all variant information
jsondata %>% .[[2]] %>% as_tibble()


## expand per-sample read support
jsondata %>% .[[2]] %>% as_tibble() %>% unnest(samples)


## expand per-sample read support, variant filtering status, and any multi-allelic sites
jsondata %>% .[[2]] %>% as_tibble() %>% unnest(c(altAlleles,filters,samples))


## extract specific variant annotations
jsondata %>% .[[2]] %>% as_tibble() %>% pull(variants) %>% bind_rows() %>% as_tibble()

## extract gene annotations
jsondata %>% .[[3]] %>% as_tibble()

## combine all info into one table
vars<-jsondata %>% .[[2]] %>%
  as_tibble() %>%
  ## expand the variants annotations to columns
  mutate(variants %>% bind_rows() %>% as_tibble())%>%
  select(-variants)%>%
  ## add the gene annotations
  cbind(jsondata %>% .[[3]] %>% as_tibble())%>%
  ## expand the sample read supports and add the sample names
  ## then move the sample names column before read support cols
  unnest(samples,altAlleles)%>%
  cbind(sample_names=jsondata[[1]]$samples)%>%
  relocate(sample_names,.before = splitReadCounts)%>%
  as.tibble()

## Use this code to expand any other columns, such as clingen disease phenotypes
## if keep_empty=FALSE, variants without annotations in column clingenGeneValidity will be dropped
# vars%>%unnest(clingenGeneValidity, keep_empty=TRUE)

```

### Other tools

-  AnnotSV

- FGViewer

- Finally using R to visulaization: example location
	[SV_visual_example](file://Users/leec20/Desktop/scripts/R_scripts/Circos_Rscripts_for_SV_visual_example)


![[Screenshot 2023-03-28 at 9.42.48 AM.png]]


#### eccDNA

![[Screenshot 2023-03-28 at 10.18.57 AM.png]]
- eccDNA enrich in different type of cancer
- 
![[Screenshot 2023-03-28 at 10.21.14 AM.png]]
- eccDNA pass randomly in cell cycle
![[Screenshot 2023-03-28 at 10.23.49 AM.png]]


---

### RNA-seq data mining 
https://nci-iteb.github.io/tumor_epidemiology_approaches/sessions/session_11

- long-read pacbio can just blast the sequence to transcripts

