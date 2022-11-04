#!/bin/bash
#SBATCH --cpus-per-task=18
#SBATCH --time=96:00:00

module load gdc-client

cd /data/leec20/gdc_ccle/

#gdc-client download -m bladder_ccle_1_to_10.txt
gdc-client download 32c43be9-d2d8-4ce5-8f16-6651c0df6f84

echo done
