# #!/usr/bin/perl -w

# use Bio::DB::Query::GenBank;

# $query = "Arabidopsis[ORGN] AND topoisomerase[TITL] and 0:3000[SLEN]";
# $query_obj = Bio::DB::Query::GenBank->new(
#     -db    => 'nucleotide',
#     -query => $query);
# # Attempts to retrieve all Arabidopsis topoisomerases

# $query_obj2 = Bio::DB::Query::Genbank->new(
#     -query => 'gbdiv est[prop] AND Trypanosoma brucei [organism]',
#     -db    => 'nucleotide' );
# # Retrieves all Trypanosoma brucei ESTs

# The above created query objects but have not retrieved any sequences yet
use Bio::DB::GenBank;
use Bio::DB::Query::GenBank;

$query = "Arabidopsis[ORGN] AND topoisomerase[TITL] and 0:3000[SLEN]";
# Your Query

$query_obj = Bio::DB::Query::GenBank->new(
    -db    => 'nucleotide',
    -query => $query);
# Your query object, including the query and other properties for your query search

$gb_obj = Bio::DB::GenBank->new;
# Creates a genbank object

$stream_obj = $gb_obj->get_Stream_by_query($query_obj);
# ->get_Stream_by_query method takes query object as argument, and every hit 'fills up' your GenBank object. This filled up GenBank object is than assigned to $stream_obj

while ($seq_obj = $stream_obj->next_seq) {
    print $seq_obj->display_id, "\t", $seq_obj->length, "\n"
}
#->next_seq() method reads the $stream_obj and the first loop the first sequence is assigned to $seq_obj. In the second loop the second sequence, etc
# display_id() reads the $seq_obj and returns the id of the sequence . ->length() reads the $seq_obj and returns the length of the sequence.
