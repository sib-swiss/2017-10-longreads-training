General outline for RNA-seq: 

1. get reference datasets from Ensembl ftp - will only use chr4 to save time: 
  * reference assembly for chr4
  * reference gene annotation for chr4
  
2. r9 MinION: 
  * raw h5 extraction - `poretools`
  * get fast &, split to fasta 2D
  * align vs ref. genome (gff3) - `GMAP`
  * compare transcripts vs reference annotation - `cuffcompare`

3. PacBio: 
  * raw h5 extraction - `pbh5tools` 
  * explain iso-seq (subreads -> roi -> IsoSeq) - will only use IsoSeq to save time
  * align vs ref. genome (sam) - `GMAP`
  * compare transcripts vs reference annotation - `MatchAnnot`
