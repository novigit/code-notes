BIOPYTHON

A python package for dealing with all sorts of molecular sequence data

# SeqIO

## Load a FASTA file

```python

# load package SeqIO
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord

# loading FASTA files

# parse a multi FASTA file
## each 'record' is a SeqRecord object
## SeqIO.parse() returns an iterator of SeqRecord objects
for record in SeqIO.parse('example.fasta','fasta'):
    print(record.id)

# load a FASTA file with only one entry
record = SeqIO.read('example.fasta','fasta')

# load only the first sequence in a FASTA file
first_record = next(SeqIO.parse('example.fasta', 'fasta'))

# turn an iterator or list of SeqRecord objects into a dictionary of SeqRecord objects
# SeqRecord objects are the values, and keys are extracted from records using a key_function
# if no key_function is specified, it will take the record.id by default
records = SeqIO.parse('example.fasta', 'fasta')
record_dict = SeqIO.to_dict(records, key_function=lambda rec: rec.name)

# load a multi FASTA file such that you can access a particular sequence later
## load multi FASTA into a dictionary in memory
record_dict = SeqIO.index('example.fasta', 'fasta')
## NOTE: this is a dictionary-like object, not a pure python dictionary,
## as generated with SeqIO.to_dict

## load desired record from dict
desired_record: SeqRecord = record_dict['example_seqID']
```

# SeqRecord objects

```python

# get the id of the SeqRecord
record.id

# get the length of the sequence of the SeqRecord
len(record) # or
len(record.seq)

# get the sequence string
str( record.seq )

# get the Seq object of a SeqRecord object
record.seq

# get a subsequence (as a Seq object) from a sequence in a Seq object
record.seq[0:300]

# get sequence of a sequence substring in string format in one line
fasta = SeqIO.index('example.fasta', 'fasta')
region_seq = str( fasta[contig_id].seq[start-1:end] )
```

#### Iterate over a SeqIO.index() object
```python
## load multi FASTA into a dictionary in memory
fasta_db = SeqIO.index('example.fasta', 'fasta')
for record_id in fasta_db:
    print(record_id)

for record_id, record in fasta_db.items():
    print(len(record))

for record in fasta_db.values():
    print(len(record))
```

#### AlignIO

##### Load a Alignment file
```py
from Bio import AlignIO
alignment = AlignIO.read('example.aln', 'fasta')

# alignment is a MultipleSeqAlignment object
```

##### MultipleSeqAlignment object
```py
# return the length of the alignment
alignment.get_alignment_length()

# each sequence in the alignment object is a SeqRecord object
for record in alignment:
    print(f'record: {record.id})

# alignment record id
record.id

# alignment record seq
record.seq

# merging two alignment objects vertically
# for example same gene, same alignment length, two different sets of taxa

# create a fresh, empty object
new_alignment = MultipleSeqAlignment([])

# populate it with two alignments
new_alignment.extend(alignment1)
new_alignment.extend(alignment2)

# merging two alignment objects horizontally
# for example concatenating two different gene alignments that have the same taxa
new_alignment = alignment1 + alignment2
# NOTE: for this to work the identifiers must be exactly the same and in the same order in both alignment objects
```

##### Writing a new alignment file
```py
from Bio.Align import MultipleSeqAlignment

# creating a new object with existing records
new_alignment = MultipleSeqAlignment(
    [ record1, record2, record3 ]
)


from Bio import AlignIO
AlignIO.write(new_alignment, 'new_alignment.fasta', 'fasta')
```



#### SearchIO

##### Load a hmmsearch --domtblout file
```python
# load package SearchIO
from Bio import SearchIO

# load a hmmsearch --domtblout results file
hmmsearch_result = SearchIO.parse('example.domtblout','hmmsearch3-domtab')
# hmmsearch_result is a generator of QueryResult objects
```

##### QueryResult objects

There is one QueryResult object per query hmm profile in the domtblout file

```python
# print the results
for qr in hmmsearch_result:
    print(qr)

# get the first result
qr = next(hmmsearch_result)

# qr is a QueryResult object, with certain attributes
# those taken directly from domtblout
qr.id        # e.g. '1-cysPrx_C', the name of the hmmsearch Query
qr.accession # e.g. 'PF10417.8', the accession ID of the hmmsearch Query
qr.seq_len   # full length of the Query sequence

# other attributes
qr.program   # i.e. 'blastn', 'hmmer3', or if not stated in the output 'unknown_program'
qr.version   # i.e. '2.2.27+', or if not stated in the output 'unknown_version'
qr.hits      # returns a list of Hit objects
qr.hit_keys  # returns a list of keys of Hit objects, i.e. the IDs of the hits

# you can also apply methods over QueryResult objects
len(qr)      # returns the number of hits (i.e. Hit objects) the query has
```

A QueryResult object can be broken down to a number of Hit objects

##### Extract Hit objects from QueryResult objects

```python
# a QueryResult is sort of like a hybrid between a list and a dictionary
# it is iterable, and each iteration returns a Hit object
for hit in qr:
    print(hit)

## get the top hit and second hit
top_hit = qr[0]
sec_hit = qr[1]

## get the last hit
last_hit = qr[-1]

## get the hit with the id 'example_id'
selected_hit = qr['example_id']`

# filter out Hit objects from a QueryResult
has_multiple_hits = lambda hit : len(hit.hsps) > 1
## hit.hsps    - returns a list of HSP objects (High Scoring Pairs)
filtered_qr = qr.hit_filter(has_multiple_hits)
```

#### Hit objects
```python
# extract and print a Hit object
hit = qr[0]
print(hit)

# Query: 1-cysPrx_C
#        <unknown description>
#   Hit: tig00000492_frame=-1 (722451)
#        -
#  HSPs: ----  --------  ---------  ------  ---------------  ---------------------
#           #   E-value  Bit score    Span      Query range              Hit range
#        ----  --------  ---------  ------  ---------------  ---------------------
#           0   4.5e-06      19.90       ?           [0:39]        [240953:240988]
#           1   4.5e-06      19.90       ?           [0:39]        [267833:267868]
#           2   4.5e-06      19.90       ?           [0:39]        [284524:284559]
#           3         8      -0.10       ?           [8:23]        [431071:431086]

# Hit object attributes
# those taken directly from domtblout
hit.id              # ID of the Hit (TargetSequence)
hit.accession       # Accession of the Hit
hit.seq_len         # Length of the Hit sequence
hit.evalue          # Hit-level E-value
hit.bitscore        # Hit-level bitscore
hit.bias            # Hit-level bias

# other attributes
hit.query_id          # ID   of the Query tied to the Hit
hit.query_description # Desc of the Query tied to the Hit
len(hit)              # returns the number of HSPs tied to the Hit
```


##### Extract Hit objects from QueryResult objects
```python
# a Hit object is essentially a simple list of HSP objects and is iterable
for hsp in th:
    print(hsp)
# get the top HSP
hsp = th[0]
```

#### HSP objects
```python
# print a HSP object
hsp = th[0]
print(hsp)

#       Query: 1-cysPrx_C <unknown description>
#         Hit: tig00000492_frame=-1 -
# Query range: [0:39] (0)
#   Hit range: [240953:240988] (0)
# Quick stats: evalue 4.5e-06; bitscore 19.90
#   Fragments: 1 (? columns)

# HSP object attributes
# those directly taken from domtblout
hsp.domain_index # domain number
hsp.evalue_cond  # c-Evalue
hsp.evalue       # i-Evalue
hsp.bitscore
hsp.bias
hsp.query_start  # hmm-From (0-indexed)
hsp.query_end    # hmm-To   (1-indexed)
hsp.hit_start    # start coordinate of the Hit sequence, 0-based
hsp.hit_end      # end   coordinate of the Hit sequence, 1-based
hsp.env_start    # env-From (0-indexed)
hsp.env_end      # env-To   (1-indexed)
hsp.acc_avg      # acc
hsp.description  # HitDescription

# those calculated from domtblout
hsp.query_range  # tuple with (query_start, query_end)
hsp.query_span   # length of Query that is aligned
hsp.hit_span     # length of Hit   that is aligned
hsp.aln_span     # length of alignment
```




