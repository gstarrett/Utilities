#!/usr/bin/env python3
import argparse
import re
import os

parser = argparse.ArgumentParser()
parser.add_argument('input', metavar='N', type=str, help='Input assembly')

args = parser.parse_args()

accession = re.search('([^/]+)_megahit', args.input)
path = os.path.dirname(args.input)
out = "{}/{}.contigs.fa".format(path,accession.group(1))

from Bio import SeqIO
with open(args.input, "r") as input_handle, open(out, "w") as output_handle:
    for record in SeqIO.parse(input_handle, "fasta"):
        no_space_desc = re.sub(r"\s+", '_', record.description)
        record.description = ""
        record.id = "{}_{}".format(accession.group(1), no_space_desc)
        SeqIO.write(record, output_handle, "fasta")
