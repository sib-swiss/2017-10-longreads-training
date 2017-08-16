#!/bin/bash

# setup working directory
test_dir=$(pwd) # note: if you're going to replace the content of this line with a new directory, please do not include the final slash to the path to the directory to write to

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
