#!/usr/bin/perl -w

use Bio::Seq;
use Bio::SeqIO;

$seq_obj = Bio::Seq->new(-seq => "aaaatgggggggggggccccgtt",
			 -display_id => "#12345",
			 -desc => "example 1",
			 -alphabet => 'dna' );

$seqio_obj = Bio::SeqIO->new(-file => '>sequence.fasta',
			     -format => 'fasta' );
# print $seq_obj->seq;

$seqio_obj->write_seq($seq_obj);
