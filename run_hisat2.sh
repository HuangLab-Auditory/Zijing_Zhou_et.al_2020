#!/bin/bash

#The pipeline is to download data from Li et.al 2018 with sratoolkits
#Then align the fastq files into BAM files with hisat2 
#The BAM files are input for IGV

#Directories

PROJROOT=/home/student/Zijing_Zhou_et.al_2020
RAW="${PROJROOT}"/1_rawData
ALIGNED="${PROJROOT}"/2_alignedData
INDEX="${PROJROOT}"/Reference/mm10/genome


i=75
until [ $i -gt 84 ]
do
  echo downloading SRR67984$i...

#Dowloading data

fastq-dump \
--outdir ${RAW} \
--split-files SRR67984$i
  
#Converting fastq files into SAM files

echo aligning SRR67984$i into SAM...
hisat2 -p 8 --dta -x ${INDEX} -1 ${RAW}/SRR67984${i}_1.fastq -2 ${RAW}/SRR67984${i}_2.fastq -S ${ALIGNED}/SRR67984$i.sam

Sorting SAM files into BAM files and index the BAM files

echo Converting SAM into BAM...

samtools sort -@ 8 \
-o ${ALIGNED}/SRR67984$i.bam \
${ALIGNED}/SRR67984$i.sam

#Indexing

samtools index ${ALIGNED}/SRR67984$i.bam

#Delete useless files

rm ${RAW}/SRR67984${i}_1.fastq
rm ${RAW}/SRR67984${i}_2.fastq
rm ${ALIGNED}/SRR67984$i.sam

((i=i+2))
done
