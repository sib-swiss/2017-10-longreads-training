#!/bin/bash

# estimated runtime, 1 core: 
# real	1m49.324s
# user	0m42.280s
# sys	0m1.375s

echo 'Importing variables and calling software...'
# import variables
source 00_PrepareDataDir.sh
# import software
source 00_CallSoftware.sh
echo '...done.'
echo '---'

# get references from ensembl 
cd $ref_dir

# get reference genome
echo 'Downloading & unzipping reference genome...'
wget ftp://ftp.ensemblgenomes.org/pub/metazoa/release-36/fasta/drosophila_melanogaster/dna/Drosophila_melanogaster.BDGP6.dna.chromosome.4.fa.gz
gunzip -d Drosophila_melanogaster.BDGP6.dna.chromosome.4.fa.gz
mv Drosophila_melanogaster.BDGP6.dna.chromosome.4.fa Dmel_chr4.fasta
echo '...done.'
echo '---'

# get reference annotation
echo 'Downloading & unzipping reference annotation...'
wget ftp://ftp.ensemblgenomes.org/pub/metazoa/release-36/gff3/drosophila_melanogaster/Drosophila_melanogaster.BDGP6.36.chromosome.4.gff3.gz
gunzip -d Drosophila_melanogaster.BDGP6.36.chromosome.4.gff3.gz
mv Drosophila_melanogaster.BDGP6.36.chromosome.4.gff3 Dmel_chr4.gff3
echo '...done.'
echo '---'

# convert reference annotation gff3 -> gtf
echo 'Converting reference annotation in gtf format using gffread...'
gffread Dmel_chr4.gff3 -T -o Dmel_chr4.gtf
echo '...done.'
echo '---'

# build gmap index for reference genome
echo 'Starting index...'
gmap_build -d gmapidx -D . Dmel_chr4.fasta
echo 'done.'
echo '---'

# return to original directory
cd $test_dir
echo 'Exit.'
