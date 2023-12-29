#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;

my $in = shift;
# convert gb to gtf
my $handle = Bio::SeqIO->new(-file => $in , -format => 'genbank');
# print CDS and exon
# chromosome, source, feature, start, end, score, strand, frame, gene_id; transcript_id;
# store $locus
# if (is CDS)
# if is complement set strand as "-" else "+"
# if contains join create n x "," entries
while (my $seqObj = $handle->next_seq) {
  my $seqName = $seqObj->accession_number();
  next if $seqName eq "unknown";
  for my $featObj ($seqObj->get_SeqFeatures) {
    my $feat = $featObj->primary_tag;
    if ($feat eq "CDS") {
      my $start = $featObj->location->start;
      my $end = $featObj->location->end;
      my $strand = $featObj->location->strand;
      my %tags;
      for my $tag ($featObj->get_all_tags) {
         for my $value ($featObj->get_tag_values($tag)) {
           push(@{$tags{$tag}}, $value);
         }
      }
      my $geneID = "";
      if (defined $tags{"gene"}) {
        $geneID = $tags{"gene"}[0];
      } elsif (defined $tags{"product"}) {
        $geneID = $tags{"product"}[0];
      } elsif (defined $tags{"note"}) {
        $geneID = $tags{"note"}[0];
      } else {
        next;
      }
      my $seq = $featObj->spliced_seq->seq;
      my $translation = $featObj->spliced_seq->translate->seq;
      print join("\t", $seqName, "CDS", $start, $end, $strand, $geneID, $seq, $translation), "\n";
      if ($featObj->location->isa('Bio::Location::SplitLocationI')) {
        for my $loc ($featObj->location->sub_Location) {
          my $subStart = $loc->start;
          my $subEnd = $loc->end;
          print join("\t", $seqName, "exon", $subStart, $subEnd, $strand, $geneID, "", ""), "\n";
        }
      } else {
        print join("\t", $seqName, "exon", $start, $end, $strand, $geneID, "", ""), "\n";
      }
    }
  }
}
