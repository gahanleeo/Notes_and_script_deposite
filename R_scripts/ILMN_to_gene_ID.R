
# load library
library(illuminaHumanv3.db)
library(dplyr)

setwd('~/Desktop/')

t1 = read.delim('MIBC_pati_GSTM1/89_MDA_FFPE_dataset/GSE86411_89_FFPE_exp.txt')
t2 = read.delim('MIBC_pati_GSTM1/AD_and_Lund/Aderson/original_data/GSE48075_patient_expression_matrix_with_geneID.txt')


id = read.delim('MIBC_pati_GSTM1/AD_and_Lund/GPL14951-11332.txt')
id2 = id[,c(1,12)]

colnames(t1)[1] = 'gene_ID'

colnames(id2)[1] = 'gene_ID'

cob = dplyr::inner_join(t1, id2, by = "gene_ID")
# remove NA in genotype
# cob = cob[rowSums(is.na(cob[,1:2])) == 0, ]
cob=cob[,c(1,134,2:133)]



# select GSTM1 expression

GSTM = dplyr::filter(cob, Symbol == 'GSTM1')
write.table(GSTM,'MIBC_pati_GSTM1/89_MDA_FFPE_dataset/89_GSTM.txt',row.names = F,col.names = T,quote = F,sep = '\t')

