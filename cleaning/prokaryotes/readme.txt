DDBJ 16S ribosomal RNA sequence data of prokaryotes
March 2020, including 998,911 sequences 
Last published date in the present data: February 2020

-------------------------------------------------------------------------------
Table of contents
-------------------------------------------------------------------------------

  1. Introduction

  2. Format of sequence data
    2.1. Description line
    2.2. Sequence block

  3. Contact information

  4. Acknowledgment

  5. Disclaimer

  6. Statistics

-------------------------------------------------------------------------------

1. Introduction

The 16S ribosomal RNA sequence data is extracted from DDBJ periodical release
119.0 by the following steps.

1)  Select rRNA features from DDBJ periodical release matching with 
    following conditions.
    1-a) Belonging to BCT division; i.e. derived from bacteria or archea. 
    1-b) Including "16S", "16s", "RRS", "rrs", "SSU" or "ssu" in its /product 
         qualifer value.
    1-c) The sequance span of the feature location is longer than 300 bp. 

2)  Exclude rRNA sequences from the data set of step 1), when the results of 
    blast to NCBI 16S rRNA reference sequences are matching with all of 
    following conditions.
    - Complementary sequence matching
    - Identities is more than 80% 
    - Coverage of aligned sequence is more than 50%


2. Format of sequence data

This data is provided in a FASTA format that begins with a single-line 
description, followed by lines of nucleotide sequence data.

A example of 16S rRNA sequence.
-------------------------------------------------------------------------------
>AB000001_1|Sphingomonas sp.|16S ribosomal RNA
agctgctaatattagagccctatatatagagggggccctatactagagatatatctatca
gctaatattagagccctatatatagagggggccctatactagagatatatctatcaggct
attagagccctatatatagagggggccctatactagagatataagtcgacgatattagca
agccctatatatagagggggccctatactagagatatatctatcaggtgcacgatcgatc
cagctagctagc
-------------------------------------------------------------------------------


2.1. Description line

The description line starts with [>], followed by the below items.
-------------------------------------------------------------------------------
>[ACCESSION]_[SERIAL]|[ORGANISM]|[PRODUCT]
-------------------------------------------------------------------------------
 - [ACCESSION]: The accession number of the entry including the rRNA feature. 
 - [SERIAL]   : The serial number of the rRNA feature assigned in the order of 
                rRNA feature appeared in the entry with the accession number. 
 - [ORGANISM] : Organism name; the value of /organism qualifier of the entry 
                with the accession number. 
 - [PRODUCT]  : Product name; the value of /product qualifier of the rRNA 
                feature


2.2. Sequence block

The nucleotide sequence of the rRNA feature is extracted from the entry 
according to its location.


3. Contact information

DNA Data Bank of Japan
Bioinformation and DDBJ Center
National Institute of Genetics
Research Organization of Information and Systems

Mishima 411-8540, Japan
Phone:  +81 55 981 6853
FAX:    +81 55 981 6849
E-mail: ddbj@ddbj.nig.ac.jp
WWW:    http://www.ddbj.nig.ac.jp/


4. Acknowledgment

We are grateful to NCBI for providing 16S rRNA reference sequences to us. 


5. Disclaimer

While DDBJ endeavors to keep its data correct, DDBJ makes no representations 
or warranties of any kind about the completeness, accuracy or reliability 
with respect to the sequences contained in the 16S rRNA sequence data.  DDBJ 
also makes no legal liability or responsibility of merchantability or fitness 
for a particular purpose or that the use of the sequence data will not 
infringe any patent or other rights.  Any receipt, reliance or use you place 
on such data is therefore strictly at your own risk.  


6. Statistics

The followings are statistics of the current 16S rRNA sequence data.

===============================================================================
file name             no. of sequences                    file size
===============================================================================
16S.fasta.gz                    998911                    122002786
===============================================================================
    1,104 bp : average length of 16S rRNA sequences

   1,228,505 : 1-a) number of total rRNA features in BCT division of rel. 119.0
   1,022,593 : 1-b) number of 16S rRNA candidates, i.e. including either of 
                    terms in /product qualifier
   1,002,065 : 1-c) number of 16S rRNA candidates, longer than 300 bp in their 
                    length

