#!/bin/bash

#The pipeline is to download data from Li et.al 2018 with sratoolkits
#Then align the fastq files into BAM files with hisat2 
#samtools is used to index the BAM files
#The BAM files are input for IGV

#Directories

PROJROOT=/mnt/e/Zijing_Zhou_et.al_2020
RAW="${PROJROOT}"/1_rawData
ALIGNED="${PROJROOT}"/2_alignedData
INDEX="${PROJROOT}"/Reference


#====================#
###Data Aquisition####
#====================#

i=75
until [ $i -gt 84 ]
do
  echo i: $i
fastq-dump \
--outdir ${RAW} \
--split-files SRR67984$i
  ((i=i+2))
done

#====================#
######Alignment#######
#====================#

#Converting fastq files into SAM files

i=75
until [ $i -gt 84 ]
do
hisat2 
-p 8 \
--dta \
-x ${INDEX} \
-1 ${RAW}/SRR67984$i_1.fastq \ 
-2 ${RAW}/SRR67984$i_2.fastq \
-S ${ALIGNED}/SRR67984$i.sam
((i=i+2))
done

#Sorting SAM files into BAM files and index the BAM files

i=75
until [ $i -gt 84 ]
do
samtools sort -@ 8 \
-o ${ALIGNED}/SRR67984$i.bam \
${ALIGNED}/SRR67984$i.sam
samtools index ${ALIGNED}/SRR67984$i.bam
((i=i+2))
done
