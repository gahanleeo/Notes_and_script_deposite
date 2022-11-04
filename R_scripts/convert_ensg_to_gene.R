library("biomaRt")
library("dplyr")

count = read.delim2('Desktop/GSE161731_counts_pbid.txt')

group=factor(c("early","middle","late"))
design(dds) = ~ group

coldata <- colData(gse)
d = cpm(count,log = T)
d = as.data.frame(d)

mart <- useDataset("hsapiens_gene_ensembl", useMart("ensembl"))
genes <-  count$Gene
gene_IDs <- getBM(filters= "ensembl_gene_id", attributes= c("ensembl_gene_id","hgnc_symbol"),
                  values = genes, mart= mart)

c1 = left_join(count, gene_IDs, by = c("Gene"="ensembl_gene_id"))
c1 = c1[,c(197,1:196)]

c1 = subset(c1,hgnc_symbol !="")
c1 = c1[,-2]
write.table(c1,'Desktop/IDwithcount.txt',sep = '\t',quote = F,col.names = T,row.names = F)
