library(dplyr)

####################
#make into function#
####################


# still need to figure out how to inculde the bam location
setwd('~/Desktop/straglr_scoring_tool_for_long_read/MaternalPaternal/dataset3_bam_files/')
# using regex end with to match .bam file
bamlocation = list.files(full.names = F,pattern = '.bam$')

## loading snps list

snps = read.csv('../../toolinpus_and_HPRC_bams/ALL_snps_list_072722.csv')
snps$chrloc = paste0(snps$chr_location_hg38,'-',gsub('chr5:','',snps$chr_location_hg38))

ls.rsnumber = c(snps$SNPs)
chromosme_location = c(snps$chrloc)

#ls.rsnumber = c('rs3135867', 'rs2234909','rs3135886', 'rs3135890', 'rs61735104', 'rs3135899', 'rs2236786')
# chromosme_location = c("chr4:1799784-1799784",
#                       "chr4:1801977-1801977",
#                       "chr4:1803866-1803866",
#                       "chr4:1804792-1804792",
#                       "chr4:1804902-1804902",
#                       "chr4:1806796-1806796",
#                       "chr4:1717567-1717567")

#ls.rsnumber = c("rs2853677","rs7705526","rs7726159","rs2736100")

#chromosme_location = c('chr5:1287079-1287079','chr5:1285859-1285859','chr5:1282204-1282204','chr5:1286401-1286401')

# load the function

autocount =function(rs_number,pos){
  rsnumber = rs_number
  chr.locatoin = pos
  result = data.frame()
  for(i in bamlocation){
    system(paste0('igvtools count -w 1 --bases --query ',
                  chr.locatoin," ",i," ","res/",i,".wig"," ","hg38"))
    print('done igvtools count')
    # skip error while empty file generated (0 byte txt file can't be open using read.delim)
    tryCatch({
      ori = read.delim(paste0('res/',i,'.wig'),header = F,skip = 3)
      ori = ori[,c(1:5)]
      colnames(ori) = c('pos','A','C','G','T')
      # shorter the bam ID
      #ori$bam_ID = gsub('[A-z0-9]*_[A-z0-9]*_',"",i)
      k= gsub('.bam',"",i)
      ori$bam_ID = k
      ori = ori[,c(6,1:5)]
      result = rbind(result,ori)
    }, error=function(e) {cat("ERROR :",conditionMessage(e), "\n")}) # print out error message but loop cont
    
  }
  ## write a result 
  write.table(result,paste0('../',"datset3_",rsnumber,'_result.txt'),quote = F,sep = '\t',col.names = T,row.names = F)
  system(paste0('rm ','res/*'))
}


# maaply() can take two variable into function

mapply(autocount, ls.rsnumber, chromosme_location)


#################################################
# use for bam files within a list of folders ####
#################################################

folderlocation = list.files(full.names = F)


autocount2 =function(rs_number,pos){
  rsnumber = rs_number
  chr.locatoin = pos
  result = data.frame()
  for(i in bamlocation){
    system(paste0('igvtools count -w 1 --bases --query ',chr.locatoin," ",samname,"/",i," ",samname,"/res/",i,".wig"," ","hg38"))
    print('done igvtools count')
    # skip error while empty file generated (0 byte txt file can't be open using read.delim)
    tryCatch({
      ori = read.delim(paste0(samname,'/res/',i,'.wig'),header = F,skip = 3)
      ori = ori[,c(1:5)]
      colnames(ori) = c('pos','A','C','G','T')
      # shorter the bam ID
      #ori$bam_ID = gsub('[A-z0-9]*_[A-z0-9]*_',"",i)
      ori$bam_ID = gsub('.bam',"",i)
      ori = ori[,c(6,1:5)]
      result = rbind(result,ori)
    }, error=function(e) {cat("ERROR :",conditionMessage(e), "\n")}) # print out error message but loop cont
    
  }
  ## write a result 
  write.table(result,paste0('~/Desktop/ResSNPsallread/',rsnumber,'_',samname,'_result.txt'),quote = F,sep = '\t',col.names = T,row.names = F)
  system(paste0('rm ',samname,'/res/*'))
}


for(j in folderlocation){
  samname = j
  #print(samname)
  bamlocation = list.files(j,full.names = F,pattern = '.bam$')
  mapply(autocount2, ls.rsnumber, chromosme_location)
} 
