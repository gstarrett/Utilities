#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;

my $in = shift;
my $src = shift;
# convert gb to gtf
my $handle = Bio::SeqIO->new(-file => $in , -format => 'genbank');
# print CDS and exon
# chromosome, source, feature, start, end, score, strand, frame, gene_id; transcript_id;
# store $locus
# if (is CDS)
# if is complement set strand as "-" else "+"
# if contains join create n x "," entries
while (my $seqObj = $handle->next_seq) {
  my $version = $seqObj->seq_version;
  my $seqName;
  my $locus = $seqObj->display_id;
  my $gi = $seqObj->primary_id;
  $seqName = "gi|$gi|lcl|$locus.$version|";

  for my $featObj ($seqObj->get_SeqFeatures) {
    my $feat = $featObj->primary_tag;
    if ($feat eq "CDS") {
      my $start = $featObj->location->start;
      my $end = $featObj->location->end;
      my $strand = "+";
      if ($featObj->location->strand < 0) {
        $strand = "-";
      }
      my %tags;
      for my $tag ($featObj->get_all_tags) {
         for my $value ($featObj->get_tag_values($tag)) {
           push(@{$tags{$tag}}, $value);
         }
      }
      my $geneID = "";
      if (defined $tags{"gene"}) {
        $geneID = $locus . "-" . $tags{"gene"}[0];
      } elsif (defined $tags{"product"}) {
        $geneID = $locus . "-" . $tags{"product"}[0];
      }
      print join("\t", $seqName, $src, "CDS", $start, $end, "0", $strand, "0", "gene_id \"$geneID\"; transcript_id \"$geneID\";"), "\n";
      if ($featObj->location->isa('Bio::Location::SplitLocationI')) {
        for my $loc ($featObj->location->sub_Location) {
          my $subStart = $loc->start;
          my $subEnd = $loc->end;
          print join("\t", $seqName, $src, "exon", $subStart, $subEnd, "0", $strand, "0", "gene_id \"$geneID\"; transcript_id \"$geneID\";"), "\n";
        }
      } else {
        print join("\t", $seqName, $src, "exon", $start, $end, "0", $strand, "0", "gene_id \"$geneID\"; transcript_id \"$geneID\";"), "\n";
      }
    }
  }
}
