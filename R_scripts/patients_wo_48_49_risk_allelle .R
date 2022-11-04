library(dplyr)
library(DESeq2)
library(ggplot2)

setwd('Desktop/')

#read raw count
f1 = read.delim2('Duke_PBMC_PRJNA679264/Duke_PBMCs/multime_ID_rawcount.txt')
row.names(f1) = make.names(f1$hgnc_symbol, unique=TRUE)
f1 = f1[,-1]

# load condition and ID_name 
datainf = read.delim2('Duke_PBMC_PRJNA679264/Duke_PBMCs/OAS1_TPM_14pati_for_plot.txt')
# get info
info = datainf %>% filter(Sample_ID %in% colnames(f1))
# get the protect and risk alelle patients
##'', 0E1F8E,FA9A61
patient.risk = c('0D76FC', '0E1F8E')
#patient.med.risk = c('180E1A','1A9B20','318281','35D90D','7085CA', 'C90C79','E4B8AD')
# remove the outliner
patient.protect = c('450905','82CCF5')
info.risk = info %>% filter(Subject_ID %in% patient.risk)
#info.med.risk = info %>% filter(Subject_ID %in% patient.med.risk)
info.protect = info %>% filter(Subject_ID %in% patient.protect)
info = info.risk[,c(7,5)]
info = info.protect[,c(7,5)]

## reorder the f1 !!!! the order will effect the result!!!!!!! 
#Should match with row of colData!!!
# no PB_48, PB_49
target = c(paste0('PB','_',c(28,65,29,64,27,63)))

# protect allelle, remove outliner PB_12
target = c(paste0('PB','_',c(10,11,13,14,15,39,16,40)))

# reorder the info 
info = info[match(target, info$Sample_ID),]
## extract the rawcount with this order
f2 = select(f1,target) 
## get one specific patient_set
#target = c(paste0('PB','_', c(10:16)))
#f1 = select(f1,target) 

colnames(info) = c('ID','condition')
coldata = info

# convert to factor 
#coldata$ID = as.factor(coldata$ID)
coldata$condition =  factor(coldata$condition, levels = c("early","middle",'late'))

## dds creat
dds <- DESeqDataSetFromMatrix(countData = f2,
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

res <- results(dds,contrast=c("condition","late","middle"))

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

vsd <- vst(dds, blind = FALSE)
rld <- rlog(dds, blind = FALSE)

topVarGenes <- head(order(rowVars(assay(vsd)), decreasing = TRUE), 100)

mat  <- assay(vsd)[ topVarGenes, ]
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(vsd)[, c("ID","condition")])
pheatmap(mat, annotation_col = anno)

### plot top gene with high padj, the paper used this method!

resSig <- subset(res, padj < 0.1)
p1 = as.data.frame(resSig)
p1$Gene = row.names(p1)
p1 = arrange(p1, padj)
topgene = p1$Gene[1:20]

# anno <- as.data.frame(colData(dds)[,c("ID","condition")])
##
an = data.frame(colData(dds))
anno = data.frame(an[,2])
colnames(anno) = 'condition'
rownames(anno) = an$ID


vsd <- assay(vst(dds))
Z <- t(scale(t(vsd)))

pheatmap(Z[topgene,],
         annotation_col = anno,
         main = 'Top 20 lowest p-adj gene list in risk allele patients',
         scale = 'none',cluster_cols = F)
dev.off()

pheatmap(assay(vsd)[topgene,],
         annotation_col = anno, main = 'Top 20 lowest p-adj gene list in potective allele patients', scale = 'none',cluster_cols = F)
dev.off()


