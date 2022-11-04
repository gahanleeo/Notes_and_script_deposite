#!/bin/bash



module load juicer
module load CUDA/8.0

#juicer_tools hiccups HT1376_hg19_30.hic /data/leec20/hicfastq/HT1376/hiccups_alldef

#hiccup_diff_test

juicer_tools hiccupsdiff SW780/aligned/SW780_hg19_30.hic SCABER/aligned/SCABER_hg19_30.hic\
 SW780/hiccups_alldef/SW780_hg19_loop.bedpe SCABER/hiccups_alldef/SCABER_hg19_merged.bedpe\
 /data/leec20/hicfastq/hiccups_diff   


#juicer_tools hiccups inter_30.hic -m 512 -r 5000,10000,25000 -k KR\
# -f .1,.1,.1 -p 4,2,1 -i 7,5,3 -t 0.02,1.5,1.75,2 -d 20000,20000,50000\
# /data/leec20/hicfastq/RT4/hiccups_loop_RT4_medium/


#juicer.sh -g hg38 -s Arima

#juicer.sh -g hg38\
# -z /usr/local/apps/juicer/juicer-1.6/references/hg38.fa\
# -p /usr/local/apps/juicer/juicer-1.6/references/hg38.chrom.sizes\
# -y /usr/local/apps/juicer/juicer-1.6/restriction_sites/hg38_Arima.txt 


echo Done

