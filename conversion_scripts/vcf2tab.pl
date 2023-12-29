#!/usr/bin/perl -w
use strict;

my $in = shift;
open(IN, "< $in");
while(my $line = <IN>) {
  next if $line =~ /^#/;
  my (@g1, @h1, @go, @ho);
  chomp($line);
  my @f = split("\t", $line);
  my @g = split(";", $f[7]);
  foreach (@g) {
    @g1 = split("=", $_);
    push(@go, $g1[1]);
  }
  my @h = split(":", $f[9]);
  foreach (@h) {
    @h1 = split(",", $_);
    for my $h2 (@h1) {
      push(@ho, $h2);
    }
  }
  print join("\t", @f[0..6], @go, @ho, $in), "\n";
}
