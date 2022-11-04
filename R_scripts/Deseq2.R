library(dplyr)
library(DESeq2)
library(ggplot2)

#read raw count
f1 = read.delim2('Desktop/multime_ID_rawcount.txt')

row.names(f1) = make.names(f1$hgnc_symbol, unique=TRUE)

f1 = f1[,-1]




# load condition and ID_name 
datainf = read.delim2('Desktop/Duke_PBMC_PRJNA679264/Duke_PBMCs/OAS1_TPM_14pati_for_plot.txt')
# get info
tar = colnames(f1)
info = datainf %>% filter(Sample_ID %in% tar)
# get the protect and risk alelle patients
patient.risk = c('0D76FC','0E1F8E','FA9A61')
patient.protect = c('450905','45FBA5')
info.risk = info %>% filter(Subject_ID %in% patient.risk)
info.protect = info %>% filter(Subject_ID %in% patient.protect)
info = info.risk[,c(7,5)]
## reorder the f1 
target = info.risk$Sample_ID
f1 = select(f1,target) 
## get one specific patient_set
target = c(paste0('PB','_', c(10:16)))
f1 = select(f1,target) 



colnames(info) = c('ID','condition')
coldata = info

# convert to factor 
coldata$ID = as.factor(coldata$ID)
coldata$condition = as.factor(coldata$condition)

levels(coldata$condition) <- c("early", "middle","late")
# get countdata
dds <- DESeqDataSetFromMatrix(countData = f1,
                                 colData = coldata,
                                 design = ~ condition)


##

# pre-filter

nrow(dds)

keep <- rowSums(counts(dds)) > 1
dds <- dds[keep,]
nrow(dds)

# run
dds = DESeq(dds)
res <- results(dds)

res <- results(dds,contrast=c("condition","late","early"))

resultsNames(dds)
#t1 = as.data.frame(res)
resLFC <- lfcShrink(dds, coef="condition_late_vs_early" , type="apeglm")
resLFC

### export result with adjust pvaule (FDR) 
#DESeq2 uses the Benjamini-Hochberg (BH) adjustment 
resSig <- subset(res, padj < 0.1)
# top down-regulated
head(resSig[ order(resSig$log2FoldChange), ])
# top up-regulated 
head(resSig[ order(resSig$log2FoldChange, decreasing = TRUE), ])



# plot 

plotCounts(dds, gene="OAS1", intgroup="condition")

vsd <- vst(dds, blind = FALSE)
rld <- rlog(dds, blind = FALSE)

dds <- estimateSizeFactors(dds)

plotPCA(vsd)


library(ggbeeswarm)
geneCounts <- plotCounts(dds, gene = 'OAS1',
                         returnData = TRUE)
ggplot(geneCounts, aes(x = condition, y = count, )) +
  scale_y_log10() +  geom_beeswarm(cex = 3)

## plot top var according to vsd

library(genefilter)
library("pheatmap")
topVarGenes <- head(order(rowVars(assay(vsd)), decreasing = TRUE), 50)

mat  <- assay(vsd)[ topVarGenes, ]
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(vsd)[, c("ID","condition")])
pheatmap(mat, annotation_col = anno)

### plot top gene with high padj, the paper used this method!


resSig <- subset(res, padj < 0.01)
p1 = as.data.frame(resSig)
p1$Gene = row.names(p1)
p1 = arrange(p1, padj)
topgene = p1$Gene[1:20]

anno <- as.data.frame(colData(dds)[,c("ID","condition")])

pheatmap(assay(vsd)[topgene,],
         annotation_col = anno)
dev.off()
