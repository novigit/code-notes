#!/usr/bin/perl -w
use strict;

use Bio::SeqIO;

my $fa = $ARGV[0];

# Create SeqIO object from read file
my $in = Bio::SeqIO->new(-format => 'fasta',
			 -file   => $fa);

my $seq_count = 0;
my $base_count = 0;

# Loop over the sequences with ->next_seq
while (my $seq = $in->next_seq ) {
    $seq_count++;
    $base_count += $seq->length;           # ->length() returns length of one sequence
    print $seq->id, "\n";                  # ->id() returns the identifier of the sequence (everything after the '>')
    print $seq->
}

print "Sequences ", $seq_count, "\n";
print "Bases ", $base_count, "\n";

# # Create SeqIO object for out file
# my $out = Bio::SeqIO->new(-format => 'genbank',
# 			  -file   => ">test.gbk");
# # Write to outfile with ->write_seq()
# # First loop over in file with ->next_seq()
# while (my $seq = $in->next_seq) {
#     $out->write_seq($seq);                 # Writes the contents of $seq to $out, which is genbank format
# }
