
the [Script](file:/Users/leec20/Desktop/scripts/R_scripts/combine_straglr_tsv_res_to_igvtool_genotyped_with_basic_merge.R)

```

###################################
# For the list of rsxxx.txt file  #
###################################

setwd('~/Desktop/TERT_R2_project/TERT_CLP_Pacbio_PCR_for_QPCR/TERT_R2_031523/set2_Binned_snps_scoring/')
ff <- list.files('.',pattern = '.txt')
df <- data.frame()

# need to modify column number when use! 

for (x in ff){
  tar <- read.delim(x)
  tar$snpid <- gsub('_.*','',x)
  tar$bam_ID <- gsub('_hg37.+','',tar$bam_ID)
  tar <- tar[,c(1,7,2,3,4,5,6)]
  df <- rbind(df,tar)
}



for (i in 1:nrow(df)){
  df$tot[i] <- sum(df[i,c(4:7)])
}

# remove row of total reads = 0 

for (x in 1:nrow(df)) {
  if (!is.na(df$tot[x]) && df$tot[x] == 0) {
    df <- df[-x, ]
  }
}


for (x in 1:nrow(df)){
  for (y in 4:7){
    if(as.numeric(df[x,y])/df$tot[x] > 0.1)
    {df[x,y] <- gsub('','',names(df)[y])} else {
      df[x,y] <- ""
      }
  }
}


df <- df[,-8]

df$snpid <- paste0(df$snpid,'_chr5:',df$pos)
df <- df[order(df$pos),]

f = df %>% group_by(pos) %>% tidyr::unite(col = target,c(4:7),na.rm = T,sep = '')
f <- f[,-3]

# make A to AA 

for (x in 1:nrow(f)){
  if(f$target[x] %in% c('A','T','C','G'))
  {f$target[x] <- paste0(f$target[x]," ",f$target[x])}
  if (f$target[x] %in% c('AG','CT','AC')){
    f$target[x] <- gsub("([[:alpha:]])([[:alpha:]])", "\\1 \\2", f$target[x])}
  }


# tansfrom dataset 
df.wide <- tidyr::pivot_wider(f, names_from = snpid, values_from = target)

# change C to C C for convience 
#
#for (x in 1:nrow(df.wide)){
#  for (y in 2:13){
#    if(df.wide[x,y] %in% c('A','T','C','G'))
#    {df.wide[x,y] <- paste0(df.wide[x,y]," ",df.wide[x,y])} 
#  }}
#
#patterns <-c("CT","AG","AC")#
#
#for (col in colnames(df.wide)[-1]) {
#  for (pattern in patterns) {
#    df.wide[[col]] <- gsub(pattern, paste(strsplit(pattern, "")[[1]], collapse = " "), df.wide[[col]])
#  }
#}

```
