PYSAM

A python package for dealing with SAM/BAM/CRAM files etc

# Loading pysam

```python

import pysam
```

# Loading a BAM file

```python

# load the bam file into a AlignmentFile object
bamfile = pysam.AlignmentFile('example.bam', mode='rb')
# mode = 'r'    : reading
# mode = 'w'    : writing
# mode = 'b'    : specify you are reading or writing a BAM file. 'b' must immediately follow 'r' or 'w'

# check if an indexed bam (.bai) file exists
# if it doesn't, create it
import os
if os.path.isfile('example.bam.bai'):
    print("BAM index present... OK!")
else:
    print("No index available for pileup. Creating an index...")
    pysam.index('example.bam')
```

# Basic attributes

```python

# get list of references / contigs in loaded bamfile
# NOTE: I think it gets them from the BAM header
bamfile.references
```

# .pileup()

Iterate over aligned positions with .pileup()

```python

## to iterate over all positions, do not specify a stop coordinate
## alternatively, a samtools 'region' string can be applied, i.e. 'ergo_tig00000012:1000-2000'

## .pileup() returns all reads that overlap the specified region
## so if a read starts at pos 9995 and ends at 10095, it will be parsed

# if truncate=True (False by default) only consider positions between 0 and 10000 exactly
for pileupcolumn in bamfile.pileup(contig='contig1', start=0, stop=10000, truncate=True, ignore_orphans=None):

    # pileupcolumn is a PileupColumn object
    ## that represents a particular position in the reference
    ## and all the reads in the SAM/BAM file that map to it

    ## ignore_orphans=True by default
    ## ignore_orphans=False allows you to take into account orphan reads

    # get the reference position (0-indexed!)
    pileupcolumn.pos # deprecated
    pileupcolumn.reference_pos

    # get the coverage for the considered position
    pileupcolumn.get_num_aligned()
    ## .get_num_aligned() applies a base quality filter
    ## .get_num_aligned() includes reads that span this position as spliced alignments
    pileupcolumn.nsegments
    ## .nsegments ignores the base quality filter
    ## .nsegments includes reads that span this position as spliced alignments

    # reads aligned to the considered position are
    # which can be accessed with .pileups:
    for pileupread in pileupcolumn.pileups:

        # pileupread is a PileupRead object

        # .is_del returns 1 if at the considered position,
        # the aligned read has a deletion
        pileupread.is_del

        # .is_refskip returns 1 if at the considered position,
        # the aligned read has an 'N' in the CIGAR string
        # i.e. an RNA-seq read spanning an intron
        pileupread.is_refskip

        # .alignment returns an AlignedSegment object
        pileupread.alignment

        # .alignment.query_name returns the aligned read name
        pileupread.alignment.query_name

        # .alignment.query_sequence returns the sequence of the read,
        # including soft-clipped bases
        pileupread.alignment.query_sequence

        # .alignment.query_position returns the position within the read,
        # that is aligned at the considered position in the reference sequence
        # it is 0-indexed! 'None' if its a deletion or part of intron
        pileupread.alignment.query_position

        # get the base at the aligned position
        base = pilupread.alignment.query_sequence[pileupread.query_position]
```

# .fetch()

You can iterate directly over all read mappings aligned to a particular region using fetch().
`bamfile.fetch()` returns an Iterator of AlignedSegment objects

NOTE: unmapped reads can still be assigned to a particular contig, maybe because their partner was mapped to that contig
.fetch() will catch these also

NOTE: .fetch() will also return reads that are only partially overlapping with the region.
Thus the reads returned might span a region that is larger than the one queried.

NOTE: if you use contig=, start=, stop=, coordinates will be interpreted as 0-based, half open
      if you use region='chr1:15001-20000', coordinates are interpreted as 1-based, inclusive

```python

for read in bamfile.fetch(contig='chr1', start=100, stop=200):

    print(read)

    # read is an AlignedSegment object

    # return the id of the read
    read.query_name

    # return sequence of the aligned read, including soft-clipped bases
    read.query_sequence

    # read start and end 
    read.reference_start # 0-based
    read.reference_end   # 1-based # "reference_end points to one past the last aligned residue." - pysam readthedocs

    # you can retrieve the value of a particular 'tag' of the AlignedSegment object
    read.get_tag('XS')
    # the 'XS' tag in Hisat2 RNAseq alignments returns
    # ’+’ means a read belongs to a transcript on ‘+’ strand of genome
    # ‘-‘ means a read belongs to a transcript on ‘-‘ strand of genome

    # did the read map to the forward or reverse strand of the reference?
    # not to be confused with whether read is read1 (sometimes called forward read or R1) or read2 (sometimes called reverse read or R2)
    # this information comes from the FLAG bits 16
    read.is_reverse # FLAG bit 16 is on
    read.is_forward # FLAG bit 16 is off

    # is the read the first or second read in the pair (R1, or R2?)
    read.is_read1 # FLAG bit 64 is on
    read.is_read2 # FLAG bit 128 is on

    # you can get the CIGAR values as a list of tuples
    read.cigartuples
    # example: [(4, 9), (0, 91), (4, 1)]
    # 4 = 'S'oft clip, 0 = 'M'atch, 5 = 'H'ard clip
    # equivalent to 9S 91M 1S

    # return cigarstring of the alignment
    read.cigarstring
```

# .find_introns()

```python

# find introns with .find_introns()
rev_introns = bamfile.find_introns( (read for read in bamfile.fetch(contig='Seq_38') if read.is_reverse and read.is_mapped) )
fwd_introns = bamfile.find_introns( (read for read in bamfile.fetch(contig='Seq_38') if read.is_forward and read.is_mapped) )
## apparently the 'if read.is_reverse' condition is necessary, otherwise it will throw an error
## .find_introns() takes a read iterator as input (which bamfile.fetch() returns)
## or a generator that filter such an iterator (as in the example above)
## .find_introns() returns a dictionary {(start, stop): count}, e.g.
### (92040, 92072) 4
### (92414, 92444) 1
### (95461, 95699) 1
### (95867, 95897) 1
### (100855, 100883) 2
### (105442, 105475) 2
### (105680, 105715) 1
### (106948, 107542) 2

# coordinates are 0-indexed
# first coordinate is the first base in the intron (remember its 1-indexed in igv)
# second coordinate is the first base of the next exon (i.e. last base of the intron + 1)
```
