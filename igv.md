IGV

### Some random notes

#### Online user guide
https://igv.org/doc/desktop/#


#### Quick consensus mode
According to https://www.pacb.com/blog/igv-3-improves-support-pacbio-long-reads/,
a "mode that suppresses single read random errors"

The quick consensus mode shows mismatches only at positions where more than a specified 
fraction of reads disagrees with the reference (recommended setting: 25%).  
The logic is the same as used by the coverage track.

Threshold can be set here
View -> Preferences -> Alignments -> Coverage allele fraction threshold (default 0.2)


#### Default read mapping labeling
Read mappings that appear TRANSPARENT with a SOLID OUTLINE are those that have mapping quality of 0.

If you mapped with BWA-MEM or one of its derivatives (e.g. BWA-MEM2), a MAPQ of 0 can mean that it was
a read stemming from a repeat region, and the mapper doesn't know which particular repeat unit the
read came from. The MAPQ = 0 informs variant calling algorithms that the alignment may not be accurate

Both reads are RED if the insert size is larger than expected

Both reads are BLUE if the insert size is smaller than expected

OTHER COLORS indicate that the reads' mate is mapped to a different contig / chromosome
One color per contig / chromosome? 

#### Read alignment loading
If you get a message that tells you you ran out of memory while loading the alignment track,
its likely it will only show you up to as far as it was able to load. Some regions may thus
not have visible coverage while in fact they were covered by reads. Those reads were just
not loaded into memory before it ran out of memory.

If you suspect this from happening, restart IGV, remove irrelevant tracks and try again
