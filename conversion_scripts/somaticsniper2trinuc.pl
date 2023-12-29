#!/usr/bin/perl -w
use strict;

my $file = shift;
open(FILE,"< $file");
my $somaticSniper = 0;

my ($chr, $pos, $normal, $tumor);

if ($somaticSniper == 1) {
	$chr = 0;
	$pos = 1;
	$normal = 4;
	$tumor = 3;
} else {
	$chr = 0;
	$pos = 1;
	$normal = 2; # 2 or 7
	$tumor = 3; # 3 or 11
}

my %dict = (
	M => ["A","C"],
	R => ["A","G"],
	W => ["A","T"],
	S => ["C","G"],
	Y => ["C","T"],
	K => ["G","T"]
);


while (my $line = <FILE>) {
	chomp($line);
	my $match;
	my @f = split("\t",$line);
	for my $key (keys %dict) {
		if($f[$tumor] eq $key) {
			for my $alt (@{$dict{$key}}) {
				for my $subkey (keys %dict) {
					if ($f[$normal] eq $subkey) {
						for my $ref (@{$dict{$subkey}}) {
							if($ref eq $alt) {
								$match = $ref;
							}
						}
					}
				}
			}
		}
	}
	#if (defined $match) {print $match,"\n"}
	
	for my $key (keys %dict) {
		if($f[$tumor] eq $key) {
			for my $alt (@{$dict{$key}}) {
				my $bool = 0;
				for my $subkey (keys %dict) {
					if ($f[$normal] eq $subkey) {
						$bool = 1;
						for my $ref (@{$dict{$subkey}}) {
							if (defined $match) {
								if ($alt eq $match || $ref eq $match) {
									next;
								} elsif ($ref ne $alt) { 
									print "$f[$chr]\t$f[$pos]\t$ref\t$alt\n";
								}
							} else {
								if ($ref ne $alt) { 
									print "$f[$chr]\t$f[$pos]\t$ref\t$alt\n";
								}
							}
						}
					} 
				}
				
				if ($bool == 0) {
					my $ref = $f[$normal];
					if($ref ne $alt) {
						print "$f[$chr]\t$f[$pos]\t$ref\t$alt\n";
					}
				}
			}
		}
	}
}



