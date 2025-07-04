SAMTOOLS

# samtools view

## Viewing BAM files

```bash

# will print contents as SAM to the screen
samtools view BAM

# output lines in SAM format which have these contigs
samtools view BAM contig1 contig2

# view the header of a BAM/SAM file
samtools view -H BAM

# save a new bam file with header that only contains mappings on a particular contig
# -b to specify BAM output
samtools view -b BAM contig1 > test.contig1.bam
# NOTE: this still includes all the other contigs in the header of the new BAM file
# there is no straightforward way of also updating the header to only include the desired contigs


# -h to include SAM header in output
samtools view -bh BAM contig1 > test.contig1.bam
samtools view -bh BAM $(cat mycontigs.list | tr '\n' ' ') > test.contigs.bam

# filter out mapped reads with MAPQ quality lower than some integer
samtools view -bq 1 BAM > q1.bam # -b to specify output BAM

# view all reads associated with a certain region or particular position
samtools view BAM ergo_tig00000012:1000-2000
samtools view BAM ergo_tig00000012:1001-1001

# search for a specific read mapping by its id
samtools view BAM | grep 'read_id'

# view all read mappings that overlap with regions specified in a BED file
# NOTE: the keyword here is 'overlap'. Read mappings that have a start or end position outside
# the specified coordinates in the BED file, but still partially overlap with those coordinates
# are still selected!
samtools view -L <bed> BAM
# it may be slow! to speed up, specify the <bai> file with -M or --use-index <bai>
```

## Selecting certain read mappings

Keep mapped reads with certain FLAGs set

`-f FLAG` or `--require-flags FLAG`

Only output alignments with all bits set in FLAG present in the FLAG field
So lets say you specify FLAG 163, which has FLAGs 1, 2, 32, 128 set
it will select all alignments with FLAG 163, but also FLAG 419, which has FLAGs 1, 2, 32, 128 AND 256 set

```bash

samtools view -f 163 <bam>
```

`--rf FLAG` or `--incl-flags FLAG` or `--include-flags FLAG`

Only output alignments with any bit set in FLAG present in the FLAG field
So lets say you specify FLAG 163, which has FLAGs 1, 2, 32, 128 set
It will select all alignments which has any of these FLAGs set.
for example 81, which has FLAGs 1, 16, 64 set. It is selected because it has FLAG 1.

new option as of 1.15 ?

```bash

samtools view --rf 163 <bam>
```

`-F FLAG` or `--excl-flags FLAG` or `--exclude-flags FLAG`

Do  not  output alignments with any bits set in FLAG present in the FLAG field
so lets say you specify FLAG 73, which has FLAGs 1, 8 and 64 set
it will de-select all alignments which has any of these FLAGs set
in my case the only alignments left had FLAGs 0, 16, 256, 272
none of these flags have 1, 8 or 64 set

```bash

samtools view -F 73 <bam>

# omit secondary alignments
samtools view -F 256 <bam>
```

Combining `-f` and `-F` is possible
You can set multiple FLAGs in a comma separated list, but only with using flag-names
This is only possible as of at least from 1.14 onwards

```bash

samtools view -f 2 -F UNMAP,SECONDARY,QCFAIL,DUP
```

You can alternatively also simply add up the bits (4+256+512+1024 = 1796) and specify that

```bash

samtools view -f 2 -F 1796
```

## Subsampling read mappings

This could be useful if you have memory issues with viewing your BAM files in for example IGV or Tablet

```bash

# Select 25% random mappings
samtools view -s 0.25 -bh <bam> > <subsampled.bam>

# Ensure that you always select the same 25% random mappings by using a seed
samtools view -s 0.25 -bh <bam> -S 42 > <subsampled.bam>
```

## Counting reads 

```bash

# Counting mapped alignments    (because you exclude all unmapped reads with -F)
samtools view -c -F 4 <bam>

# Count mapped reads
samtools view -F 4 <bam> | cut -f1 | sort -u | wc -l
# or
samtools view -c -F 2308 <bam>
# 2308 = 4 (unmapped), 256 (not primary), 2048 (supplementary)

# Counting unmapped reads  (because you specify all unmapped reads with -f)
samtools view -c -f 4 <bam>
```

## Extracting reads that map to a certain strand

```bash

# From HISAT2 mappings, select those that stem from transcripts of the + strand
samtools view --tag XS:+ <bam>

# From HISAT2 mappings, select those that stem from transcripts of the - strand
samtools view --tag XS:- <bam>
```

# samtools sort

```bash

# sorts reads based on their left most coordinate
samtools sort <bam> -o <sorted.bam>

# NOTE that the order of contigs in the <sorted.bam> remains the same as it was in the <bam> file
```

# samtools index

```bash

samtools index <sorted.bam> <sorted.bam.bai>

## or simply
samtools index <sorted.bam>
## will automatically generated <sorted.bam.bai>

# multithreaded
samtools -@ <threads> <sorted.bam> <sorted.bam.bai>
```

# samtools cat

Concatenate multiple BAM or CRAM files 

```bash

samtools cat <sorted1.bam> <sorted2.bam> ... > <merged.bam>
samtools cat <sorted1.cram> <sorted2.cram> ... > <merged.cram>
```

# samtools mpileup

Piles up all reads and summarizes basecalls per read per site
Shows contig_name, position, reference basecall, number of reads, mapped bases, and their phred scores

Basic Usage

```bash

# pileup all sites in all contigs
samtools mpileup <bam> 

# specify a particular region 
# (contig:startpos-endpos) or base (startpos=endpos)
samtools mpileup <bam> -r ergo_tig00000012:108383-108383

# from pos 108383 until the last position
samtools mpileup <bam> -r ergo_tig00000012:108383-

# provide the fasta reference
samtools mpileup -f <fasta> <bam> -r ergo_tig00000012:108383-108383

# -a outputs all positions, including those with 0 depth
samtools mpilup -a <bam>
```

If <fasta> is not provided, the reference basecall is always N, and ACGTN refer to forward strand, acgtn to reverse strand
If <fasta> is provided, the reference basecall is reported, and ACGTN / actgn refer to MISMATCHES, and '.' forward and ',' reverse refer to matches

Samtools mpileup by default ignores
- orphans (reads that come from a pair, but are not in a proper pair in the read mapping). To count orphans use `-A`
- unmapped, secondary, qcfail and pcr dupl reads (the default setting of `--excl-flags`)
- low quality base calls (the default setting of -Q is 13)
- read segments that are an overlap with its read pair. This makes sense because you don't want to double count the same molecule twice when estimating coverage. To double count, use `--ignore-overlaps`


# samtools depth

Returns contigid, position, read depth

A lot faster than mpileup if you're solely interested in read depth

```bash

samtools depth <bam>

# return depth for a certain contig
samtools depth <bam> -r tig01

# return depth for a certain region
samtools depth <bam> -r tig01:80000-90000

# return depth for a certain region, from 80k to the end
samtools depth <bam> -r tig01:80000-

# also parse positions with zero coverage
samtools depth -a <bam>

# if you have the average function, report average coverage for <contig_name>
samtools depth -a <bam> -r <contig_name> | cut -f3 | average
```

## samtools rmdup

```bash

samtools rmdup <INPUT.SRT.BAM> <OUTPUT.SRT.RMDUP.BAM>
```


# samtools tview

View a particular region of the alignment within your terminal - pretty cool!
This is nice if you want to check something quick visually but dont want to transfer the file so you can inspect it with Tablet
There is also a consensus line

```bash

# view a certain region
samtools tview [bam] [fasta] -p ergo_tig00000012:2165-2175

# go directly to position 2569
samtools tview [bam] [fasta] -p ergo_tig00000012:2569
```

```
# while in tview, press '?' for interactive controls
## underlined reads - orphans or secondary read mappings
## blue reads   - mapping quality 0-9
## green reads  - mapping quality 10-19
## yellow reads - mapping quality 20-29
## white reads  - mapping quality >30

## ? samtools tview reports N's in the reference line where reads do not align ? also when --reference is given
```


# samtools idxstats

Retrieves information from the <bai> file
Output is tab delimited:
Reference sequence name, sequence length, # mapped read segments, # unmapped read segments
Report length and number of mapped reads per contig

```bash
samtools idxstats <bam>
```

# samtools flagstat
## count the number of read mappings for each FLAG type
## reports per type the number of QC-pass and QC-fail
## e.g. 17340381 + 0 mapped (99.44% : N/A)
## meaning 17 340 381 QC-pass reads mapped, and 0 QC-fail reads mapped
samtools flagstat <bam>

# samtools stats
samtools stats <bam>


# various samtools snippets
## standard samtools pipeline
samtools view -bS [sam] > [bam]		# -b / --bam : output in the BAM format, -S : deprecated, previously required to say input was SAM
samtools sort [bam] -o [srt.bam]
samtools index [srt.bam] [srt.bam.bai]



SAM FORMAT
    FIELD   DESCRIPTION
1	QNAME	Query template name
2	FLAG	Bitwise flag
3	RNAME	Reference sequence name
4	POS	    Leftmost mapping position
5	MAPQ	Mapping quality
6	CIGAR	Cigar string
7	RNEXT	Reference name of the other paired end read
8	PNEXT	Position of the other paired end read
9	TLEN	Observed template length
10	SEQ	    Segment sequence
11	QUAL	Phred score

For segments that have been mapped to the reverse strand (of the reference), the recorded SEQ is reverse complemented from the original unmapped sequence and CIGAR, QUAL, and strand sensitive optional fields are reversed and thus recorded consistently with the sequence bases as represented


FLAG - Bitwise flag
The flag number can only be the sum of a specific set of bits,
each of which indicate a property of the read mapping

Decimal	Hexadec.    Flag name     	Explanation

0	    0x0			None of the bitwise flags are set. So essentially
	       			- the read doesn't have a paired mate
					- the read is mapped
					- the read maps to the forward strand
					- it is the primary mapping of this read
					- read passed QC
					- read is not a PCR or optical duplicate

1	    0x1		    PAIRED		    Read has a paired mate
2	    0x2		    PROPER_PAIR	    Read mapped in 'proper pair'*
4	    0x4		    UNMAP		    Read was not mapped	
8	    0x8		    MUNAP		    Mate was not mapped
16	    0x10		REVERSE		    Read maps to reverse strand (aka read had to be revcomp'd to map)
32	    0x20		MREVERSE	    Mate maps to reverse strand (aka read had to be revcomp'd to map)
64	    0x40		READ1		    First read of pair
128	    0x80		READ2		    Second read of pair
256	    0x100		SECONDARY	    Not primary mapping of this read
512	    0x200		QCFAIL		    Read failed platform/vendor quality checks
1024	0x400		DUP		        Read is a PCR or optical duplicate
2048	0x800		SUPPLEMENTARY	Read mapping is supplementary alignment **

(from samformat.info/sam-format-flag)

* A proper pair is most likely one where both reads are properly oriented
(for example one mapping on the forward strand, the other on the reverse strand)
and within the expected distance of each other (specified by your mapping command, e.g. with bowtie2 or hisat2)

** When a read alignment can not be represented as a single 'linear alignment' (as normal) it is represented as a 'chimeric alignment'.
A chimeric alignment is represented as a set of linear alignments that do not have large overlaps.
Typically, one of these alignments is considered the 'representative' and the others are called 'supplementary' and are
distinguished by the supplementary 2048 or 0x800 bitwise FLAG.


A segment = A contiguous sequence or subsequence

MAPs - Mapping Quality

MAPQ: log(probability mapping is wrong) * -10
so lets say probability mapping is wrong is 0.01,
log(0.01)  = -2.   -2 * -10 = 20
log(0.001) = -3.   -3 * -10 = 30
so MAPQ = 60, corresponds to Pr(mapping is wrong) = 0.000001
MAPQ = 1,  corresponds to Pr(mapping is wrong) = 0.79
But, MAPQs are calculated differently based on mapping software,
and it is apparently not well documented 


THE CIGAR STRING

M   Alignment match (includes sequence matches AND mismatches)
I   Insertion in the read relative to the reference
D   Deletion in the read relative to the reference
N   Only applies with mRNA-to-genome alignments. Essentially many deletions in a row in the read relative to the reference. Meant to indicate introns
S   Soft clipping. Terminal ends of the read (5' or 3') that are not part of the alignment but are still reported in the SEQ field
H   Hard clipping. Terminal ends of the read (5' or 3') that are not part of the alignment and are also not reported in the SEQ field
P   Padding. A deletion in the read relative to another read which also has an insertion (but of a different length) at the same place relative to the reference
=   If Alignment Match (M), specifies whether its a sequence match
X   If Alignment Match (M), specifies whether its a sequence mismatch

Some of these letters can also be called "operations". For example, the N operation of the CIGAR string

Other coding names used for these operations

M 	BAM_CMATCH 	0
I 	BAM_CINS 	1
D 	BAM_CDEL 	2
N 	BAM_CREF_SKIP 	3
S 	BAM_CSOFT_CLIP 	4
H 	BAM_CHARD_CLIP 	5
P 	BAM_CPAD 	6
= 	BAM_CEQUAL 	7
X 	BAM_CDIFF 	8
B 	BAM_CBACK 	9
