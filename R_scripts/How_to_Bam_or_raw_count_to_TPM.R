# How to transform from bam file to TPM?  
####BAM file ==> Featurecount ==> count table ==> as input to Deseq2 or calculate TPM ######
library("DESeq2")
library(Rsubread)
library(edgeR)
library(dplyr)
##
setwd('/Users/leec20/Desktop/Monocyte_dataset/')
# load Rsubread for feature count function
target = list.files(path = 'test_mono_Deseq2',full.names = T)

fc.result = featureCounts(files=target, annot.ext='For_count/UCSC_genes.gtf', 
                          isGTFAnnotationFile=TRUE,
                          isPairedEnd=F)
fc = fc.result

# extract the count table 
counttable = as.data.frame(fc$counts)

## calculate the gene length for TPM
# First, import the GTF-file that you have also used as input for count tools (HT-seq or Featurecount)
library(GenomicFeatures)
txdb <- makeTxDbFromGFF("Homo_sapiens.GRCh38.83.gtf",format="gtf")
# then collect the exons per gene id
exons.list.per.gene <- exonsBy(txdb,by="gene")
# then for each gene, reduce all the exons to a set of non overlapping exons, calculate their lengths (widths) and sum then
exonic.gene.sizes <- sum(width(reduce(exons.list.per.gene)))

t1 =as.data.frame(exonic.gene.sizes)
t1$genelen = row.names(t1)


setwd('~/Desktop/')

#read raw count
##
f1 = read.delim2('Duke_PBMC_PRJNA679264/Duke_PBMCs/raw count/GSE161731_counts_pbid.txt')
row.names(f1) = make.names(f1$Gene, unique=TRUE)
f1 = f1[,-1]

##use join function to match gene lenght to the count table..
tt = dplyr::left_join(f2, t1, by = "gene")

dg = DGEList(counts=f1)
f2 = cpm(dg)
f2 = as.data.frame(f2)


f2.rpkm = rpkm(f2,gene.length =genelen)
f2.rpkm2 = rpkm(tt,gene.length =tt$len)

tpm = t(t(f2.rpkm)/colSums(f2.rpkm))*1e6

######
#####

f2$gene = row.names(f2)


f2.rpkm = rpkm(f2,gene.length =genelen)
f2.rpkm2 = rpkm(tt,gene.length =tt$len)



colnames(t1) = c('len','gene')
