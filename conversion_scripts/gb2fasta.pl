#!/usr/bin/perl -w
# Contributed by Jason Stajich <jason@bioperl.org>

# simple extract the CDS features from a genbank file and
# write out the CDS and Peptide sequences

use strict;
use Bio::SeqIO;
#my $filename = shift || die("pass in a genbank filename on the cmd line");
my $in =  Bio::SeqIO->newFh(-fh => \*ARGV, -format => 'genbank');
my $out =  Bio::SeqIO->newFh(-format => 'fasta');

print $out $_ while <$in>;
