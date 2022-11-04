#!/bin/bash
cr=$'\r'

for i in *.bam
do

  cat ../tandem_list.txt | while read line
  do
    line="${line%$cr}"
    ff=`echo $line | sed "s/5://"`
    #echo $ff
    igvtools count -w 1 --query ${line} $i ../res_igv_tandcount/${ff}_$i.wig hg19
    #echo "done running!"
  done

done
