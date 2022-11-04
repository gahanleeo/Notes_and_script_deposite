setwd('~/Desktop/tandam_repeat_analysis_BLCA_30_WGS/')

f1 = read.delim('res_igv_tandcount/combined_result.txt',header = F)
# seperate row into new column  by sample number

df <- data.frame(V1=matrix(f1$V1, nrow =30), V2=matrix(f1$V2, nrow =30))

# get column order right
# since it's 27 tandem repeat

number_of_bed= 25
newdf = matrix() # kind of wierd

for(i in seq(1:number_of_bed)){
  set1 = i
  set2 = i + number_of_bed
  newdf = cbind(newdf, df[,c(set1,set2)])# this need fix 
}
newdf = newdf[,-1]



##############
#  function  #
#############

autoarr = function(samplenumber,number_of_bed_list){
  f1 = read.delim('res_background/combined_result.txt',header = F)
  df <- data.frame(V1=matrix(f1$V1, nrow = samplenumber), V2=matrix(f1$V2, nrow = samplenumber))
  newdf = matrix()
  for(i in seq(1:number_of_bed_list)){
    set1 = i
    set2 = i + number_of_bed_list
    newdf = cbind(newdf, df[,c(set1,set2)])# this need fix 
  }
  newdf = newdf[,-1]
  write.table(newdf,'~/Desktop/test.txt',quote = F,col.names = F,row.names = F,sep = '\t')
}


#######
#modified column so that it can get faster 
#######

f1 = read.delim('~/Desktop/cell.txt',header = F)
ss = seq(2,50,by=2)
s = seq(1,50,by=2)
cname=newdf[1,c(s)]
c1 = gsub('_[A-z0-9]+_sorted.bam.wig',"",cname)
c1
f2 = newdf[,c(ss)]
colnames(f2) = c1
write.table(f2,'~/Desktop/md.txt',col.names = T,row.names = F,quote = F,sep = '\t')

###  1000 genome 76 sample slection 
# select uniqe rows from duplication samples


f1 = read.delim2('~/Desktop/76_1000.txt')
f2 = subset(f1,f1$Instrument == 'Sequel II')
f3 = f2 %>% distinct(Isolate, .keep_all = TRUE)
