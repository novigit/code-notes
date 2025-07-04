SEQKIT

# Summary Statistics

```bash

# reports per fasta entry the name, the sequence, the length and %GC
seqkit fx2tab -lg [fasta]

# reports per fasta entry the name, length and %GC, but not the sequence
seqkit fx2tab -nlg [fasta]

# get number of contigs, total length, min/max length, N50
seqkit stats -a [fasta]
```

# Visual aid

```bash

# color FASTA files
seqkit seq --color [fasta] | less -R
```

# Selecting sequences

```bash

# extract a single entry
seqkit grep -p [regexp] [fasta]

# delete a single entry
seqkit grep -v -p [regexp] [fasta]

# extract using a list of headers
seqkit grep -f headers.list [fasta]
# NOTE: this does not print the out FASTA in the same order as in headers.list

# extract using a list of headers - in order
# -rp if patterns are regexp
# -p  if patterns are not regexp
for header in $(cat headers.list); do seqkit grep -rp $header [fasta]; done

# select sequences that are at least x long
seqkit seq -m 30 [fasta]
```

# Select parts of sequences

```bash

# report sequence for 'ergo_tig00000012' but only for region 16000-17000
# coordinates are 1-indexed
seqkit subseq --chr ergo_tig00000012 --region 16000:17000 consensus.fasta

# select the last 20000 bases of a contig
seqkit subseq --chr ergo_tig00000012 --region -20000:-1 consensus.fasta

# extract sequences of particular regions using a BED file
seqkit subseq --bed [bed] [fasta]
```

# Splitting FASTA files

Split a single multiFASTA file into many singleFASTA files

```bash

seqkit split -i [fasta]
```

# Search for motifs

By default searches the given strand and its reverse complement

```bash

seqkit locate -p AFLEADRTGQA [fasta]

# using regexp
seqkit locate -rp AFLEADRTGQA.*VAPARS [fasta]
```

# Formatting FASTA files

```bash

# make FASTA single line
seqkit seq -w 0 [fasta]

# make FASTA multi line
## good if you've edited a multiline fasta file and
## the linewidths are not equal anymore for some reason
seqkit seq -w 60 [fasta]

# only print sequence, not headers
seqkit seq -s [fasta]

# force upper case
seqkit seq -u [fasta]

# reverse complement sequences in a FASTA file
seqkit seq -rp [fasta]
```

# Index the FASTA file

```bash
seqkit faidx [fasta]
```

# Translate DNA sequences 

```bash
# translate over all six frames
seqkit translate -f 6 [fasta]
cat <fasta> | seqkit translate -f 6

# append frame information in sequence identifier
seqkit translate -F -f6 [fasta]
# >CU914152.1_frame=1
# >CU914152.1_frame=2
# >CU914152.1_frame=3
# >CU914152.1_frame=-1
# >CU914152.1_frame=-2
# >CU914152.1_frame=-3
```
