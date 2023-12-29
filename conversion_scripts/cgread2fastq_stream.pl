#!/usr/bin/perl -w
use strict;
use Compress::Bzip2;

my $path = shift;
chomp($path);
my @dirs = split("/", $path);
my $filename = pop(@dirs);
#print $filename,"\n";
my ($readpre) = $filename =~ /reads_(.+)\.tsv.bz2/;
open(R1, "> $readpre.1.fastq");
open(R2, "> $readpre.2.fastq");
open(IN, "bzcat $path |") or die("Can't open pipe from command 'bzcat $filename' : $!\n");
while (my $line = <IN>) {
	next unless $line =~ /^\d/;
	chomp($line);
	my @field = split("\t", $line);
	my $R1 = substr($field[1],0,35);
	my $R2 = substr($field[1],35);
	my $Q1 = substr($field[2],0,35);
	my $Q2 = substr($field[2],35);
	my $readname = $readpre . ":" . uid();
	print R1 "\@$readname/1\n$R1\n+\n$Q1\n";
	print R2 "\@$readname/2\n$R2\n+\n$Q2\n";
}

sub uid {
	my @charArray = (0..9, "a".."z", "A".."Z");
	my $uid;
	for (my $i=0; $i < 20; $i++) {
		$uid .= @charArray[int(rand($#charArray))];
	}
	return $uid;
}