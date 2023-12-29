#!/usr/bin/perl -w
use strict;

my $reffile = "hg19.fasta";
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;
my $filename = shift;
my $outfile = "$filename.vcf";
my $fileCol = shift;

my %ambHash = (
	"M" => ["A","C"],
	"R" => ["A","G"],
	"W" => ["A","T"],
	"S" => ["C","G"],
	"Y" => ["C","T"],
	"K" => ["G","T"],
	"V" => ["A","C","G"],
	"H" => ["A","C","T"],
	"D" => ["A","G","T"],
	"B" => ["C","G","T"],
);

unless (defined $fileCol) {
	$fileCol = $filename;
}

my $hbool = 1;

$mday = addZero($mday);
$mon = addZero($mon);

my $date = $year . $mon . $mday;

#print $date,"\n";
##contig=<ID=20,length=62435964,assembly=b37,species=\"Homo sapiens\",taxonomy=x> #saving for later
my $header = "##fileformat=VCFv4.1
##fileDate=$date
##source=varscan2vcf.pl
##reference=$reffile
##FORMAT=<ID=GT,Number=1,Type=String,Description=\"Genotype\">
##FORMAT=<ID=GQ,Number=1,Type=Integer,Description=\"Genotype Quality\">
##FORMAT=<ID=DP,Number=1,Type=Integer,Description=\"Read Depth\">
##FORMAT=<ID=AF,Number=1,Type=Integer,Description=\"Variant Allele Frequency\">
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	Normal	$fileCol
";
open(FILE,"< $filename");
open(OUT, "> $outfile");
if ($hbool == 1) {
	my $inh = <FILE>;
}
print OUT $header;
while (my $line = <FILE>) {
	chomp($line);
	my @f = split("\t", $line);
	my $TDP = join(",",@f[15,16,17,18]);
	my $NDP = join(",",@f[19,20,21,22]);
	my ($tgt,$ngt);
	my $TAF = substr($f[10],0,-1);
	my $NAF = substr($f[6],0,-1);
	$TAF = $TAF/100;
	$NAF = $NAF/100;
	if ($f[12] eq "Germline") {
		$tgt="1/1";
		$ngt="1/1";
	} elsif ($f[12] eq "Somatic") {
		$tgt="0/1";
		#print $f[7],"\n";
		if ($f[7] =~ /$f[2]/) {
			$ngt="0/0";
		} else {
			$ngt="1/1";
		}
	} elsif ($f[12] eq "LOH") {
		$ngt="0/1";
		if ($f[11] =~ /$f[3]/) {
			$tgt="1/1";
		} else {
			$tgt="0/0";
		}
	} else {next}
	print OUT join("\t", $f[0],$f[1],".",$f[2],$f[3],999,"PASS","SS=$f[12];GPV=$f[13];SPV=$f[14]","GT:RD:AD:DP4:FREQ:DP2","$ngt:$f[4]:$f[5]:$NDP:$NAF:NA","$tgt:$f[8]:$f[9]:$TDP:$TAF:NA"),"\n";
}

close(FILE);
close(OUT);

sub addZero { 
	my $num = shift;
	my $numstr = "$num";
	if ($num < 10) {
		$numstr = "0" . $num;
	}
	return $numstr;
}
