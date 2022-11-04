#!/bin/bash

module load samtools
module load hicpro/3.1.0_conda

source /data/$USER/conda/etc/profile.d/conda.sh

conda activate good

./FitHiChIP/FitHiChIP_HiCPro.sh -C configfile

echo OH YEAH!
