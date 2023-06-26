

### Parse wet lab workflow

https://www.youtube.com/watch?v=HVx4UBweNH4

---
### Parse piepline

**Pipeline and installation**
https://support.parsebiosciences.com/hc/en-us/articles/13473569833108-Pipeline-Setup-and-Use-Current-Version-

login: kforsythe97@gmail.com
code: Pass2366

---

- Make fastq file from Illumina raw output, usually CGR will do that 
	using bcl2fastq in Beowulf: 
	https://hpc.nih.gov/apps/bcl2fastq.html

- How to add sequence in the reference genome? like add GFP or virus sequence
	https://support.parsebiosciences.com/hc/en-us/articles/4403865746196-Adding-Custom-Sequences
	10X cell Ranger also has this tips:
	https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/using/tutorial_mr


---

- **Parse fastq files explian**
	[the R1 and R2 infromation](https://support.parsebiosciences.com/hc/en-us/articles/4413723469844-Content-of-fastq-and-bam-files-barcode-and-other-annotations-)

- Question:
- What chemistry, kit, sample table: => WT_mini
- L1 / L2, 4 total sublibrary, SD064953 to SD064956

- In L-drive:
	- L001 sample excel file
	- L002 sample excel file



Expression Level (explained)

 cell count in Vlnplot each plot: 
 

```
table(object@ident)
object@data["Elk1",]
```

##### The cluster annotation
https://www.10xgenomics.com/resources/analysis-guides/web-resources-for-cell-type-annotation





---

# tools for Seurat


https://satijalab.org/seurat/articles/de_vignette.html
  
https://satijalab.org/seurat/articles/integration_introduction.html

---


- **Seurat diff analysis**
	https://satijalab.org/seurat/articles/de_vignette.html
	- should you intergeted data before do diff analysis?
		https://github.com/satijalab/seurat/discussions/4000
		- no need, 
	- New method using SCT transdorm data:
		- https://satijalab.org/seurat/articles/sctransform_v2_vignette.html
		- **when do differential analysis, they use assay = SCT, not intergation**
		`Assays(seurat_object)` can output how many assay in this Seurat object
- Seurat intrgratoin
	- https://satijalab.org/seurat/articles/integration_introduction.html
	- **noted that when performing differential expression after integration,  switch back to the original!**
	- From `DefaultAssay(immune.combined) <- "integrated"` to  `DefaultAssay(immune.combined) <- "RNA"` 

- **More disscussion about intergarion or merge dataset**
- https://github.com/satijalab/seurat/discussions/3998


---



Seurat data visual

https://satijalab.org/seurat/articles/visualization_vignette.html

![[Seurat_diff_result.png]]


#### Seurat tips

⁃ How many cell in each cluster
⁃ How to extract/ subset cell cluster
⁃ Get desired cell matrix from known cell barcode
https://satijalab.org/seurat/articles/interaction_vignette.html


  

#### [Seurat command list ](https://satijalab.org/seurat/articles/essential_commands.html)
- Subset a cluster
- Idents
- change assay type
  

### How to play with Idents

https://mojaveazure.github.io/seurat-object/reference/Idents.html

### How to remove subset cell cluster?

[However](https://github.com/satijalab/seurat/issues/3030), if you are planning on doing analysis of the subset you should probably reanalyze again as the old analysis from Variable Features onward was based on those cells still being present in the object.

```
# To subset and perform new analysis on single cluster
sub_obj <- subset(object = obj_name, idents = 1)

# To subset and remove single cluster and keep the remaining clusters for new analysis
sub_obj <- subset(object = obj_name, idents = 1, invert = TRUE)

# Can also provide multiple idents using the typical R syntax "c()"
sub_obj <- subset(object = obj_name, idents = c(1, 2, 3))

# If you have renamed the clusters be sure to provide their names in quotes in the function
sub_obj <- subset(object = obj_name, idents = "Monocytes")
```

  ---
  
## Other web resource

### with GSEA analysis

https://nbisweden.github.io/workshop-scRNAseq/labs/compiled/seurat/seurat_05_dge.html


https://crazyhottommy.github.io/scRNA-seq-workshop-Fall-2019/scRNAseq_workshop_3.html


  
`NES` meaning 

A positive NES will indicate that genes in set S will be mostly represented at the top of your list L. a negative NES will indicate that the genes in the set S will be mostly at the bottom of your list L.



Sanger sequencing

https://www.singlecellcourse.org/scrna-seq-dataset-integration.html


# not yet read!

https://www.bioinformatics.babraham.ac.uk/training/10XRNASeq/seurat_workflow.html#Automated_Cell_Type_Annotation




##### Avg gene expression is after log normalized data, the value is  mean of counts of reads across cells per clusters. 


AverageExpression uses the "data" slot by default (which for RNA assay would store log1p(counts)).



https://github.com/satijalab/seurat/discussions/4210


- what’s pct1 pct2 in Findmarker() ??


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


The Seurat basically after filter out unwanted cell, then do log normalization and the scaling data so that the gives equal weight in downstream analyses, so that highly-expressed genes do not dominate

  



After that, they do dimensional reduction techniques such as PCA. 

  
  
Vlnplot 

The dot is each cell that expressed this gene, the expression values is log normalized data 

  

Parse for generating bam files

  

https://support.parsebiosciences.com/hc/en-us/articles/4409037064340-Pipeline-Options



It’s in the ‘process’ folder, the .bam file


https://support.parsebiosciences.com/hc/en-us/articles/4413723469844-Content-of-fastq-and-bam-files-barcode-and-other-annotations-

 for viewing on IGV, it need changing hg38_1 to chr1 
 
 using samtools 


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

CACACGGGATCCTCATGCCA C/T ACCTCTGTCCACCTCACCCCCC


rs2242652

CTGCATCCAGGCCCTGGCCC A/G GCTGCTTCTTGTGGTCCTCA

  
rs401681

ATCCAGACAACTTCAGAGTC C/T ATCATGGTGTGAAGCAGCTT


---
# Parse project for tissue

- 2 sample pate, with 2 pairs of fastqs files for each plates, after I ran each sublibary, I combined these sublibary.  

---

# parse output

![[Screenshot 2023-04-04 at 11.58.58 AM.png]]

![[Screenshot 2023-04-05 at 2.29.56 PM.png]]

![[Screenshot 2023-04-05 at 2.41.40 PM.png]]