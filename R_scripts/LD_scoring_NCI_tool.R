library(LDlinkR)
library(dplyr)
library(sqldf)
library(tidyr)
library("stringr")

# Main site
# https://ldlink.nci.nih.gov/?tab=home
# how to get API 
# https://ldlink.nci.nih.gov/?tab=apiaccess
# tutorial 
# https://cran.r-project.org/web/packages/LDlinkR/vignettes/LDlinkR.html
#my token: c22a071b5bda

# list of SNPs of interest


############################
# based on hg38############
###########################

snp.ls = c('rs17863783',
            'rs10936599',
           'rs710521',
           'rs2896518', 
           'rs2242652',
           'rs6910215',
           'rs72826305',
           'rs2125484',
           'rs1495741',
            'rs5003154',
           'rs10094872',
           'rs2294008',
           'rs1414253',
           'rs4743687',
           'rs7076867',
           'rs907611',
           'rs7937265',
           'rs4907479',
           'rs10853535',
           'rs8102137',
           'rs411482',
           'rs62185668',
           'rs1014971')


rs = data.frame()

for(i in snp.ls){
  print(i)
  my_px = LDproxy(snp = i, pop = "EUR", r2d = "r2", token = "c22a071b5bda",genome_build = "grch38")
  my_px <- subset(my_px,R2 > 0.8)
  my_px$input_target_snp = i
  rs = rbind(rs,my_px)
  
}

rs.nw = rs[,c(11,1:10)]
rs.nw$chr = gsub(':[0-9]+','',rs.nw$Coord)
rs.nw$chr_location = gsub('chr[0-9]+:','',rs.nw$Coord)



# load Ensenbl GTF file_hg38

gtf_ens11 <- read.delim('~/Desktop/GWAS_ensembl_LD/Homo_sapiens.GRCh38.108.chr.gtf',sep = '\t',header = F,skip = 5)
# clean
colnames(gtf_ens) <- c('seqname', 'source', 'feature' ,'start' ,'end', 'score','strand','frame','attribute')

gtf_ens$seqname = paste0('chr',gtf_ens$seqname)
# clean attribute
# this function break attr into list, use %in% and which to get 'gene_id', +1 since gene_id is next list[x+1]
extract_attributes <- function(gtf_attributes, att_of_interest){
  att <- unlist(strsplit(gtf_attributes, " "))
  if(att_of_interest %in% att){
    return(gsub("\"|;","", att[which(att %in% att_of_interest)+1]))
  }else{
    return(NA)}
}
# lapply(x,FUN)
chr2_t_gtf$gene_id <- unlist(lapply(chr2_t_gtf$attribute, extract_attributes, "gene_id"))






# well... maybe it's working 

df_sql <- 
  sqldf::sqldf("SELECT a.*, b.*
               FROM chr2_t_gtf a
               LEFT JOIN snp2_t b 
               ON (a.start < b.chr_location and a.end > b.chr_location)")

# remove row according to NA in chr column  
df_sql  = df_sql[!is.na(df_sql$chr),]



########################################################################
# Another Option: make LD score SNPs into bed file and upload to UCSC ## 
########################################################################

# track name="ERU_LD_score" description="SNP_LD" visibility=2 itemRgb="On"	 

rs.nw 

