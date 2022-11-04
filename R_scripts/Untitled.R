###########################################################
## R script for making huge data from list of text files ##
###########################################################

setwd('~/Desktop/straglr_scoring_tool_for_long_read/toolinpus_and_HPRC_bams/final_MaternalPaternal_seqs_for_analysis/repeat_res/')

ref = read.delim('clp_target_hg38_2.bed',header = F)


filenames <- list.files(pattern = "*.tsv")
data2=lapply(filenames, read.delim2, header=T, skip=1)
for (i in 1:length(data2)){
  data2[[i]]<-cbind(data2[[i]],filenames[i])}

# combined all the files into one dataset
# do.call() == constructs and executes a function call from a name or a function
# and a list of arguments to be passed to it.
data_rbind <- do.call("rbind", data2)


