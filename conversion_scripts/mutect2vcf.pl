#!/usr/bin/perl -w
use strict;

my $reffile = "hg19.fasta";
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;

$mday = addZero($mday);
$mon = addZero($mon);

my $date = $year . $mon . $mday;

my $in = shift;
my $out = shift;

unless (defined $out) {
	$out = "$in.vcf";
}
open (OUT, "> $out");

open (IN, "< $in");

my ($tumor,$normal,$outtext);

while (my $line = <IN>) {
	next if $line =~ /^#/;
	chomp($line);
	my @f = split("\t",$line);

	my $contig=shift @f;
	my $pos=shift @f;
	my $context=shift @f;
	my $ref=shift @f;
	my $alt=shift @f;
	$tumor=shift @f;
	$normal=shift @f;
	my $score=shift @f;
	my $dbsnp=shift @f;
	my $covered=shift @f;
	my $power=shift @f;
	my $tumor_power=shift @f;
	my $normal_power=shift @f;
	my $total_pairs=shift @f;
	my $improper_pairs=shift @f;
	my $map_Q0_reads=shift @f;
	#my $init_t_lod=shift @f;
	my $t_lod_fstar=shift @f;
	my $tumor_f=shift @f;
	my $contam_fraction=shift @f;
	my $contam_lod=shift @f;
	my $t_ref_count=shift @f;
	my $t_alt_count=shift @f;
	my $t_ref_sum=shift @f;
	my $t_alt_sum=shift @f;
	my $t_ins_count=shift @f;
	my $t_del_count=shift @f;
	my $x = shift @f;
	$x = shift @f;
	my $normal_best_gt=shift @f;
	my $init_n_lod=shift @f;
	my $n_ref_count=shift @f;
	my $n_alt_count=shift @f;
	my $n_ref_sum=shift @f;
	my $n_alt_sum=shift @f;
	my $judgement=shift @f;

	my @vcf;
	#$tumor #normal
	@vcf = ($contig,$pos,$dbsnp,$ref,$alt,"999","PASS","SS=Somatic;TLOD=$t_lod_fstar,CLOD=$contam_lod","GT:RD:AD:FREQ:DP2:DP4","0/0:$n_ref_count:$n_alt_count:0.00:$n_ref_count,$n_alt_count:NA","0/1:$t_ref_count:$t_alt_count:$tumor_f:$t_ref_count,$t_alt_count:NA");
	#print join("\t", $tumor_f, $normal_best_gt),"\n";
	$outtext .= join("\t", @vcf) . "\n";
}
close(IN);

my $header = "##fileformat=VCFv4.1
##fileDate=$date
##source=varscan2vcf.pl
##reference=$reffile
##FORMAT=<ID=GT,Number=1,Type=String,Description=\"Genotype\">
##FORMAT=<ID=GQ,Number=1,Type=Integer,Description=\"Genotype Quality\">
##FORMAT=<ID=DP,Number=1,Type=Integer,Description=\"Read Depth\">
##FORMAT=<ID=AF,Number=1,Type=Integer,Description=\"Variant Allele Frequency\">
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	$normal	$tumor
";
print OUT $header;
print OUT $outtext;

close(OUT);


sub addZero { 
	my $num = shift;
	my $numstr = "$num";
	if ($num < 10) {
		$numstr = "0" . $num;
	}
	return $numstr;
}
