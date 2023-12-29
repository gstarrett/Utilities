#!/usr/bin/perl -w
use strict;
my $in = shift;
open(IN, "< $in");
my $head = <IN>;
my $n = 0;
while(my $line = <IN>) {
  next unless $line =~ /->/;
  chomp($line);
  my @f = split("\t", $line);
  my @g = split(";", $f[1]);
  my $seq = $f[5];
  foreach(@g) {
    #print $_, "\n";
    next unless $_ =~ /->/;
    my @h = split(":", $_);
    my @j = split("->", $h[1]);
    my $trint = substr($seq, $h[0]-1, 3);
    print join("\t", $n, $f[0], @j, $h[0], $trint), "\n";
  }
  $n++;
}
