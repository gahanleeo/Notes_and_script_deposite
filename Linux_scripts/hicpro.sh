#!/bin/bash

module load hicpro


HiC-Pro -i /data/leec20/hichip_CHiC_project/HiC_pro/fastqs  -o ./result_UV -c config_hg_arima.txt

echo "done human"


# -s merge_persample can output rmdup_validread count
#HiC-Pro -i /data/leec20/hichip_CHiC_project/HiC_pro/ready_fastq -o /data/leec20/hichip_CHiC_project/HiC_pro/result_Mai/SC829849/mm10_sample49 -s mapping -s proc_hic -s quality_checks -s merge_persample -c config_mm10_arima.txt

echo "all done"
