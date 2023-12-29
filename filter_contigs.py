#!/usr/bin/env python3
import pandas as pd
import argparse
import os
from Bio import SeqIO

# filter out reads with hits

parser = argparse.ArgumentParser()
parser.add_argument('blast', metavar='N', type=str, help='Input blast hits')
parser.add_argument('fasta', metavar='N', type=str, help='Input fasta')

args = parser.parse_args()

blastHits = pd.read_csv(args.blast, sep="\t", header=None, names=["qseqid", "sseqid", "stitle", "pident", "qlen", "length", "mismatch", "gapopen", "evalue", "bitscore"])

removeList = []

for index, row in blastHits.iterrows():
  if row["length"]/row["qlen"] > 0.75 and row["qseqid"] not in removeList:
    removeList.append(row["qseqid"])

for seq_record in SeqIO.parse(args.fasta, "fasta"):
  if seq_record.id not in removeList and len(seq_record.seq)>150:
    fasta_format_string = ">%s\n%s" % (seq_record.id, seq_record.seq)
    print(fasta_format_string)
