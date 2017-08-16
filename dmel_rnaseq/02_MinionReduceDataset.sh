#!/bin/bash

echo 'Importing variables and calling software...'
# import variables
source 00_PrepareDataDir.sh
echo '...done.'
echo '---'

# get minion data from archive
cd $minion_dir

# subset the fast5 files to create a smaller archive
echo 'Generating a subset of the fast5 files mapping to the genome...'
echo 'Generating list of mapped reads, from gmap gff3 file...'
cat minion_gmap.gff3 | grep -v '^#' | cut -f9 | cut -d';' -f2 | sed 's/Name=//g' | uniq > minion2D_mappedID.txt
echo 'Generating list of the reads ID in the 2D reads file...'
cat minion_2D.fasta | grep '^>' | sed 's/>//' > reads2D_ID.txt
echo 'Generating list of the reads ID that map to the reference...'
grep -f minion2D_mappedID.txt reads2D_ID.txt > reads2D_mappedID.txt
echo 'Generating list of the fast5 to subset...'
cat reads2D_mappedID.txt | cut -d' ' -f3 > reads2D_mappedID_subsetf5.txt
echo 'Generating subset of fast5 according to the generated list...'
mkdir -p $minion_dir/subsetf5
cat reads2D_mappedID_subsetf5.txt | while read file; do find $minion_dir/MiNionDataFC1-48h-cDNAJulien-batch2/DownloadFromMetrichor/pass/ -name $file -exec cp {} $minion_dir/subsetf5/ \;; done;
echo 'Renaming files...'
for file in $minion_dir/subsetf5/*.fast5; do newfile=$(echo "$file" | sed "s/HiSeq_20160624_FNfad12684_MN19020_sequencing_run_JR_cDNA_31487/minion/g"); mv "$file" $newfile; done
echo 'Generating archive including only mapping fast5...'
tar zcf subsetf5.tar.gz $minion_dir/subsetf5/*
archive_name=$(ls *f5.tar.gz)
size_subsetf5=$(ll -h subsetf5.tar.gz | cut -f5 -d ' ')
echo "The generated archive was written to $archive_name and has size: $size_subsetf5"
echo '...done.'

# uploaded on dropbox
