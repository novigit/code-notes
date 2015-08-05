#!/usr/bin/perl -w

use Bio::DB::GenBank;
use Bio::SeqIO;

my $seq_obj;

$db_obj = Bio::DB::GenBank->new;
# create empty database object
$seq_obj = $db_obj->get_Seq_by_acc("J01673");
# retrieve sequence from genbank and fill $db_obj with it.
# After it is reassigned to $seq_obj


$seqio_obj = Bio::SeqIO->new(-file   => ">J01673.gb",
			     -format => "genbank");
# Create seqio object
# Do not forget the '>' here if you want to write a new file

$seqio_obj->write_seq($seq_obj);
# Write the retrieved sequence ($seq_obj) to the file specified in $seqio_obj
## $seq_obj = $seqio_obj->next_seq;

