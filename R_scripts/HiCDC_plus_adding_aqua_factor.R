setwd('/Users/leec20/Desktop/HiCHIP_project/hicdcplus/')
library(HiCDCPlus)
library(DESeq2)

# Construct features from RE, Arima as example

output = getwd()
# construct once, after taht just load into gi_list showed below, use 5k bin
construct_features(output_path=paste0(output,'/','hg19_allchr_arima_chr7_chr9'),
                   gen="Hsapiens",gen_ver="hg19",
                   sig=c("GATC","GANTC"),bin_type="Bins-uniform",
                   binsize=5000,chrs = c('chr7','chr9'),
                   wg_file=NULL)

# creating gi_list from  a bintolen file above 
gi_list<-generate_bintolen_gi_list(bintolen_path='hg19_allchr_arima_bintolen.txt.gz')
head(gi_list)
# add counts to  gi_list instance using dedicated functions for each input Hi-C file format
# for HiC-pro, the code example: 
gi_list = add_hicpro_allvalidpairs_counts(gi_list,
  allvalidpairs_path = '../Mai_triplicates_AllValidPairs/Sample_SC863690-CGATGT.allValidPairs',
  chrs = NULL,
  binned = TRUE,
  add_inter = F
)
# expand feature for modeling 
gi_list<-expand_1D_features(gi_list)
# can chage the value in huge output list
#gi_list$chr1@elementMetadata$D = gi_list$chr1@elementMetadata$D * 3

## finding counts is in each chr in metalist 
# gi_list[["chr1"]]@elementMetadata$counts
# change all the chr count
#gi_list[["chr1"]]@elementMetadata$counts = gi_list[["chr1"]]@elementMetadata$counts * 5
#for (x in c(paste0('chr',1:22))){
#  
#  print(head(gi_list[[x]]@elementMetadata$counts))
#  gi_list[[x]]@elementMetadata$counts = gi_list[[x]]@elementMetadata$counts * 5
#  print(paste0('after scale: ',head(gi_list[[x]]@elementMetadata$counts)))
#}
set.seed(1010) #HiC-DC downsamples rows for modeling
gi_list<-HiCDCPlus(gi_list) #HiCDCPlus_parallel runs in parallel across ncores
head(gi_list)

# write normalized counts (observed/expected) to a .hic file
hicdc2hic(gi_list,hicfile='mai_46_test.hic',
mode='raw',gen_ver='hg19')
#write results to a text file
gi_list_write(gi_list,fname='okokokok',rows = 'significant')

tt = read.delim2('okokokok')

##########################################################################################
# for mouse validpair analysis
# add_hicpro_matrix_counts() is also an option

construct_features(output_path=paste0(output,'/','mm10_allchr_arima'),
                   gen="Mmusculus",gen_ver="mm10",
                   sig=c("GATC","GANTC"),bin_type="Bins-uniform",
                   binsize=50000,
                   wg_file=NULL)

# creating gi_list from  a bintolen file above 

gi_list_mm10<-generate_bintolen_gi_list(bintolen_path='mm10_allchr_arima_bintolen.txt.gz')
head(gi_list_mm10)

# add counts to  gi_list instance using dedicated functions for each input Hi-C file format
# for HiC-pro, the code example: 

gi_list_mm10 = add_hicpro_allvalidpairs_counts(gi_list_mm10,
                                          allvalidpairs_path = 'sc_mai_mm10.allValidPairs',
                                          chrs = NULL,
                                          binned = TRUE,
                                          add_inter = F
)

# expand feature for modeling 

gi_list_mm10<-expand_1D_features(gi_list_mm10)



set.seed(1010) #HiC-DC downsamples rows for modeling
gi_list_mm10<-HiCDCPlus(gi_list_mm10) #HiCDCPlus_parallel runs in parallel across ncores
head(gi_list_mm10)

# write normalized counts (observed/expected) to a .hic file
hicdc2hic(gi_list_mm10,hicfile='mm10_mai_46_test.hic',
          mode='normcounts',gen_ver='mm10')

#write results to a text file
gi_list_write(gi_list_mm10,fname='mm10_gslist_result.txt',rows = 'significant')






###############################################################
##      differiental analysis between triplicate            ##
###############################################################

# in Aqua paper,  after normalized they apply aqua-factor   
# sparse2full to create hic file 
# index file is for filtering during hicdcdiff() 

# Data == Mai human cell triplate with UV/no-UV 
# sample name:
# 90-92 control no_UV
# 93-95 UV_8hr

lsfile = list.files('~/Desktop/HiCHIP_project/Mai_triplicates_AllValidPairs',full.names = T)

indexfile = data.frame()
indexfile.alltrack = data.frame()

for (j in lsfile){
  output = paste0(gsub("^(.*[\\/_])","",j),'done.txt.gz')
  hicoutput = paste0(gsub("^(.*[\\/_])","",j),'.hic')
  gi_list = generate_bintolen_gi_list(bintolen_path='hg19_allchr_arima_chr7_chr9_bintolen.txt.gz',
                                      gen="Hsapiens",gen_ver="hg19",chrs = c('chr7','chr9'))
  print('finishing_genrated_bintolen')
  gi_list = add_hicpro_allvalidpairs_counts(gi_list, allvalidpairs_path = j,
                                            chrs = c('chr7','chr9'),binned = TRUE,add_inter = F)
  gi_list<-expand_1D_features(gi_list)
  print('finishing_HicPro count and 1D')
  set.seed(1010)
  gi_list<-HiCDCPlus(gi_list,ssize=0.1)
  # bleow code actually is :
  # 1. select row that qvalue <= 0.05  in data.frame(gi_list[[x]]) , x is from chr1 , chr2 ... chrx
  # 2. extract column name ''seqnames1','start1','start2'' in each dataframe
  # 3. combine all the data into final one with unique()  fuction
  for (i in seq(length(gi_list))){
   indexfile<-unique(rbind(indexfile,as.data.frame(gi_list[[i]][gi_list[[i]]$qvalue<=0.05])[c('seqnames1','start1','start2')]))
    indexfile.alltrack <-unique(rbind(indexfile.alltrack,as.data.frame(gi_list[[i]][gi_list[[i]]$qvalue<=0.05])[c('seqnames1','start1','start2','seqnames2','end1','end2')]))
  }
  gi_list_write(gi_list,fname=output)
  #hicdc2hic(gi_list,hicfile=hicoutput, mode='normcounts',gen_ver='hg19')
  print(paste0('complete of sample:',j))
}

#save index file---union of significants at 50kb
colnames(indexfile.alltrack)<-c('chr1','startI','startJ','chr2','endI','endJ')
data.table::fwrite(indexfile.alltrack,'Mai_triplicate_index_chr7_9_with_end2',sep='\t',row.names=FALSE,quote=FALSE)

colnames(indexfile)<-c('chr','startI','startJ')
data.table::fwrite(indexfile,'Mai_triplicate_index_chr7_9',sep='\t',row.names=FALSE,quote=FALSE)


#############################################
##     HICDCDIFF using Deseq2 analysis     ##
#############################################


#Differential analysis using modified DESeq2 (see ?hicdcdiff)
hicdcdiff(input_paths=list(non_UV=c('SC863690-CGATGT.allValidPairsdone.txt.gz','SC863691-ATCACG.allValidPairsdone.txt.gz','SC863692-GGCTAC.allValidPairsdone.txt.gz'),
UV=c('SC863693-TGACCA.allValidPairsdone.txt.gz','SC863694-GCCAAT.allValidPairsdone.txt.gz','SC863695-CAGATC.allValidPairsdone.txt.gz')),
filter_file='Mai_triplicate_index_chr7_9',
output_path='diff_analysis_example/', fitType = 'mean', binsize=5000, diagnostics=TRUE)

## look the diff result and make a text with all chr with
# remove empty padj and padj  < 0.05 value

diffresult = list.files('diff_analysis_example', full.names = T)

res = read.delim2('diff_analysis_example/diff_resUVovernon_UV_chr7.txt.gz')
# remove empty padj and select padj value
wholechr = data.frame()
for (i in diffresult){
  ff = read.delim2(i)
  ff = subset(ff,padj != "" & padj <= 0.05)
  wholechr = rbind(wholechr,ff)
  print('done!!')
}

res = subset(res,padj != "" & padj <= 0.05)
# remake the index file to the loop format

# load the original index 
ori.ind = read.delim2('Mai_triplicate_index_chr7_9')
# load the whole index 
md.ind = read.delim2('Mai_triplicate_index_chr7_9_with_end2')
#colname change
colnames(md.ind) = c('chr','startI','startJ','chr2','endI',"endJ" )

# use dplyr 
library(dplyr)

fin = dplyr::inner_join(res,md.ind, by = c('chr','startI','startJ'))
fin = fin[,c(1:3,10:12,4:9)]
fin = fin[,c(1,2,5,4,3,6,7:12)]
write.table(fin,'~/Desktop/whole_chr7_diff_1D.txt',sep = '\t',quote = F,col.names = T,row.names = F)



###############################
# make into WASHU loop format##
###############################


res = read.delim2('~/Desktop/whole_chr7_diff_1D.txt')
res = res[,c(1:6,8)]
res$col2 = paste0(res$chr2,':',res$startJ,'-',res$endJ,",",res$log2FoldChange)
res$tag = c(1:nrow(res))
res$name = '.'
res = res[,c(1:3,8,9,10)]
write.table(res,'~/Desktop/diff_HicDC_res_chr7_padj_0.05.bed',quote = F,col.names = F,row.names = F,sep = '\t')

##########################################################################################
##########################################################################################

# HOW TO CONVERT bepde/loop txt to UCSC long-range txt format
# read the output file and convert to bedpe or UCSC track

f1 = read.delim('gslist_result.txt')
# what's D? --> genomic distance D 
#?HiCDCPlus
f2 =read.delim('SC829846.5k.2.sig3Dinteractions_for_ref.bedpe')


##  Arima_MAPS output as reference
## change format from bedpe file to UCSC biginteract format
# the arcplot format will be double row compare to bedpe file, since it just report both direction

exp = read.delim2('~/Desktop/UCSC_interaction_file/T24/T24_16000_bait_all_scored_colored.txt',header = T,skip = 1)
file= read.delim2('Output/MAPS_output/Arima-MAPS-test_20210930_111755/Arima-MAPS-test.5k.2.sig3Dinteractions.bedpe')
other = read.delim2('Output/arcplot_and_metaplot/Arima-MAPS-test.5k.2.arcplot.txt',header = F)

file = file[,c(1:6,10,13)]
file$bait_name = file$ClusterLabel
file$score = round(as.numeric(file$ClusterNegLog10P))
file$value = file$ClusterNegLog10P
file$Exp = "."
file$color = '#FF0000'
file$sourceName = '.'
file$sourceStrand = '.'
file$targetChrom = file$X.chr1
file$targetStart = file$start1
file$targetEnd = file$end1
file$targetName = file$ClusterLabel
file$targetStrand = '.'

file1 = file[,c('X.chr1','start1','end1','ClusterLabel','score','value','Exp',"color",'chr2','start2','end2','sourceName','sourceStrand','targetChrom','targetStart','targetEnd','targetName','targetStrand')]
colnames(file1) = colnames(exp)

## change strong inteaction by color
chr = T24

for (i in 1:nrow(chr)) {
  score <- chr[i, "Score"]
  if(score >= 15) {
    chr[i,8] = '#A569BD'
  } else if (score < 15 & score >= 10 ) {
    chr[i,8] = '#BB8FCE'}
  else if (score < 10 & score >= 7 ) {
    chr[i,8] = '#D2B4DE'
  }else{
    chr[i,8] = '#E8DAEF'
  }
}

## write table
write.table(file1,file = 'test_arima_hichip.txt',quote = F,col.names = T,row.names = F,sep = '\t')

####
####????####
# ICE counts for the analysis??????

gi_list<-generate_bintolen_gi_list(bintolen_path='hg19_allchr_arima_bintolen.txt.gz')
gi_list<-add_hicpro_matrix_counts(gi_list,absfile_path='',matrixfile_path='',chrs=c("chr21","chr22")) 
set.seed(1010) #HiC-DC downsamples rows for modeling
gi_list<-HiCDCPlus(gi_list) #HiCDCPlus_parallel runs in parallel across ncores
head(gi_list)
#write results to a text file
gi_list_write(gi_list,fname='okokokok',rows = 'significant')
tt = read.delim2('okokokok')


