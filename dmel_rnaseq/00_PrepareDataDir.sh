#!/bin/bash

# setup working directory
test_dir=/scratch/beegfs/monthly/aechchik/lr_zurich17
mkdir -p $test_dir

# setup subdirectories

# reference
ref_dir=$test_dir'/reference'
mkdir -p $ref_dir
# minion
minion_dir=$test_dir'/minion'
mkdir -p $minion_dir
# pacbio
pacbio_dir=$test_dir'/pacbio'
mkdir -p $pacbio_dir
