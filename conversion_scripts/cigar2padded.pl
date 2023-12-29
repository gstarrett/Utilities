#!/usr/bin/perl -w
use strict;

my $in = shift;
my $rin = shift;
open(IN, "< $in");
open(REF, "< $rin");
chomp(my @rlines = <REF>);
my @ref = split("", $rlines[1]);
close(REF);
while (my $line = <IN>) {
  chomp($line);
  next if $line =~ /^@/;
  my @f = split("\t", $line);
  next if $f[2] =~ /\*/;
  my $i = 1; # for query sequence
  my $n = $f[3]; # for ref sequence
  my @cigar;
  my @g = split("_", $f[0]);
  my @seq = split("", $f[9]);
  while($f[5] =~ /([0-9]+[=MIDNSHPX])/g) {
    my $cxt = "*";
    my $dec = substr($1, 0, length($1)-1);
    my $cigar = substr($1, -1);
    if ($cigar =~ /[=M]/) {
      $i+=$dec;
      $n+=$dec;
    } elsif ($cigar eq "I") {
      if (defined $ref[$n-2] && defined @seq[$i-2..$i+$dec-2]) {
        print join("\t", $g[0], $n-2, $n-1, join("", $ref[$n-2]), join("", @seq[$i-2..$i+$dec-2]), "INS", $cxt), "\n";
      }
      $i+=$dec;
    } elsif ($cigar eq "D") {
      if (defined @ref[$n-2..$n+$dec-2] && defined $seq[$i-2]) {
        print join("\t", $g[0], $n-2, $n+$dec-1, join("", @ref[$n-2..$n+$dec-2]), join("", $seq[$i-2]), "DEL", $cxt), "\n";
      }
      $n+=$dec;
    } elsif ($cigar =~ /[NHSP]/) {
      $i+=$dec;
      $n+=$dec;
    } elsif ($cigar eq "X") {
      if ($dec == 1) {
        if (defined $seq[$i-2] && defined $seq[$i+$dec-1] && defined $ref[$n-1]) {
          $cxt = join("", $seq[$i-2], $ref[$n-1], $seq[$i+$dec-1]);
        }
      }
      if (defined @ref[$n-1..$n+$dec-2] && defined @seq[$i-1..$i+$dec-2]) {
        print join("\t", $g[0], $n-1, $n+$dec-1, join("", @ref[$n-1..$n+$dec-2]), join("", @seq[$i-1..$i+$dec-2]), "SUB", $cxt),"\n";
      }
      $i+=$dec;
      $n+=$dec;
    }
  }
}
close(IN);
