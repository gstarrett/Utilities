#! /usr/bin/perl -w
use strict;
use Data::Dumper;

my $indir = shift;

opendir(DIR, $indir);
my @eDnbs = grep {/evidenceDnbs/} readdir(DIR);
closedir(DIR);

my $ref = "/home/harrisr/starrett/hg19.crr";
my $cgatools = "/home/harrisr/starrett/cgatools/bin/cgatools evidence2sam --beta";

my $command;

for my $infile (@eDnbs) {
	next if $infile =~ /chrM/;
	#print $infile,"\n";
	my @filename = split('\.', $infile);
	#print Dumper(@filename);
	my $outfile = $filename[0];
	$command .= "$cgatools --mate-sv-candidates --add-mate-sequence --add-unmapped-mate-info -e $indir/$infile -s $ref | samtools view -Sbu - | samtools sort - $indir/$outfile.sort &\n";
}


my $pbsScript = <<"END";
#!/bin/bash -l
#PBS -l nodes=1:ppn=24,mem=62gb,walltime=24:00:00
#PBS -M starr114\@umn.edu
#PBS -m abe

module load samtools

$command

wait
END

my $rnum = int(rand(100));

open(OUT, "> evidence2sam$rnum.pbs");

print OUT $pbsScript;

close(OUT);

system("qsub evidence2sam$rnum.pbs");