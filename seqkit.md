# SEQKIT

#### Summary Statistics
```
# reports per fasta entry the name, the sequence, the length and %GC
seqkit fx2tab -lg <fasta>		
# reports per fasta entry the name, length and %GC, but not the sequence
seqkit fx2tab -nlg <fasta>		
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

# select sequences that are at least x long
seqkit seq -m 30 <fasta>
```

#### Select parts of sequences
```
# report sequence for 'ergo_tig00000012' but only for region 16000-17000
seqkit subseq --chr ergo_tig00000012 --region 16000:17000 consensus.fasta
```

#### Search for motifs
```
seqkit locate -p AFLEADRTGQA <fasta>
seqkit locate -rp AFLEADRTGQA.*VAPARS <fasta>  # use regexp
```

#### Make FASTA single line
```
seqkit seq --seq <fasta>
```

#### Translate DNA sequences 
```
# translate over all six frames
seqkit translate -f 6 <fasta>
cat <fasta> | seqkit translate -f 6
```
