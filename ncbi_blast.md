# BLAST (NCBI BLAST+) #

#### Create a custom blast database
```sh
# standard way of doing it
makeblastdb \
    -in <sequence file> \
    -input_type <type: i.e. fasta> \
    -dbtype <nucl|prot> \
    -title <same as 'in'> \
    -out <same as 'in'>

# if you want to retrieve FASTA sequences of particular
# database entries later, you can use -parse_seqids
makeblastdb \
    -in <in.fasta> \
    -dbtype <nucl|prot> \
    -parse_seqids

# create index of sequence hash values
makeblastdb -hash_index
# Dayana:
# I believe it is the creation of a hash table that contains the mapping of sequence ids to fix identifiers that are used for computing speed and efficiency
```

#### Retrieve sequences from a custom blast database
```sh
blastdbcmd \
    -db <path/to/db> \
    -dbtype <nucl|prot> \
    -entry <comma delim string of sequence identifiers OR 'all' to get them all>
    -entry_batch <file, one entry per line>
    -out <path/to/out> \
    -outfmt %f
    -target_only

`-target_only` will force blastdbcmd to only retrieve the primary hits in case of MULTISPECIES entries.
Currently bugs because it fails on entries from PIR (Protein Information Resource, a db in NR). 
When it fails it quits prematurely rather than skipping the entry. Thus, your file will NOT contain all sequences, but only those up until the PIR hit.
```

NOTE on `-parse_seqids`:

- format your FASTA header like `>lcl|accession seq_description`, where `seq_description` is optional
- make sure that there is only one pipe `|` character in the sequence ID. It will complain otherwise
 
If `makeblastdb` complains about delta sequences, check for non-amino acid characters in the sequences with
```sh
grep -v ">" *.fasta | sed "s/\(.\)/\1\n/g" | sort | uniq -c
```
or check for headers that do not start at the beginning of the line.


#### Do a blastn search
```sh
# typical blastn search against a db
blastn \
    -query <path to query> \
    -db <database title> \
    -out <blast out file> \
    -evalue <i.e. 1e-5> \
    -perc_identity <integer> \
    -max_target_seqs <integer> \
    -num_threads <integer> \
    -outfmt <integer> (6 = tabular) \
    -max_hsps <integer>

# search for local alignments of query in a subject
# i.e., do a local alignment between two DNA sequences
blastn \
    -query <path to query> \
    -subject <path to subj> \
    -task <task>
# where <task> can be blastn, megablast, blastn-short, etc
# default = megablast
```

NOTE on `-max_target_seqs 1`:
It does not necessarily yield the top hit! It just means that it will stop searching after finding 1 hit.


NOTE on blastn 'tasks':
An interesting one is 'blastn-short', which is invoked with the flag -task blastn-short. It has a shorter word-length (7 instead of 11), a smaller reward for a nucleotide match (1 instead of 2), compared to standard blastn. This is a good mode when blasting primers against genomes or loci. Setting the E-value to 10 could also be useful to detect primers with mismatches.


#### Do a psiblast search
```sh
psiblast \
    -in_msa <file> \
    -db <path/to/db> \
    -out <path/to/out> \
    -evalue <i.e. 1e-10> \
    -num_threads <integer> \
    -outfmt '6 std stitle staxids'
```


Tabular format:
queryid	subjectid %id alnLength mismatchCount gapOpenCount queryStart queryEnd subjectStart subjectEnd eVal bitScore

Good fields to include on top of std in the blast tabular output:
slen 	    subject length
qlen	    query length
qcovs	    alignment length / query length * 100 (how much of query is aligned to hit? )
	    Takes into account all HSPs
qcovhsp	    Same as qcovs but then for each single hsp (not sure though; testing seems to verify this)
