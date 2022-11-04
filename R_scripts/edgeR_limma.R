library(limma)
library(Glimma)
library(edgeR)
library(RColorBrewer)
library(dplyr)

setwd('~/Desktop/')

f1 = read.delim2('Duke_PBMC_PRJNA679264/Duke_PBMCs/multime_ID_rawcount.txt')
row.names(f1) = make.names(f1$hgnc_symbol, unique=TRUE)
f1 = f1[,-1]

datainf = read.delim2('Duke_PBMC_PRJNA679264/Duke_PBMCs/OAS1_TPM_14pati_for_plot.txt')

# get info
info = datainf %>% filter(Sample_ID %in% colnames(f1))
# get the protect and risk alelle patients
##'', 0E1F8E,FA9A61
pat.pro.risk = c('0D76FC', '0E1F8E','FA9A61','450905','82CCF5')
#patient.med.risk = c('180E1A','1A9B20','318281','35D90D','7085CA', 'C90C79','E4B8AD')
# remove the outliner
info.pro.risk = info %>% filter(Subject_ID %in% pat.pro.risk)

# get target
target = c(paste0('PB','_',c(10,11,12,13,14,15,16,39,40,27,28,29,47,48,49,63,64,65)))
# get pro vs risk in late # 40, 48,49, out
target = c(paste0('PB','_',c(16,40,27,63)))
# get pro vs risk in early
target = c(paste0('PB','_',c(10,11,13,28,65)))

# reorder the info 
info = info[match(target, info$Sample_ID),]
## extract the rawcount with this order
f2 = select(f1,target) 


## use f2 to creat DGElist
group = as.factor(info$allele)
subid = as.factor(info$Subject_ID)
x  = DGEList(f2,group = group)
x$samples$sjid = subid
cpm = cpm(x)
#log2 scale 
lcpm <- cpm(x, log=TRUE)

keep.exprs <- filterByExpr(x)
x <- x[keep.exprs,,keep.lib.sizes=FALSE]
x <- calcNormFactors(x)

design <- model.matrix(~group)

x <- estimateDisp(x,design)

x$common.dispersion
plotBCV(x)

fit <- glmFit(x, design)
lrt <- glmLRT(fit)
topTags(lrt)
summary(decideTests(lrt))
plotMD(lrt)
abline(h=c(-1, 1), col="blue")

## GO term 
go <- goana(lrt)
topGO(go, ont="BP", sort="Up", n=30, truncate=30)





###



# check normalized data
x <- calcNormFactors(x, method = "TMM")
x$samples$norm.factors

boxplot(lcpm, main="")
title(main="B. Example: Normalised data",ylab="Log-cpm")

#plotMDS to clustering samples


par(mfrow=c(1,2)) # Create a 1 x 2 plotting matrix, 
#that's why the plot can contain two figures in one plot

# PCA plot PB_40 is outliner 
col.group <- group
levels(col.group) <-  brewer.pal(nlevels(col.group), "Set1")
col.group <- as.character(col.group)
col.lane <- subid
col.lane <- brewer.pal(nlevels(col.group), "Set2")
col.lane <- as.character(col.lane)
plotMDS(lcpm, labels=group,col=col.group)
title(main="A. Sample groups")
plotMDS(lcpm, labels=subid, col=col.lane)
title(main="B. Sequencing lanes")


# finally, the Differentatilly analysis

design <- model.matrix(~0+group)
colnames(design) <- gsub("group", "", colnames(design))
design

# creating own contrast, the variable need to be in the design
contr.matrix <- makeContrasts(
    Protvsrisk = protect-risk,
    levels = colnames(design))

contr.matrix

## Vomm limma
v <- voom(x, design, plot=TRUE)
v
vfit <- lmFit(v, design)
vfit <- contrasts.fit(vfit, contrasts=contr.matrix)
efit <- eBayes(vfit)
plotSA(efit, main="Final model: Mean-variance trend")

summary(decideTests(efit))

tfit <- treat(vfit, lfc=1)
dt <- decideTests(tfit)
summary(dt)

de.common <- which(dt[,1]!=0)
length(de.common)


# Examining individual DE genes from top to bottom
#the coef is based on the contrast.marix
# 1 means first column design: Protvsrisk = protect-risk
# 2 is the second design: RisvsPro = risk-protect

res1 <- topTreat(tfit, coef=1, n=Inf)
res2 <- topTreat(tfit, coef=2, n=Inf)
head(basal.vs.lp)

# volca plot

plotMD(tfit, column=1, status=dt[,1], main=colnames(tfit)[1], 
       xlim=c(-8,13))

# heatmap

library(gplots)
basal.vs.lp.topgenes <- res1$gene[1:20]
i <- which(rownames(v$E) %in% basal.vs.lp.topgenes)
mycol <- colorpanel(1000,"blue","white","red")
heatmap.2(lcpm[i,], scale="row",
          labRow=v$genes$SYMBOL[i], labCol=group, 
          col=mycol, trace="none", density.info="none", 
          margin=c(8,6), lhei=c(2,10), dendrogram="column")

