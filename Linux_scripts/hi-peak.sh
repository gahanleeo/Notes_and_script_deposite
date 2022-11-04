#!/bin/bash

module load samtools hicpro

source /data/$USER/conda/etc/profile.d/conda.sh

conda activate hichip-peaks


# command line

peak_call -i nonUV/ -o ./res_non -r /data/leec20/hichip_CHiC_project/HiC_pro/arima_hg19_hicpro_digest.bed
peak_call -i UV8hr/ -o ./res_uv8 -r /data/leec20/hichip_CHiC_project/HiC_pro/arima_hg19_hicpro_digest.bed


echo done!


