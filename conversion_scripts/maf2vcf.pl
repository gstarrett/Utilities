#!/usr/bin/perl -w
use strict;
use Data::Dumper;

my $in = $ARGV[0];
#my $out = $ARGV[1];
my (@matrix, @vcfMatrix,%sampleNames);
my @header = ("#CHROM","POS","ID","REF","ALT","QUAL","FILTER","INFO","FORMAT");
push (@vcfMatrix, \@header);

open (IN, "< $in");
my $first = <IN>;
while (my $line = <IN>) {
	chomp($line);
	my @entry =  split("\t",$line);
	push(@matrix, \@entry);
	my ($alt,$info,$format);
	$format = "GT:GQ";
	$info = "$entry[9];SB=$entry[7];EFF=($entry[8]|$entry[0]);SOMATIC";
	unless (exists $sampleNames{$entry[15]}) {
		$sampleNames{$entry[15]} = 1;	
	}
		
	if ($entry[11] eq $entry[12]) {
		$alt = $entry[11];
	} elsif ($entry[11] eq $entry[10]) {
		$alt = $entry[12];
	} elsif ($entry[12] eq $entry[10]) {
		$alt = $entry[11];
	} else {
		$alt = "$entry[11],$entry[12]";
	}
	my @vcf = ($entry[4], $entry[5], ".", $entry[10], $alt, "99", "PASS", $info, $format);
	push(@vcfMatrix, \@vcf);
}
close (IN);

for my $sample (keys %sampleNames) {
	push(@{$vcfMatrix[0]}, $sample);
	for my $idx (0..$#matrix) {
		if (${$matrix[$idx]}[15] eq $sample) {
			my $count = 0;
			my $gt;
			if (${$matrix[$idx]}[11] eq ${$matrix[$idx]}[10]) {
				$gt = "0";
			} else {
				$count++;
				$gt = "$count";
			}
			if (${$matrix[$idx]}[12] eq ${$matrix[$idx]}[10]) {
				$gt .= "/0:99";
			} elsif (${$matrix[$idx]}[12] eq ${$matrix[$idx]}[11]) {
				$gt .= "/$count" . ":99";
			} else {
				$count++;
				$gt .= "/$count" . ":99";
			}
			push(@{$vcfMatrix[$idx+1]},$gt);
		} else {
			push(@{$vcfMatrix[$idx+1]},"0/0:99");
		}
	}
}

for my $entry (@vcfMatrix) {
	print join("\t", @{$entry}), "\n";
}