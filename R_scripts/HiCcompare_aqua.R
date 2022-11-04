# HiCcompare for HiC-pro and Aqua-factor
library(HiCcompare)
# example of aqua-factor:
aqua1 = 5

#mtx = read.table('~/Desktop/hic_pro/rh4_d_chr11_5kb.txt')
#denMat1 <- sparse2full(mtx, hic.table = FALSE, column.name = NA)
## matrix*10^6 / sum of valid_interaction_rmdup of hg19 and mm10 
#denMat1.CPM = denMat1*1000000/(mergestat.all[2,2]+mergestat.all [2,4]) 
## the result above * aqua factors
#denAQuA1 = denMat1.CPM*aqua1_d

####
setwd('~/Desktop/hic_pro/human_hg19/hic_results/matrix/rh4_hg19_d/iced/')
# read in files
mat <- read.table("5000/rh4_hg19_d_5000_iced.matrix")
bed <- read.table("5000/rh4_hg19_d_5000_iced.matrix.biases")
# convert to BEDPE using its function
dat1 <- hicpro2bedpe(mat, bed)
# NOTE: hicpro2bedpe returns a list of lists.
#The first list, dat$cis, contains the intrachromosomal contact matrices
# NOTE: dat$trans contains the interchromosomal contact matrix which is not used in HiCcompare.
# chr1 bedpe format
res = dat$cis$chr1

# To create a hic.table object using BEDPE data

hic.table <- create.hic.table(dat1[[1]])

### Validpair to bedpe 
# https://github.com/nservant/HiC-Pro/issues/362

vp = read.table('Desktop/hic_pro/human_hg19/hic_results/data/rh4_hg19_d/rh4_hg19_d.allValidPairs',header = F)
vp = vp[,c(1:12)]
# subset the same chr 
vp$V2 = as.character(vp$V2)
vp$V5 = as.character(vp$V5)
library(dplyr)
# need  character or will have error
vp = dplyr::filter(vp, vp$V5 == vp$V2)

for (i in 1:nrow(vp)){

  vp$fir.start[i] = round(vp[i,3]- (vp[i,8]/2))
  vp$fir.end[i] = round(vp[i,3]+ (vp[i,8]/2))
  vp$sec.star[i] = round(vp[i,6]- (vp[i,8]/2))
  vp$sec.end[i] = round(vp[i,6]+ (vp[i,8]/2))

}

vp = vp[,c(2,13,14,5,15,16)]

vp$name = '.'
vp$score = '.'

# done


