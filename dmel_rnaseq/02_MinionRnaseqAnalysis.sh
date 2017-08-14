#!/bin/bash

# estimation of time per command using 1 core per command

echo 'Importing variables and calling software...'
# import variables
source 00_PrepareDataDir.sh
# import software
source 00_CallSoftware.sh
echo '...done.'
echo '---'

# get minion data from archive
cd $minion_dir

# copy if not already in the target directory
echo 'Copying & unzipping data to working directory...'
cp -R -u -p /home/jroux/archive/MinION/run_MinION_2016_06_23.tar.gz .
# real	2m32.061s
# user	0m0.083s
# sys	1m39.813s
tar -xzvf run_MinION_2016_06_23.tar.gz
# > 20min, killed at 19m97: too long, need to optimize.
echo '...done.'
echo '---'

# extract only the 2d reads from fast5 in fastq format
poretools fastq --type 2D --high-quality MiNionDataFC1-48h-cDNAJulien-batch2/ > minion_2D.fastq
# not tested... previous step takes too long, need to optimize.

### from here on, tested on already extracted data from r9

# fastq to fasta
echo 'Converting fastq to fasta prior to alignment...'
cat minion_2D.fastq | awk '{if(NR%4==1) {printf(">%s\n",substr($0,2));} else if(NR%4==2) print;}' > minion_2D.fasta
echo '...done.'
echo '---'

# align to reference genome 
echo 'Aligning sample to the reference...'
gmap -d gmapidx -D $ref_dir $minion_dir/minion_2D.fasta -f gff3_match_cdna -n 0 > minion_gmap.gff3
# real	6m42.988s
# user	6m23.930s
# sys	0m6.083s
echo '...done.'
echo '---'

# comparison of experimental transcripts to reference annotation 
echo 'Converting gmap_gff3 to standard gtf2...'
gff2gtf.py minion_gmap.gff3 > minion_gmap.gtf
# real	0m0.096s
# user	0m0.062s
# sys	0m0.020s
echo '...done.'
echo '---'
echo 'Comparing to reference annotation using cuffcompare...'
cuffcompare -r $ref_dir/Dmel_chr4.gtf minion_gmap.gtf
# real	0m0.731s
# user	0m0.073s
# sys	0m0.015s
echo '...done.'
echo '---'
echo 'All done. Please check output in $minion_dir"cuffcmp.minion_gmap.gtf.tmap"'

