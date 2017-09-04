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
mkdir -p /scratch/local/kjaron/LongReadWorkshop/ && cd /scratch/local/kjaron/LongReadWorkshop/
# list all the SRR entries withing the SRX experiment
curl -l ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByExp/sra/SRX/SRX499/SRX499318/ > list_of_accessions
# dl .sra, convert it to .fq and remove .sra afterwards
for accesion in $(cat list_of_accessions); do
    wget ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByExp/sra/SRX/SRX499/SRX499318/$accesion/$accesion.sra
    fastq-dump --gzip $accesion.sra && rm $accesion.sra
done
```

For this dataset I do not have h5 files, it might be possible to retrieve them from .sra files, but I have not really tried (not sure if it is that important). I also need a ch4 indexed reference

```
wget ftp://ftp.ensemblgenomes.org/pub/metazoa/release-36/fasta/drosophila_melanogaster/dna/Drosophila_melanogaster.BDGP6.dna.chromosome.4.fa.gz
module add UHTS/Aligner/bwa/0.7.13
bwa index Drosophila_melanogaster.BDGP6.dna.chromosome.4.fa.gz
```

I cleaned folder s bit (reads to reads, refrence to reference).
Now I will just map reads and filter those that are actually mapping on a unique place (to avoid stuff like `TTTTTTTTTTTTTTTTTTTT`q mapping)

```bash
module add UHTS/Analysis/samtools/1.3
for i in `ls reads`; do
    bwa mem reference/Drosophila_melanogaster.BDGP6.dna.chromosome.4.fa.gz \
        reads/$i | samtools view -h -F 4 - | samtools view -hb -F 2048 - > mapping/$(basename $i .fastq.gz).bam &
done
```

convert bam to fastq

```bash
module add UHTS/Analysis/picard-tools/2.2.1
mkdir ch4_reads
for i in `ls mapping`; do
    picard-tools SamToFastq I=mapping/$i FASTQ=ch4_reads/$(basename $i .bam).fastq QUIET=true
done
```

```bash
cat ch4_reads/* > dmel_ch4_reads.fastq
gzip -9 dmel_ch4_reads.fastq

module add UHTS/Quality_control/fastqc/0.11.2
mkdir ch4_reads_QC
# fastqc -d tmp -o ch4_reads_QC dmel_ch4_reads.fastq.gz
# runinng out of memory on vital-it - should I run it locally?
# is there a nicer way how to qc long reads?
```

Canu assenbly

```bash
module add UHTS/Assembler/canu/1.4
canu -p dmel_ch4 -d asm_run1 genomeSize=2m -maxThreads=1 useGrid=false -pacbio-raw dmel_ch4_reads.fastq.gz
# gatekeeperCreate did NOT finish successfully; too many short reads.  Check your reads!
```

Takes ages! I guess it is because I have a huge overkill of coverage (> 1000x), which is likely just a consequence of missmapping of reads from all the geneome to ch4.
The solution would be to map reads to whole genome and extract only those that are mapping to unique place at chromosome 4 -> reads that are really for sure ch4.
On coverage plot I can check if these reads are covering whole ch4 or not (maybe there would be some problematic regions that would be too close to each other and therefore have no unique mapping,
however this should be fine if reads are long enough to map to this region uniquely thanks to specific flaking regions).
This comment is moreless just a history record before I will rewrite section above accomotating this comment.


TODO mapping

```bash
minimap dmel_ch4_reads.fastq.gz ch4_asm.fa
# how to view the mapping? How would coverage plot looked like?
```
