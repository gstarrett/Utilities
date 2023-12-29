#!/usr/bin/perl -w
use strict;

my $in = shift;
my $name = shift;
open (IN, "< $in");

while (my $line = <IN>) {
	chomp($line);
	my ($chr,$start,$end,$sub,$CN,$chr2,$start2,$end2,$strand,$gene,$ucsc) = split("\t", $line);
	if ($gene eq "-1") {
		$gene = "UNKNOWN";
	}
	my ($ref, $alt) = split(">", $sub);
	$chr =~ s/chr//;
	print join("\t",$gene,"0000","BGI","hg19",$chr,$start,$end,"+","SNP",$ref,$alt,$ref,"NOVEL","",$name),"\n";
}