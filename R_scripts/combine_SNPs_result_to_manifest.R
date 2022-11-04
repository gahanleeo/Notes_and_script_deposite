## script for SNPs genotyping ##
library(dplyr)

# snps and location in hg38
ls.rsnumber = c('rs3135867', 'rs2234909','rs3135886', 'rs3135890', 'rs61735104', 'rs3135899', 'rs2236786')

chromosme_location = c("chr4:1799784-1799784",
                       "chr4:1801977-1801977",
                       "chr4:1803866-1803866",
                       "chr4:1804792-1804792",
                       "chr4:1804902-1804902",
                       "chr4:1806796-1806796",
                       "chr4:1717567-1717567")

## load the csv manifest; set working dic
setwd('~/Desktop/FGFR3_eccDNA_project/TCGA_BLCA_bam_files/')
f1 = read.delim2('all_BLCA_850_info_for_R.csv',sep = ',')

## load the genotyping result
lis.snp  = list.files('.',pattern = ".txt")

for (i in lis.snp){
  s.res = read.delim2(i)
  snps = gsub("_result.txt","",i)
  colnames(s.res) = c('File.Name',snps,'A','C','G','T')
  f1 = dplyr::left_join(f1,s.res,by='File.Name')

}

# hard to check on R 
write.table(f1,'comb_snps.txt',col.names = T,row.names = F,quote = F,sep = '\t')

