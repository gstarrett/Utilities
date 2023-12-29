#!/usr/env python3
import gzip
import argparse
from Bio.SeqRecord import SeqRecord
from Bio.Seq import Seq
from Bio import SeqIO

parser = argparse.ArgumentParser()
parser.add_argument("input")
parser.add_argument("output")
args = parser.parse_args()

RE1 = 'AATATT'
RE2 = 'AAGCTT'

output_handle1 = open(args.output + "_1.fasta", "w")
output_handle2 = open(args.output + "_2.fasta", "w")
with gzip.open(args.input, "rt") as handle:
    for record in SeqIO.parse(handle, "fastq"):
      digest1 = str(record.seq).split(RE1)
      digest2 = str(record.seq).split(RE2)
      if (len(digest1)==2):
        seq1 = SeqRecord(Seq(digest1[0]), id=record.id + "_RE1_1", description="", name="")
        seq2 = SeqRecord(Seq(digest1[1]), id=record.id + "_RE1_2", description="", name="")
        SeqIO.write(seq1, output_handle1, "fasta")
        SeqIO.write(seq2, output_handle2, "fasta")
      elif (len(digest2)==2):
        seq1 = SeqRecord(Seq(digest2[0]), id=record.id + "_RE2_1", description="", name="")
        seq2 = SeqRecord(Seq(digest2[1]), id=record.id + "_RE2_2", description="", name="")
        SeqIO.write(seq1, output_handle1, "fasta")
        SeqIO.write(seq2, output_handle2, "fasta")
