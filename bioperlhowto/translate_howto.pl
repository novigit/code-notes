#!/usr/bin/perl -w
use strict;

use Bio::SeqIO;

my $file = $ARGV[0];

my $in = Bio::SeqIO->new(-format   => 'fasta',
			 -alphabet => 'dna',
			 -file     => $file);

while (my $seq = $in->next_seq) {
    my $tl = $seq->translate(-orf => 1);
    print $tl->seq, "\n";
}

