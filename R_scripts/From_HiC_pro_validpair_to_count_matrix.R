setwd('/Users/leec20/Desktop/HiCHIP_project/hicdcplus/')
library(HiCDCPlus)
library(DESeq2)
library(dplyr)

# Construct features from RE, Arima as example

output = getwd()

construct_features(output_path=paste0(output,'/','hg19_allchr_arima'),
                   gen="Hsapiens",gen_ver="hg19",
                   sig=c("GATC","GANTC"),bin_type="Bins-uniform",
                   binsize=50000,
                   wg_file=NULL)

# creating gi_list from  a bintolen file above 

gi_list<-generate_bintolen_gi_list(bintolen_path='hg19_allchr_arima_bintolen.txt.gz')
head(gi_list)


# test import count 
Dthreshold <- gi_list_Dthreshold.detect(gi_list)
# load allvalidpair, keep interaction that in the same chromosome, 
# intreaction length not over the limit interaction value
allvalidpairs <- data.table::fread('sc_mai_hg19.allValidPairs', sep = "\t", header = FALSE, select = c(2, 3, 5, 6), stringsAsFactors = FALSE)
allvalidpairs <- allvalidpairs %>% dplyr::filter(.data$V2 == .data$V5 & abs(.data$V3 - .data$V6) <=  Dthreshold)


binsize <- 50000

# start == floor(V3 / 50000) * 50000, floor like round()
# end == floor(V6/50000) * 50000
# count the how many number of chrI start end 
# %>% seem like throw the left excute result into the right excute and so on.... 

allvalidpairs <- allvalidpairs %>% dplyr::rename(chr = "V2") %>% dplyr::mutate(startI = floor(base::pmin(.data$V3,.data$V6)/binsize) * binsize, startJ = floor(base::pmax(.data$V3, .data$V6)/binsize) * binsize) %>% dplyr::select(.data$chr, 
                                                                                                                                                                                                                             .data$startI, .data$startJ)
allvalidpairs <- data.frame(data.table::data.table(allvalidpairs)[, .N, by = names(allvalidpairs)]) %>% dplyr::rename(counts = "N")

