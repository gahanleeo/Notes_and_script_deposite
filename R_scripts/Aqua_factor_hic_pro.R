# HiC-pro cal Aqua-factors
# from Nat protocol 

### Set up project and samples
#setwd("~/Desktop/hic_pro/human_hg19/")
#project.title = "RH4_H3K27ac_HiChIP"
#project.folder = paste(project.title,"/HiCpro_OUTPUT/hic_results/data/",sep="")
project.folder = ('Desktop/HiCHIP_project/hic_pro/human_hg19/hic_results/stats/')

sample.list = list.dirs(path = project.folder, full.names = F,recursive = F)

# mouse mm10 folder location 
#project.title.mm10 = paste(project.title,"_mm10",sep="")
#project.folder.mm10 = paste(project.title.mm10,"/HiCpro_OUTPUT/hic_results/data",sep="")
project.folder.mm10 = ('Desktop/HiCHIP_project/hic_pro/mouse_mm10/hic_results/stats/')
sample.list.mm10 = list.dirs(path = project.folder.mm10, full.names = F, recursive = F)

### Obtain human read counts and spike in mouse read counts from HiC-pro output
mergestat.all = as.data.frame(read.table(paste(project.folder,sample.list[1],'/',sample.list[1],"_allValidPairs.mergestat",sep=""), sep="\t", header=F))
mergestat.all = as.data.frame(mergestat.all$V1)

##load and merge hg19 sample data
# basally just combine two exp of allValidPairs.mergestat into one table
lapply(sample.list, function(x) {
  mergestat <- read.table(paste(project.folder,"/",x,"/",x, "_allValidPairs.mergestat",sep=""), sep="\t", header=F)
  mergestat.sample = as.data.frame(mergestat[,2])
  removable.string = "Sample_" ; sample.name = gsub(removable.string,"",x)
  colnames(mergestat.sample) = c(sample.name)
  mergestat.all <<- cbind(mergestat.all,mergestat.sample) # <<- == appended, the list won't be replaced
})

##load and merge mm10 sample data
lapply(sample.list.mm10, function(x) {
  mergestat <- read.table(paste(project.folder.mm10,"/",x,"/",x, "_allValidPairs.mergestat",sep=""), sep="\t", header=F)
  mergestat.sample = as.data.frame(mergestat[,2])
  removable.string = "Sample_" ; sample.name = gsub(removable.string,"mm10_",x) 
  colnames(mergestat.sample) = c(sample.name)
  mergestat.all <<- cbind(mergestat.all,mergestat.sample) })

write.table(mergestat.all,"~/Desktop/hic_pro/mergestat.HiChIP.all.txt",sep="\t", col.names=T,row.names=F)

# Aqua factor cal: "the ratio of human:mouse unique and valid contact pairs for a given sample."

# Aqua_factor = human_valid_interaction_rmdup/mouse_valid_interaction_rmdup

aqua1_d = mergestat.all[2,2]/mergestat.all[2,4]
aqua2_ent = mergestat.all[2,3]/mergestat.all[2,5]
#####
#####

### Load and transform sparse matrix
# install HiCcompare using Bioconductor
library(HiCcompare)

mtx = read.table('~/Desktop/hic_pro/rh4_d_chr11_5kb.txt')
mtx2 = read.table('~/Desktop/hic_pro/rh4_en4_matrix.txt')
denMat1 <- sparse2full(mtx, hic.table = FALSE, column.name = NA)
denMat2 <- sparse2full(mtx2, hic.table = FALSE, column.name = NA)
# CPM calculation = matrix*10^6 / sum of valid_interaction_rmdup of hg19 and mm10 

denMat1.CPM = denMat1*1000000/(mergestat.all[2,2]+mergestat.all [2,4]) 
denMat2.CPM = denMat2*1000000/(mergestat.all[2,2]+mergestat.all [2,4]) 
# the result above * aqua factors

denAQuA1 = denMat1.CPM*aqua1_d
denAQuA2 = denMat2.CPM*aqua2_ent

###Plot heatmap
### Build matrices with AQuA maximums, plot HEATMAPS
library(pheatmap)

quant_cut = 0.95 #caps the contact map plot values at a given percentile 
quantile(denAQuA1, probs = c(quant_cut))
quantile(denAQuA2, probs = c(quant_cut))
AQuAmax = max(quantile(denAQuA1, probs = c(quant_cut)),quantile(denAQuA2, probs = c(quant_cut)))
denAQuA1max = denAQuA1; denAQuA1max[denAQuA1max>AQuAmax] <- AQuAmax
denAQuA2max = denAQuA2; denAQuA2max[denAQuA2max>AQuAmax] <- AQuAmax

### plot control and treated samples

pheatmap(((denAQuA1max)), cluster_rows = F, cluster_cols = F,
color = colorRampPalette(c("white", "red"))(50)) 
pheatmap(((denAQuA2max)), cluster_rows = F, cluster_cols = F,
color = colorRampPalette(c("white", "red"))(50))

### plot delta samples

denDeltaAQuA = denAQuA2 - denAQuA1
denDeltaAQuAmax = quantile(denDeltaAQuA, probs = c(quant_cut))
denDeltaAQuA[denDeltaAQuA>denDeltaAQuAmax] = denDeltaAQuAmax
pheatmap((denDeltaAQuA), cluster_rows=F, cluster_cols=F,
color = colorRampPalette(c("dodgerblue", "white", "mediumvioletred")) (33))


## vitural 4C plot
### Extract a Virtual AQuA-4C viewpoint, make bedgraphs, plot VIRTUAL4C
virt4C_viewpoint_chr = "chr11"; virt4C_viewpoint = '17670000'
df_AQuA1 = as.data.frame(denAQuA1, row.names = row.names(denAQuA1), col.names=col.names(denAQuA1))

df_AQuA2 = as.data.frame(denAQuA2, row.names = row.names(denAQuA2), col.names = col.names(denAQuA2))

virt4C.bedgraph1 = as.data.frame(df_AQuA1[,virt4C_viewpoint])

colnames(virt4C.bedgraph1) = "AQuA_contact_freq" #  it's contact freq
virt4C.bedgraph1$chr = virt4C_viewpoint_chr
virt4C.bedgraph1$start = as.numeric(rownames(df_AQuA1)) 
# the bin size is the same while using dump ... 5000
virt4C_binsize = virt4C.bedgraph1[2,c("start")]-virt4C.bedgraph1[1, c("start")] # == 5000
virt4C.bedgraph1$stop = virt4C.bedgraph1$start + virt4C_binsize# 5000
# final 
virt4C.bedgraph1 = virt4C.bedgraph1[,c(2,3,4,1)]

#### second martix #####

virt4C.bedgraph2 = as.data.frame(df_AQuA2[,virt4C_viewpoint])
colnames(virt4C.bedgraph2) = "AQuA_contact_freq" 
virt4C.bedgraph2$chr = virt4C_viewpoint_chr
virt4C.bedgraph2$start = as.numeric(rownames(df_AQuA1)) 
# the bin size is the same while using dump ... 5000
virt4C_binsize = virt4C.bedgraph2[2,c("start")]-virt4C.bedgraph2[1, c("start")] # == 5000
virt4C.bedgraph2$stop = virt4C.bedgraph2$start + virt4C_binsize# 5000
virt4C.bedgraph2 = virt4C.bedgraph2[,c(2,3,4,1)]


## spline to smooth
spline1 <- as.data.frame(spline(virt4C.bedgraph1$start, virt4C.bedgraph1$AQuA_contact_freq))
spline2 <- as.data.frame(spline(virt4C.bedgraph2$start,virt4C.bedgraph2$AQuA_contact_freq))
spline_delta = spline1; spline_delta$y = (spline2$y-spline1$y)
## plots
library(ggplot2)
ggplot(spline1, aes(x=(x+virt4C_binsize/2),y=y))+ theme_bw()+ geom_line(color = "red")+ geom_line(data=spline_delta, color = "purple")+
  geom_vline(xintercept=as.numeric(virt4C_viewpoint))+ geom_vline(xintercept=(as.numeric(virt4C_viewpoint)+virt4C_binsize))

###

# Use hiccompare tool to generate bedpe loop





