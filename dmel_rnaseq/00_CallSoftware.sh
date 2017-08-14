#!/bin/bash

# cufflinks
module add UHTS/Assembler/cufflinks/2.2.1

# poretools 
module add UHTS/Analysis/poretools/0.5.1

# pbh5tools
module add UHTS/PacBio/pbh5tools/0.8.0

# gmap 
export PATH='$PATH:/home/aechchik/software/gmap-2017-04-24/bin'

# matchannot
export PATH='$PATH:/home/aechchik/software/MatchAnnot'
