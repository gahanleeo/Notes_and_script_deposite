# making the GSTM1_span bed file
setwd('/Users/leec20/Desktop/Pacbio_WGShg38_GSTM1_bladder/UCSC_blat/')

cellline = "Scaber"

# open psl file,
f1 = read.delim('Scaber.psl',header = F, skip=5)
# add header 
colnames(f1) = c('match','mismatch','rep.mat','Ns',	'Q_gap_count','Q_gap_base',	'T_gap_count','T_gap_base','strand','Q_name','Q_size','Q_start','Q_end','T_name','T_size','T_start','T_end','block_count','blockSizes',	'qStarts', 'tStarts')

library(dplyr)

#f2 = f1 %>% group_by(Q_name) %>% summarise(match = max(match))
# match both column using using dplyr::inner_join with c('a','b')
#f3 = dplyr::inner_join(f1, f2, by =  c("Q_name","match"))

## other ways!! more quick!!!!!
# using dplyr slice finction with which.max()
f4 = f1 %>% group_by(Q_name) %>% slice(which.max(match))

write.table(f4,paste0('Desktop/',cellline,'_GSTM1_delspan_highest_matched.txt'),row.names = F,col.names = F,quote = F,sep = '\t')

      