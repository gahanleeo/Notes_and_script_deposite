#!/bin/bash

module load gdc-client
 

# load manifest [-m] and token [-t] 

gdc-client download -m ../../gdc_manifest_20220228_161242.txt -t ../../gdc-user-token.2022-02-17T17_02_41.990Z.txt
