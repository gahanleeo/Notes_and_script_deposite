
### Parse wet lab workflow

https://www.youtube.com/watch?v=HVx4UBweNH4

### installation 


#### install conda 
- https://hpc.nih.gov/apps/python.html
- conda env need python 3.7 up

```
conda create -n parse python=3.8
conda activate parse
```

- go to the parse package folder 
- run script in the downloaded package
```
./install_dependencies_conda.sh -y
```
 - install python package 
```
pip install ./
```

-  if erro when type split-pipe, install
```
pip install --upgrade psutil
```
- check to see if success 
```
split-pipe --help
```


#### 1. Make fastq file from Illumina raw output 

using bcl2fastq in Beowulf: 

https://hpc.nih.gov/apps/bcl2fastq.html

Can work on Biowulf!

  ---
  

 Expression Level (explained)

 cell count in Vlnplot each plot: 
 

```
table(object@ident)
object@data["Elk1",]
```


---

# tools for Seurat

  

# https://satijalab.org/seurat/articles/de_vignette.html

  

# https://satijalab.org/seurat/articles/integration_introduction.html

  

  
Seurat diff analysis

https://satijalab.org/seurat/articles/de_vignette.html

Seurat data visual

https://satijalab.org/seurat/articles/visualization_vignette.html

![[Seurat_diff_result.png]]


#### Seurat tips

⁃ How many cell in each cluster

⁃ How to extract/ subset cell cluster

⁃ Get desired cell matrix from known cell barcode

https://satijalab.org/seurat/articles/interaction_vignette.html

  

# Seurat command list 

⁃ Subset a cluster

⁃ Idents

https://satijalab.org/seurat/articles/essential_commands.html

  

# How to play with Idents

https://mojaveazure.github.io/seurat-object/reference/Idents.html

  

  

# Other web resource

  

# with GSEA analysis

# https://nbisweden.github.io/workshop-scRNAseq/labs/compiled/seurat/seurat_05_dge.html

  

https://crazyhottommy.github.io/scRNA-seq-workshop-Fall-2019/scRNAseq_workshop_3.html

  

  

#NES meaning 

A positive NES will indicate that genes in set S will be mostly represented at the top of your list L. a negative NES will indicate that the genes in the set S will be mostly at the bottom of your list L.



Sanger sequencing

# https://www.singlecellcourse.org/scrna-seq-dataset-integration.html

  

# not yet read!

https://www.bioinformatics.babraham.ac.uk/training/10XRNASeq/seurat_workflow.html#Automated_Cell_Type_Annotation

  

  

# Avg gene expression is after log normalized data, the value is  mean of counts of reads across cells per clusters. 

  

AverageExpression uses the "data" slot by default (which for RNA assay would store log1p(counts)).

  


https://github.com/satijalab/seurat/discussions/4210

  

  

# what’s pct1 pct2 in Findmarker() ??

  

pct.1 is the percentage of cells in the cluster where the gene is detected, while pct.2 is the percentage of cells on average in all the other clusters where the gene is detected.

  

# cell number too low?

# where cell number

# show. Parse team

  

$lop1p = log(1+X)

  
  

# Vinplot Y-axis explain:



  

By default VlnPlot pulls the expression values from the data slot. ==> log normalized data

Returns a Seurat object with a new assay (named SCT by default) with counts being (corrected) counts, data being log1p(counts), scale.data being pearson residuals



Single cell quant ecc sequence 



#  how to Count number of cells expressing a gene 

https://github.com/satijalab/seurat/issues/371

  

# split object


list = SplitObject(object, group.by)
  
sum(GetAssayData(object = my_object, slot = "data")[my_gene,]>0)
  

# what’s UMAP?

https://www.biostars.org/p/9494294/

  

# 

The Seurat basically after filter out unwanted cell, then do log normalization and the scaling data so that the gives equal weight in downstream analyses, so that highly-expressed genes do not dominate

  

  

After that, they do dimensional reduction techniques such as PCA. 

  

  

Vlnplot 

The dot is each cell that expressed this gene, the expression values is log normalized data 

  

  

# 

Parse for generating bam files

  

https://support.parsebiosciences.com/hc/en-us/articles/4409037064340-Pipeline-Options

  

#  

It’s in the ‘process’ folder, the .bam file

# 

https://support.parsebiosciences.com/hc/en-us/articles/4413723469844-Content-of-fastq-and-bam-files-barcode-and-other-annotations-

# for viewing on IGV, it need changing hg38_1 to chr1 

# using samtools 

  

samtools view -H A_sample.bam | sed 's/hg38_/chr/' | samtools reheader - A_sample.bam > A_ch.bam

  

samtools sort A_ch.bam > sorted.A.bam

  

Samtools index sorted.A.bam

  

  

  

  

  

## Parse has some issue with output folder,

Need only keep process and remove others.  And need to keep the --sample name 

  

# for align  command:

split-pipe --mode align --kit WT_mini  --genome_dir ./genomes/hg38/ --output_dir ./output_step/ --sample RT4_hi_2D A2-A4 --no_allwell --one_step --nthreads 12

  

## parse align using STAR 

/data/leec20/conda/envs/parse/bin/STAR --genomeDir ./genomes/hg38 --runThreadN 56 --readFilesIn ./output_step1/123/process/barcode_head.fastq.gz --outFileNamePrefix ./output_step1/123/process/barcode_head --outSAMtype BAM Unsorted --readFilesCommand zcat --outFilterMultimapNmax 3

  

  

## when generated bam file after running pipeline, the barcode_aligned…bam contains all reads of all well’s cell barcode/reads. Meaning is one mega bam files

  

# SNPs

  

GWAS SNPs of interest for bladder cancer association:

rs10069690

CACACGGGATCCTCATGCCA C/T ACCTCTGTCCACCTCACCCC

CC

  

rs2242652

CTGCATCCAGGCCCTGGCCC A/G GCTGCTTCTTGTGGTCCTCA

  

rs401681

ATCCAGACAACTTCAGAGTC C/T ATCATGGTGTGAAGCAGCTT

  

ChimericOut Expression

- rwer
	-weqeqwe