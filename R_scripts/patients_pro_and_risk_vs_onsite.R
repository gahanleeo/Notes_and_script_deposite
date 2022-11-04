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
pat.pro.risk = c('0D76FC','FA9A61', '0E1F8E','450905','82CCF5')
#patient.med.risk = c('180E1A','1A9B20','318281','35D90D','7085CA', 'C90C79','E4B8AD')
# remove the outliner
info.pro.risk = info %>% filter(Subject_ID %in% pat.pro.risk)
info = info.pro.risk[,c(7,5,10)]
#
#
# reorder the f1 !!!! the order will effect the result!!!!!!! 
#Should match with row of colData!!!
# no PB_48, PB_49
target = c(paste0('PB','_',c(10,11,13,14,15,39,16,40,28,65,29,64,27,63)))
# get pro vs risk in late # no 40
target = c(paste0('PB','_',c(12,16,27,63,48,49)))
# get pro vs risk in early
target = c(paste0('PB','_',c(10,11,13,28,65)))
#
#
#

# reorder the info 
info = info[match(target, info$Sample_ID),]
## extract the rawcount with this order
f2 = select(f1,target) 
## get one specific patient_set
#target = c(paste0('PB','_', c(10:16)))
#f1 = select(f1,target) 

colnames(info) = c('ID','condition','allele')
coldata = info

# convert to factor 
coldata$ID = factor(coldata$ID)
coldata$condition =  factor(coldata$condition)
coldata$allele  = factor(coldata$allele, levels = c('protect','risk'))
## dds creat
dds <- DESeqDataSetFromMatrix(countData = f2,
                              colData = coldata,
                              design = ~ allele)


##
# pre-filter

nrow(dds)

keep <- rowSums(counts(dds)) > 1
dds <- dds[keep,]
nrow(dds)

# run
dds = DESeq(dds)
res <- results(dds)

res <- results(dds,contrast=c("condition","late","protect"))
#res = results(dds, name = 'allele_risk_vs_protect')

resultsNames(dds)
#t1 = as.data.frame(res)
resLFC <- lfcShrink(dds, coef="condition_late_vs_early" , type="apeglm")
resLFC

###transformation
###
###
library("dplyr")
library("ggplot2")

vsd <- vst(dds, blind = FALSE)
rld <- rlog(dds, blind = FALSE)

dds <- estimateSizeFactors(dds)

df <- bind_rows(
  as_data_frame(log2(counts(dds, normalized=TRUE)[, 1:2]+1)) %>%
    mutate(transformation = "log2(x + 1)"),
  as_data_frame(assay(vsd)[, 1:2]) %>% mutate(transformation = "vst"),
  as_data_frame(assay(rld)[, 1:2]) %>% mutate(transformation = "rlog"))

colnames(df)[1:2] <- c("x", "y")  

lvls <- c("log2(x + 1)", "vst", "rlog")
df$transformation <- factor(df$transformation, levels=lvls)

ggplot(df, aes(x = x, y = y)) + geom_hex(bins = 80) +
  coord_fixed() + facet_grid( . ~ transformation) 

## sample distance
sampleDists <- dist(t(assay(vsd)))
sampleDists

library("pheatmap")
library("RColorBrewer")

sampleDistMatrix <- as.matrix( sampleDists )
rownames(sampleDistMatrix) <- paste( vsd$ID, vsd$allele, sep = " - " )
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
pheatmap(sampleDistMatrix,
         clustering_distance_rows = sampleDists,
         clustering_distance_cols = sampleDists,
         col = colors)


## PCA plot

plotPCA(vsd, intgroup = c("ID", "allele"))

library("glmpca")
gpca <- glmpca(counts(dds), L=2)
gpca.dat <- gpca$factors
gpca.dat$ID <- dds$ID
gpca.dat$allele <- dds$allele
ggplot(gpca.dat, aes(x = dim1, y = dim2, color = ID, shape = allele)) +
  geom_point(size =3) + coord_fixed() + ggtitle("glmpca - Generalized PCA")

###
###
###
### export result with adjust pvaule (FDR) 
#DESeq2 uses the Benjamini-Hochberg (BH) adjustment 
resSig <- subset(res, padj < 0.1)
# top down-regulated
head(resSig[ order(resSig$log2FoldChange), ])
# top up-regulated 
head(resSig[ order(resSig$log2FoldChange, decreasing = TRUE), ])



# plot 

plotCounts(dds, gene="OAS1", intgroup="allele")


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
anno <- as.data.frame(colData(vsd)[, c("allele","condition")])
pheatmap(mat, annotation_col = anno)

### plot top gene with high padj, the paper used this method!
#model.matrix(~condition)


resSig <- subset(res, padj < 0.1)
p1 = as.data.frame(resSig)
p1$Gene = row.names(p1)
p1 = arrange(p1, padj)
topgene = p1$Gene[1:100]

anno <- data.frame(colData(dds)[,c("allele")])
colnames(anno) = 'allele'
rownames(anno) = as.data.frame(colData(dds))$ID
# cluster_cols = F will remove the cluster of column 
# scale = 'row' for transfrom to Z-score
# equal to :
#vsd <- assay(vst(dds))
#Z <- t(scale(t(vsd)))
m = counts(dds, normalized = TRUE)
Z = t(scale(t(m)))



pheatmap(Z[topgene,],
         annotation_col = anno,cluster_cols=T,scale = 'row',main = "The top 20 lowest padj gene")
dev.off()


## load two results
prt = read.delim('Duke_PBMC_PRJNA679264/plot_and_result/log2_late_vs_early_protect_allelle.txt')

risk = read.delim('Duke_PBMC_PRJNA679264/plot_and_result/log2_late_vs_early_risk_allelle.txt')

prt = arrange(prt, padj)
topgene = prt$Gene[1:20]

risk = arrange(risk, padj)
topgene = p1$Gene[1:20]

# top down-regulated
head(prt[ order(prt$log2FoldChange), ])

head(risk[order(risk$log2FoldChange), ])
# top up-regulated 
head(prt[ order(prt$log2FoldChange, decreasing = TRUE), ])




### enrich R for GO term onto

library(enrichR)
setEnrichrSite("Enrichr") 
websiteLive <- TRUE
dbs <- listEnrichrDbs()
if (is.null(dbs)) websiteLive <- FALSE
if (websiteLive) head(dbs)

## escape the dot ".", use \\.
topgene1 = gsub('\\.','-',topgene)

dbs <- c("GO_Biological_Process_2021", "COVID-19_Related_Gene_Sets", "KEGG_2021_Human",'MSigDB_Hallmark_2020')
if (websiteLive) {
  enriched <- enrichr(topgene1, dbs)
}
#result
if (websiteLive) enriched[["GO_Biological_Process_2021"]]
if (websiteLive) plotEnrich(enriched[[4]], showTerms = 20, numChar = 50, y = "Count", orderBy = "P.value")
#
#mat <- limma::removeBatchEffect(mat, batch=vsd$batch, design=mm)
