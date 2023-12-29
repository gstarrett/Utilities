#!/bin/bash

samtools view -f 64 ${1}.bam | bioawk -c sam '{if(and($flag,4) || and($flag,8) || $rname !~ /chr|KI[0-9]|GL/ ) print "@"$qname"\n"$seq"\n+\n"$qual}' | gzip -c > ${1}_nonhuman_R1.fastq.gz &
samtools view -f 128 ${1}.bam | bioawk -c sam '{if(and($flag,4) || and($flag,8) || $rname !~ /chr|KI[0-9]|GL/ ) print "@"$qname"\n"$seq"\n+\n"$qual}' | gzip -c > ${1}_nonhuman_R2.fastq.gz
wait
repair.sh in=${1}_nonhuman_R1.fastq.gz in2=${1}_nonhuman_R2.fastq.gz out=${1}_nonhuman_R1.repair.fastq.gz out2=${1}_nonhuman_R2.repair.fastq.gz outs=${1}_nonhuman_S.repair.fastq.gz