 SEQKIT

#### Summary Statistics
```
# reports per fasta entry the name, the sequence, the length and %GC
seqkit fx2tab -lg <fasta>		

# reports per fasta entry the name, length and %GC, but not the sequence
seqkit fx2tab -nlg <fasta>		

# get number of contigs, total length, min/max length, N50
seqkit stats -a <fasta>
```

#### Visual aid
```
# color FASTA files
seqkit seq --color <fasta> | less -R    
```

#### Selecting sequences
```
# extract a single entry
seqkit grep -p <regexp> <fasta>

# extract using a list of headers
seqkit grep -f headers.list <fasta>
# NOTE: this does not print the out FASTA in the same order as in headers.list

# extract using a list of headers - in order
# -rp if patterns are regexp
# -p  if patterns are not regexp
for header in $(cat headers.list); do seqkit grep -rp $header <fasta>; done

# select sequences that are at least x long
seqkit seq -m 30 <fasta>
```

#### Select parts of sequences
```
# report sequence for 'ergo_tig00000012' but only for region 16000-17000
seqkit subseq --chr ergo_tig00000012 --region 16000:17000 consensus.fasta

# extract sequences of particular regions using a BED file
seqkit subseq --bed <bed> <fasta>
```

#### Search for motifs

By default searches the given strand and its reverse complement

```
seqkit locate -p AFLEADRTGQA <fasta>
seqkit locate -rp AFLEADRTGQA.*VAPARS <fasta>  # use regexp
```

#### Formatting FASTA files
```
# make FASTA single line
seqkit seq -w 0 <fasta>

# make FASTA multi line
## good if you've edited a multiline fasta file and
## the linewidths are not equal anymore for some reason
seqkit seq -w 60 <fasta>
```

#### Translate DNA sequences 
```
# translate over all six frames
seqkit translate -f 6 <fasta>
cat <fasta> | seqkit translate -f 6
```
