### Drosophila as the training dataset

This year we have decided to do some iso-seq as well. It is exciting and trendy usage of long read sequencing, but it is not that meaningful in prokaryotes.
Therefore we were thinking about taking a eukaryotic model.

Of course we could try to find a good yeast dataset (or something else with small genome),
but the thing is that we have very nice drosophila RNA-seq data of both major long read sequencing platforms.
Amina is also very familiar with this dataset.

We also figures out that we do not need to do the full genome, but we could easily assemble one chromosome only.
This would require us to map the long reads to reference and keep only the reads that map to one chromosome only.
Our RNA-seq data is of female flies, therefore we will go for the smallest autosome.

#### Get data

The sequencing data I will play with are ~100x coverage of genome of male _D. melanogaster_, [SRA experiment
SRX499318, SRA Study: SRP040522](https://www.ncbi.nlm.nih.gov/Traces/study/?acc=SRX499318).

```bash
# contains a convertor of .sra to .fastq - fastq-dump
module add UHTS/Analysis/sratoolkit/2.8.0
# dee-serv04
mkdir -p /scratch/local/kjaron/temp/ && cd /scratch/local/kjaron/temp/
# list all the SRR entries withing the SRX experiment
curl -l ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByExp/sra/SRX/SRX499/SRX499318/ > list_of_accessions
# dl .sra, convert it to .fq and remove .sra afterwards
for accesion in $(cat list_of_accessions); do
    wget ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByExp/sra/SRX/SRX499/SRX499318/$accesion/$accesion.sra
    fastq-dump --gzip $accesion.sra && rm $accesion.sra
done
```

For this dataset I do not have h5 files, it might be possible to retrieve them from .sra files, but I have not really tried (not sure if it is that important).
