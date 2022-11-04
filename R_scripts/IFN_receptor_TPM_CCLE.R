library(dplyr)

#
setwd('~/Desktop/')
#load file of TPM in CCLE 21Q2 dataset (log2(TPM+1))
ccle = read.csv('CCLE_TPM_Expression_21Q2_Public.csv')
# remove column 1,3,4,5,6
ccle = ccle[,-c(1,3,4,5,6)]

#Cell line of intrest
cell = c('SCABER','HT1376', 'HBLAK', 'T24', 'RT4',  'TCCSUP','PC3','HEPG2')
#gene of interest
gene.list = c('IFNLR1','IL10RA','IL10RB')


#use dplyr filter() to filter the dataset by cell list
res = ccle %>% filter(cell_line_display_name %in% cell)
# extract the gene of intrest
res = res[,c("cell_line_display_name",gene.list)]
# svae the result to txt file
write.table(res,'cell_line_logTPM.txt',col.names = T,row.names = F,quote = F,sep = '\t')
