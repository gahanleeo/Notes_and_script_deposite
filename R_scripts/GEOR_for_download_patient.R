################################################################
#   Data plots for selected GEO samples
library(GEOquery)
library(limma)
library(umap)
library(dplyr)

# load series and platform data from GEO
# no idea what this, but it work
Sys.setenv("VROOM_CONNECTION_SIZE" = 262144*1000)
# load
gse <- getGEO("GSE87304", GSEMatrix =T, getGPL=FALSE)
if (length(gse) > 1) idx <- grep("GPL22995", attr(gse, "names")) else idx <- 1
gse <- gse[[idx]]

show(gse)
names(GSMList(gse))

GSMList(gse)[[1]]





# find the sample table
t1 = gse@phenoData@data
# write.table
write.table(t1,'Desktop/MIBC_pat_info.txt',sep = '\t', quote = F, col.names = T,row.names = F)

ex <- exprs(gse)

# log2 transform
qx <- as.numeric(quantile(ex, c(0., 0.25, 0.5, 0.75, 0.99, 1.0), na.rm=T))
LogC <- (qx[5] > 100) ||
  (qx[6]-qx[1] > 50 && qx[2] > 0)
if (LogC) { ex[which(ex <= 0)] <- NaN
ex <- log2(ex) }




library(frma)
library(AnnotationDbi)
library(oligo)
library(frma)
library(pd.huex.1.0.st.v2)
library(huex10sttranscriptcluster.db)
huex10sttranscriptcluster.db

setwd('~/Desktop/')


celFiles = list.celfiles('test_CEL', full.names=TRUE,listGzipped = T)
raw = read.celfiles(celFiles)

res = rma(raw)

object <- frma(raw)
bc <- barcode(object,platform =  )

e <- as.data.frame(exprs(object))

t1 <- as.data.frame(exprs(eset))
t1$ID = row.names(t1)

my_frame <- data.frame(exprs(eset))

Annot <- data.frame(ACCNUM=sapply(contents(huex10sttranscriptclusterACCNUM), paste, collapse=", "), 
                    SYMBOL=sapply(contents(huex10sttranscriptclusterALIAS2PROBE), paste, collapse=", "),
                    DESC=sapply(contents(huex10sttranscriptclusterGENENAME), paste, collapse=", "))

all <- merge(Annot, my_frame, by.x=0, by.y=0, all=T)
