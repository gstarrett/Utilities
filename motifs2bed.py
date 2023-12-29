#!/usr/bin/env python
import subprocess
from Bio import SeqIO
import argparse

parser = argparse.ArgumentParser(description='Find putative binding sites')
parser.add_argument('fasta')
parser.add_argument('--mismatch', default=0, type=int, dest="mismatch")
parser.add_argument('pattern', default='G[AG]GGCN(0,30)GCC[TC]C')
parser.add_argument('--complement', dest="complement", action='store_true')
args = parser.parse_args()

args.pattern = "N(20)" + args.pattern + "N(20)"

for seq_record in SeqIO.parse(args.fasta, "fasta"):
  if args.complement:
    cmd = ["fuzznuc", "-supper1", complement, "-snucleotide1", "-auto", "-filter", "-pmismatch", str(args.mismatch), "-pattern",  args.pattern]
  else:
    cmd = ["fuzznuc", "-supper1", "-snucleotide1", "-auto", "-filter", "-pmismatch", str(args.mismatch), "-pattern",  args.pattern]
  out = subprocess.run(cmd, stdout=subprocess.PIPE, input=str(seq_record.seq).encode(), check=True)
  decoded = out.stdout.decode('UTF-8')
  decoded = decoded.splitlines()
  for line in decoded:
    line = line.rstrip()
    if (not line.startswith("#") and line and "Start" not in line):
      f = line.split()
      start = int(f[0]) + 20
      stop = int(f[1]) - 20
      hit = f[5]
      fivePrime = hit[0:19]
      threePrime = hit[-20:]
      target = hit[20:-20]
      if "N" not in target:
          GC5 = (fivePrime.count("G") + fivePrime.count("C"))/len(fivePrime)
          GC3 = (threePrime.count("G") + threePrime.count("C"))/len(threePrime)
          mm = f[4]
          info = ';'.join([str(GC5),str(GC3),str(mm),target])
          bed = '\t'.join([seq_record.id, str(start), str(stop), info])
          print(bed)
