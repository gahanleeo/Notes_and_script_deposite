# HiC-pro cal Aqua-factors
# from Nat protocol 

#####
#####

### Load and transform sparse matrix
# install HiCcompare using Bioconductor
library(HiCcompare)

# to test how the martix work, convert sc_46 allValidpairs to hic
# and dump chr11 according to prototcl

# original matrix 5000 bp 
mat = read.table('Desktop/HiCHIP_project/hic_pro/human_hg19/hic_results/matrix/rh4_hg19_d/raw/5000/rh4_hg19_d_5000.matrix')
bed = read.table('Desktop/HiCHIP_project/hic_pro/human_hg19/hic_results/matrix/rh4_hg19_d/raw/5000/rh4_hg19_d_5000_abs.bed')

colnames(mat) <- c('i', 'j', 'IF')
colnames(bed) <- c('chr1', 'start1', 'end1', 'id')
# merge to BEDPE format
new_mat <- left_join(mat, bed, by = c('i' = 'id'))
colnames(bed) <- c('chr2', 'start2', 'end2', 'id')
new_mat <- left_join(new_mat, bed, by = c('j' = 'id'))
# reorganize columns
new_mat <- new_mat[, c(4:9, 3)]
# split between intra & inter matrices
trans_mat <- subset(new_mat, chr1 != chr2)
cis_mat <- subset(new_mat, chr1 == chr2)






cob = hicpro2bedpe(mat,bed)


denMat1 <- sparse2full(mat, hic.table = FALSE, column.name = NA)

# CPM calculation = matrix*10^6 / sum of valid_interaction_rmdup of hg19 and mm10 

denMat1.CPM = denMat1*1000000/(mergestat.all[2,2]+mergestat.all [2,4]) 

# the result above * aqua factors

denAQuA1 = denMat1.CPM*aqua1_d


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





