#!/usr/bin/perl -w

use Bio::DB::GenBank;

$db_obj = Bio::DB::GenBank->new;           
# Creates an empty 'database object'

$seq_obj = $db_obj->get_Seq_by_id(2);      
# Retrieves the sequence from the database, in this case GenBank. 
# Identifier used here is by GI number
# You can also use 
# ->get_Seq_by_acc()
# ->get_Seq_by_version()

print "$seq_obj";

