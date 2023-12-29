#!/usr/bin/perl -w
use strict;

my $in = shift;

my $n = 0;
open(IN, "< $in");
my $head = <IN>;
while(my $line = <IN>) {
  next if $line =~ /^$/;
  chomp($line);
  my @f = split("\t", $line);
  print ">", join("_", $n, @f[1,3,4]), "\n", $f[5], "\n";
  $n++;
}
