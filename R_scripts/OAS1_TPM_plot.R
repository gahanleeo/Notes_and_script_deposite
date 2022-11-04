library(ggplot2)
library(dplyr)

####
setwd('Desktop/')
## select multiple target 
f1 = datainf = read.delim2('Duke_PBMC_PRJNA679264/Duke_PBMCs/OAS1_TPM_14pati_for_plot.txt')

target = as.data.frame(table(f1$Subject_ID))
target = subset(target, Freq > 1)
target.of.ID = target$Var1

multiple.sample = f1[f1$Subject_ID %in% target.of.ID,]

## reorder multiole column of ID and time_on_set using order() function

#t1 = multiple.sample[order( multiple.sample[,3], multiple.sample[,4] ),]

## save the table and edit using excel...


# the position_dodge2() is cancel the default stacking in the gemo_barplot
t1 = multiple.sample

t1$time_since_onset = factor(t1$time_since_onset,levels = c("early", "middle", "late"))
#t1$orderplot = factor(t1$orderplot,levels = c("d1", "d2", "d3", "d4",))


p <- ggplot(t1, aes(Subject_ID, OAS1_log2, fill=time_since_onset)) + 
  geom_bar(position = position_dodge2(  preserve = "single"),stat = 'identity') + labs(x = 'Patient_ID' , y = 'OAS1_log2TPM') +
  theme(axis.text.x = element_text(angle = 0)) + ylim(0,4)
print(p) 
dev.off()

p <- ggplot(t1, aes(Subject_ID, OAS2_log2, fill=time_since_onset)) + 
  geom_bar(position = position_dodge2(  preserve = "single"),stat = 'identity') + labs(x = 'Patient_ID' , y = 'OAS2_log2TPM') +
  theme(axis.text.x = element_text(angle = 0)) + ylim(0,4)
print(p) 
dev.off()

p <- ggplot(t1, aes(Subject_ID, OAS3_log2, fill=time_since_onset)) + 
  geom_bar(position = position_dodge2(  preserve = "single"),stat = 'identity') + labs(x = 'Patient_ID' , y = 'OAS3_log2TPM') +
  theme(axis.text.x = element_text(angle = 0)) + ylim(0,4)
print(p) 
dev.off()

p <- ggplot(t1, aes(Subject_ID, ISG15_log2, fill=time_since_onset)) + 
  geom_bar(position = position_dodge2(  preserve = "single"),stat = 'identity') + labs(x = 'Patient_ID' , y = 'ISG15_log2TPM') +
  theme(axis.text.x = element_text(angle = 0)) + ylim(0,4)
print(p) 
dev.off()


# https://sebastiansauer.github.io/ordering-bars/
# http://girke.bioinformatics.ucr.edu/CSHL_RNAseq/mydoc/mydoc_Rgraphics_5/
#very detailed ggplot2:
# https://ggplot2.tidyverse.org/reference/geom_bar.html

