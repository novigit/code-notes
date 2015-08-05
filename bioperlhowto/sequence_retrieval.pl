#!/bin/perl -w

use Bio::SeqIO;

$seqio_obj = Bio::SeqIO->new(-file => "sequence.fasta",
			     -format => "fasta" );

$seq_obj = $seqio_obj->next_seq;

while ($seq_obj = $seqio_obj->next_seq) {
    # print the sequence
    print $seq_obj->,"\n";
}
