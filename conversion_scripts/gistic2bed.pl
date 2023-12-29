#!/usr/bin/perl -w
use strict;

my $cnv = shift;

open(CNV, "< $cnv");

my $header = <CNV>;
my @h = split("\t", $header);
my %outHash;

while (my $line = <CNV>) {
	next unless $line =~ "Actual Copy Change Given";
	chomp($line);
	my @f = split("\t",$line);
	for (my $i = 9; $i <= $#f; $i++) {
		my @g = split(/:|-|\(/,$f[4]);
		my $sample = substr($h[$i],0,12);
		my $cn = 2 + 2*$f[$i];
		my $outl = join("\t",$g[0],$g[1],$g[2],$cn);
		$outHash{$sample} .= "$outl\n";
	}
}

for my $key (keys %outHash) {
	#print $key, "\n";
	#print $outHash{$key};
	open(OUT, "> $key.bed");
	print OUT $outHash{$key};
}