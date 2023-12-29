#~/usr/bin/perl -w
use strict;

my $in = shift;
open(IN, "< $in");

my $refname = <IN>;
chomp($refname);
my $refseq = <IN>;
chomp($refseq);
my @ref = split('',$refseq);
my $seqname;

while (my $line = <IN>) {
  chomp($line);
  my $start;
  my $delseq = "";
  my $inseq = "";
  if ($line =~ /^>/) {
    $seqname = substr($line,2);
  } else {
    my @seq = split('',$line);
    for (my $i = 1; $i < $#ref-1; $i++) {
      if ($ref[$i] ne $seq[$i]) {
        if ($seq[$i] eq "-") {
          $delseq .= $ref[$i];
          if ($seq[$i-1] ne "-") {
            $start = $i;
          } elsif ($seq[$i-1] eq "-" && $seq[$i+1] eq "-") {
            next;
          } elsif ($seq[$i+1] ne "-") {
            my $sub = $delseq . ">" . $seq[$i];
            print join("\t",$seqname,$start,$i+1,$sub), "\n";
            $delseq = "";
          }

        } elsif ($ref[$i] eq "-") {
          $inseq .= $ref[$i];
          if ($seq[$i-1] ne "-") {
            $start = $i;
          } elsif ($ref[$i-1] eq "-" && $ref[$i+1] eq "-") {
            next;
          } elsif ($ref[$i+1] ne "-") {
            my $sub = $seq[$i] . ">" . $inseq;
            print join("\t",$seqname,$start,$i+1,$sub), "\n";
            $inseq = "";
          }
        } else {
          my $sub = $seq[$i-1]  . "[" . $ref[$i] . ">" . $seq[$i] . "]" . $seq[$i+1];
          print join("\t",$seqname,$i,$i+1,$sub), "\n";
      }
      }
    }
  }
  # convert mutations to bed and annotate with substitution type and convert indels to bed

}

# indel overlap with palindromes
# indel overlap with T[C>T]W mutations
# palindrome overlap with T[C>T]W mutations
