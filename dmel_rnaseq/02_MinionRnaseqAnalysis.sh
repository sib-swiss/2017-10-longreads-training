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
wget https://www.dropbox.com/s/jgtvskoxyeccpg5/subsetf5.tar.gz
# time: 50sec, size: 280M
tar -xzf subsetf5.tar.gz
# time: 1min

# extract only the 2d reads from fast5 in fastq format
poretools fastq ./subsetf5/ > minion_2D.fastq
# time: 1min

# fastq to fasta
echo 'Converting fastq to fasta prior to alignment...'
cat minion_2D.fastq | awk '{if(NR%4==1) {printf(">%s\n",substr($0,2));} else if(NR%4==2) print;}' > minion_2D.fasta

# align to reference genome 
echo 'Aligning sample to the reference...'
gmap -d gmapidx -D $ref_dir minion_2D.fasta -f gff3_match_cdna -n 0 > minion_gmap.gff3
# tim: 7min

# comparison of experimental transcripts to reference annotation 
echo 'Converting gmap_gff3 to standard gtf2...'
gff2gtf.py minion_gmap.gff3 > minion_gmap.gtf
echo 'Comparing to reference annotation using cuffcompare...'
cuffcompare -r $ref_dir/Dmel_chr4.gtf minion_gmap.gtf
# time: 1min

echo 'All done. Please check output in $minion_dir"cuffcmp.minion_gmap.gtf.tmap"'
