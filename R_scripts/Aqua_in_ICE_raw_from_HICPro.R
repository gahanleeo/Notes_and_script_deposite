# Compare two output for with aqua-factor or not
# Chr7 ONLY
# Aqua == 6


setwd('/Users/leec20/Desktop/HiCHIP_project/hicdcplus/')
library(HiCDCPlus)
library(DESeq2)

# Construct features from RE, Arima as example

output = getwd()
# construct once, after taht just load into gi_list showed below, use 5k bin
construct_features(output_path=paste0(output,'/','hg19_allchr_arima_chr7'),
                   gen="Hsapiens",gen_ver="hg19",
                   sig=c("GATC","GANTC"),bin_type="Bins-uniform",
                   binsize=5000,chrs = c('chr7'),
                   wg_file=NULL)


###############################
# ICE counts for the analysis#
###############################

#ICE count with out Aqua#

gi_list<-generate_bintolen_gi_list(bintolen_path='hg19_allchr_arima_chr7_bintolen.txt.gz')
gi_list<-add_hicpro_matrix_counts(gi_list,absfile_path='../hic_pro/5000/fastq_SC829848_5000_abs.bed',matrixfile_path='../hic_pro/ICED/5000/fastq_SC829848_5000_iced.matrix',chrs=c("chr7")) 
set.seed(1010) #HiC-DC downsamples rows for modeling
gi_list<-HiCDCPlus(gi_list) #HiCDCPlus_parallel runs in parallel across ncores
head(gi_list)
#write results to a text file
gi_list_write(gi_list,fname='../Aqua_factor_with_HiCPro_matrix_output/chr7_iced_sig.txt',rows = 'significant')

#ICE count with Aqua#

gi_list<-generate_bintolen_gi_list(bintolen_path='hg19_allchr_arima_chr7_bintolen.txt.gz')
gi_list<-add_hicpro_matrix_counts(gi_list,absfile_path='../hic_pro/5000/fastq_SC829848_5000_abs.bed',matrixfile_path='../hic_pro/ICED/5000/fastq_SC829848_5000_iced_withAQUA.matrix',chrs=c("chr7")) 
set.seed(1010) #HiC-DC downsamples rows for modeling
gi_list<-HiCDCPlus(gi_list) 

#write results to a text file
gi_list_write(gi_list,fname='../Aqua_factor_with_HiCPro_matrix_output/chr7_iced_AQUA_sig.txt',rows = 'significant')

####################
#compare two result#
####################

r1 = read.table('../Aqua_factor_with_HiCPro_matrix_output/chr7_iced_sig.txt',header = T,stringsAsFactors = F)
r1 = subset(r1,qvalue < 0.01)
r1.aqua = read.table('../Aqua_factor_with_HiCPro_matrix_output/chr7_iced_AQUA_sig.txt',header = T,strip.white = F)
r1.aqua = subset(r1.aqua,qvalue < 0.01)


#raw count w/ or w/o Aqua#
#raw count with out Aqua#

ff = c('../hic_pro/5000/fastq_SC829848_5000.matrix','../hic_pro/5000/fastq_SC829848_5000_AQUA.matrix')
bedf = ('../hic_pro/5000/fastq_SC829848_5000_abs.bed')

for (i in ff){
  filename = paste0(gsub("../hic_pro/5000/fastq_","",i),'.done.txt')
  gi_list<-generate_bintolen_gi_list(bintolen_path='hg19_allchr_arima_chr7_bintolen.txt.gz')
  gi_list<-add_hicpro_matrix_counts(gi_list,absfile_path=bedf,matrixfile_path= i ,chrs=c("chr7")) 
  set.seed(1010) 
  gi_list<-HiCDCPlus(gi_list)
  gi_list_write(gi_list,fname=paste0('../Aqua_factor_with_HiCPro_matrix_output/',filename),rows = 'significant')
  
  
}


#raw count with Aqua#

gi_list<-generate_bintolen_gi_list(bintolen_path='hg19_allchr_arima_chr7_bintolen.txt.gz')
gi_list<-add_hicpro_matrix_counts(gi_list,absfile_path='../hic_pro/5000/fastq_SC829848_5000_abs.bed',matrixfile_path='../hic_pro/ICED/5000/fastq_SC829848_5000_iced_withAQUA.matrix',chrs=c("chr7")) 
set.seed(1010) #HiC-DC downsamples rows for modeling
gi_list<-HiCDCPlus(gi_list) 

#write results to a text file





###############################
# raw for the analysis#
###############################
