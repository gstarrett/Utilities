#!/usr/bin/python
import sys
from Bio import Seq
from itertools import product

mySeq = sys.argv[1];

def extend_ambiguous_dna(seq):
   d = Seq.IUPAC.IUPACData.ambiguous_dna_values
   
   return list(map("".join, product(*map(d.get, seq))))

out = extend_ambiguous_dna(mySeq)
n = 0
for x in out:
	print(">" + mySeq + str(n) + "\n" + x)
	n += 1