#!/usr/bin/perl -w
use strict;

my $in = shift;

open(IN, "< $in");
my ($chrom, $pos);
#my %out;
my $n = 0;
my $count = 0;

my $chr;
my $span;

while(my $line = <IN>) {
	chomp($line);
	if ($line =~ /Step/) {
		my @f = split(" ", $line);
		my @fchr = split("=",$f[1]);
		$chr = $fchr[1];
		my @fspn = split("=",$f[2]);
		$span = $fspn[1];
	} elsif ($line =~ /track/) {
		next;
	} else {
		my @f = split("\t",$line);
		for (my $i = 0; $i < $f[1]; $i++) {
			print join("\t", $chr, $f[0], $f[0]+$span-1, $f[1]),"\n";
		}
	}
}
