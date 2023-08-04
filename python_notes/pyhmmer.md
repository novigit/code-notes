pyhmmer

A python package that can run hmmer algorithms. It's supposed to be much faster

```py
import pyhmmer
from pyhmmer.easel import SequenceFile
from pyhmmer.plan7 import HMMFile
```

### Load a FASTA sequence file
```py
# this prefetches all sequences into memory
with SequenceFile("unaligned_toy.fasta", digital=True) as seq_file:
    seqs = seq_file.read_block()
```

### Load the HMM profiles file and do a search

There is a significant speed increase if you prepare a `.h3m` file from your
plain text HMM file, and then load that in your pyhmmer script

```sh
hmmconvert -b Pfam-A.hmm > Pfam-A.h3m
# or
hmmpress Pfam-A.hmm
# which creates a number of files, including an Pfam-A.h3m
```

If you want to do `hmmsearch`, hmms are the query, seqs are the targets

`cpus=0` automatically determines the optimal number of cpus to use.
`E=0.01`    sets the reporting E-value threshold for seq-E-value.
`domE=0.01` sets the reporting E-value threshold for dom-conditional-E-value.

```py
with HMMFile("Pfam-A.hmm.h3m") as hmm_file:
    for tophits in pyhmmer.hmmer.hmmsearch(hmm_file, seqs, cpus=0, E=0.01, domE=0.01):
        # 'tophit' is a 'TopHits' object
```

Note that the `Pfam-A.hmm.h3m` does not got loaded into memory all at once, 
hence the search and downstream stuff needs to be done while the file is opened
with the `with` statement.

If you want to do `hmmscan`, seqs are the query, hmms are the targets

```py
with HMMFile("Pfam-A.hmm.h3m") as hmm_file:
    for tophits in pyhmmer.hmmer.hmmscan(seqs, hmm_file, cpus=0, E=0.01, domE=0.01):
```

### A `TopHits` object

An oddly named object, for I find there is usually one `TopHits` object per search query.
The following attributes are also typically more associated with a query:

```py
# name and accession of query
# returns bytes type object
# use .decode() to get a string object
tophits.query_name
tophits.query_name.decode()
tophits.query_accession
tophits.query_accession.decode()

# E-value thresholds set by the user
tophits.E
tophits.incE
tophits.domE
tophits.incdomE

# hmm model specific bit score cutoff
tophits.bit_cutoffs

# the number of sequences used in search
# (as query or as target)
tophits.searched_sequence

# the number of hmm models used in search
# (as query or as target)
tophits.searched_models
```

A `TopHits` object is linked to one or more `Hit` objects
```py
# get an iterator of off Hits that satisfy the reporting E-value threshold
for hit in tophits.reported:
    # 'hit' is a Hit object
```

### A `Hit` object

A `Hit` seems to refer to a target sequence that has at least one HMM model matched to it, in case `hmmsearch`
Or to a HMM model that has at least one target sequence matched to it, in case of `hmmscan`

```py
# satisfies reporting and/or inclusion thresholds?
# returns True or False
hit.reported
hit.included

# name and description
# returns a bytes object
# use .decode() to get a string object
hit.name
hit.name.decode()
hit.description
hit.description.decode()

# seq-E-value
hit.evalue

# seq-bit-score
# after null2 bias correction
hit.score
```

A `Hit` object is linked to a `Domains` object and one or more `Domain` objects
```py
# iterate over Domain objects
for domain in hit.domains:
    # 'domain' is a Domain object

# iterate over Domain objects that satisfied the reporting i-E-value threshold
for domain in hit.domains.reported:
    # 'domain' is a Domain object
```
    
### A `Domain` object

```py
# satisfies reporting and/or inclusion thresholds?
# returns True or False
domain.reported
domain.included

domain.i_evalue
domain.c_evalue
domain.score
domain.bias
domain.env_from
domain.env_to
```

A `Domain` object is linked to an `Alignment` object,
which stores the maximum expected accuracy alignment
of the HMM model versus the target sequence for this
particular domain in the target sequence

```py
# returns Alignment object
domain.alignment
```

### An `Alignment` object

You can print the visual alignment
```
print(domain.alignment)
#                          HHHHHHHHHHHHSSGGSCHHHHHHHHHHHHHHHHHH CS
#               Globin  83 freallevlaeklgeeftpetkaawdklldviaaal 118
#                          ++++l+ vla+++g+eftp+++aa +k+++ +a+al
#  sp|Q9TT33|HBB_COLGU   1 LGNVLVCVLAHHFGKEFTPQVQAAYQKVVAGVANAL 36
#                          5789**************************999876 PP
```

Access particular attributes of the alignment
```py
domain.alignment.hmm_from
domain.alignment.hmm_to
domain.alignment.target_from
domain.alignment.target_to

domain.alignment.target_sequence
```




```py
# d = open("toy_vs_pfam.pyhmmer.domtblout", "wb")
# t = open("toy_vs_pfam.pyhmmer.tblout", "wb")

with HMMFile("Pfam-A.hmm.h3m") as hmm_file:
    # total = sum(len(hits) for hits in pyhmmer.hmmer.hmmsearch(hmm_file, seqs, cpus=0))
    # print(f"- hmmsearch with prefetching took {time.time() - t1:.3} seconds")

    # for tophits in pyhmmer.hmmer.hmmsearch(hmm_file, seqs, cpus=0, E=0.01, domE=0.01):
        # print(type(seq_hit))
        # each seq_hit is a TopHits object
        
    # for tophits in pyhmmer.hmmer.hmmsearch(hmm_file, seqs, cpus=0, E=0.01, domE=0.01):
    for tophits in pyhmmer.hmmer.hmmscan(seqs, hmm_file, cpus=0, E=0.01, domE=0.01):
        # if not top_hit.included:
        if not tophits.reported:
            continue

        print()
        # print("tophits.query_name: ", tophits.query_name)
        # print("tophits.query_accession: ", tophits.query_accession)
        # print("tophits.E: ", tophits.E)
        # print("tophits.incE: ", tophits.incE)
        # print("tophits.domE: ", tophits.domE)
        # print("tophits.incdomE: ", tophits.incdomE)
        # print("tophits.bit_cutoffs: ", tophits.bit_cutoffs)
        # print("tophits.searched_sequences: ", tophits.searched_sequences)
        # print("tophits.searched_models: ", tophits.searched_models)
        print(dir(tophit))

        # # each top_hit is a TopHits object
        # tophits.write(d, format="domains")
        # tophits.write(t, format="targets")

# d.close()
# t.close()
```
