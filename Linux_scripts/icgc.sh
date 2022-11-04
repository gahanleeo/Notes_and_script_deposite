#!/bin/bash

module load samtools

#./gen3-client download-single --guid=7604bff9-ff50-4f3a-9126-c95cfa6751be --profile=icgc --no-prompt



../gen3-client download-multiple --profile=icgc --manifest=6_manifest.json --no-prompt


for i in *.bam
do
samtools index $i
done


echo done index!


