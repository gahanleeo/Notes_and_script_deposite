f1 =read.delim('Desktop/UCSC_interaction_file/T24/T24_16000_bait_all_chr.txt',header = T)
f1 = subset(f1,f1$N_reads > 2 & f1$score > 5.00)
f1$bait_chr = paste0('chr',f1$bait_chr)
f1$otherEnd_chr = paste0('chr',f1$otherEnd_chr)
f1$color ="#A569BD"
f1 = subset(f1,f1$bait_chr =='chr5')
#f1$sourceChrom =paste0('chr',f1$sourceChrom)

###spcify chr

T24 =read.delim('Desktop/UCSC_interaction_file/T24/T24_16000_bait_all_scored_colored.txt',header = T,stringsAsFactors = F)

T24T =read.delim('Desktop/UCSC_interaction_file/T24T/T24T_all_colored_socred.txt',header = T,stringsAsFactors = F)

SLT3 =read.delim('Desktop/UCSC_interaction_file/SLT3/SLT3_all_chr.txt',header = T,stringsAsFactors = F)

FLT3 =read.delim('Desktop/UCSC_interaction_file/FLT3/FLT3_all_chr.txt',header = T,stringsAsFactors = F)

chr = SLT3

chr = subset(chr,chr$X.bait_chr == 'chr9')

chr = subset(chr,chr$X.bait_chr == 'chr8' & chr$sourceChrom == 'chr8' )


write.table(chr,file = 'Desktop/T24_8_4_color.txt',quote = F,col.names = T,row.names = F,sep = '\t')

## make  new washU format

chr=chr[,c(1,2,3,9,10,11,6,6,7)]

chr$new = paste0(chr$sourceChrom,":",chr$sourceStart,"-",chr$sourceEnd,",",chr$Value)


chr = chr[,c(1,2,3,10,7,9)]

## Arima_MAPS
## change format from bedpe file to UCSC biginteract format
# the arcplot format will be double row compare to bedpe file, since it just report both direction

exp = read.delim2('UCSC_interaction_file/T24/T24_16000_bait_all_scored_colored.txt',header = T,skip = 1)
file= read.delim2('Output/MAPS_output/Arima-MAPS-test_20210930_111755/Arima-MAPS-test.5k.2.sig3Dinteractions.bedpe')
other = read.delim2('Output/arcplot_and_metaplot/Arima-MAPS-test.5k.2.arcplot.txt',header = F)

file = file[,c(1:6,10,13)]
file$bait_name = file$ClusterLabel
file$score = round(as.numeric(file$ClusterNegLog10P))
file$value = file$ClusterNegLog10P
file$Exp = "."
file$color = '#FF0000'
file$sourceName = '.'
file$sourceStrand = '.'
file$targetChrom = file$X.chr1
file$targetStart = file$start1
file$targetEnd = file$end1
file$targetName = file$ClusterLabel
file$targetStrand = '.'

file1 = file[,c('X.chr1','start1','end1','ClusterLabel','score','value','Exp',"color",'chr2','start2','end2','sourceName','sourceStrand','targetChrom','targetStart','targetEnd','targetName','targetStrand')]
colnames(file1) = colnames(exp)
## change strong inteaction by color
chr = T24

for (i in 1:nrow(chr)) {
  score <- chr[i, "Score"]
  if(score >= 15) {
    chr[i,8] = '#A569BD'
  } else if (score < 15 & score >= 10 ) {
    chr[i,8] = '#BB8FCE'}
    else if (score < 10 & score >= 7 ) {
      chr[i,8] = '#D2B4DE'
    }else{
      chr[i,8] = '#E8DAEF'
    }
}
## how to search odd number row 

for (i in 1:10) {
  if (i %% 2 ==1) print(i)
}


## TAD format 

TAD = read.delim('UCSC_interaction_file/Bladder_Donor-BL1-raw_TADs.txt',header = F,stringsAsFactors = F)

TAD = subset(TAD,TAD$V1 == 'chr1')

TAD$name = paste0('TAD','_',1:161)
TAD$score = 0
TAD$strand = '+'
TAD$thickStart = TAD$V2
TAD$thickEnd = TAD$V3
TAD$color = '41,50,92'

## change color code at the odd column 
for (i in 1:nrow(TAD)) {
  if (i %% 2 ==1) {
    TAD[i,9] = '255,215,0'
  }
}

## write table
write.table(file1,file = 'test_arima_hichip.txt',quote = F,col.names = T,row.names = F,sep = '\t')



