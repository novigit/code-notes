genomeViz - a library for visualizing (parts) of genomes and comparisons between (parts) of genomes

#### Loading the module
```py
from pygenomeviz import GenomeViz
```

#### Loading a GFF3 file
```py
from pygenomeviz.parser import Gff

# load the entire GFF3
gff = Gff('tig018.add_introns.gff3')

# load only a particular seqid
gff = Gff('ergo.add_introns.gff3', target_seqid='tig496')
```

`gff` properties

```py
# returns a list of seqids found in the GFF3 file
gff.seqid_list
```

Extract BioPython `SeqFeature` objects from a GFF

```py
# extract all SeqFeatures
# NOTE: only loads the first seqid of the GFF3 file
features = gff.extract_features(["CDS","exon"])

# extract all SeqFeatures of a certain type or types from a certain range
features = gff.extract_features(["CDS","exon"], target_range=segment.range)

# extract all SeqFeatures of mRNA type, used later for drawing exons connected by introns
exons = gff.extract_exon_features(feature_type='mRNA')

# it seems that this function doesn't currently let you restrict exons to
# certain seqid's. The most elegant way that I could come up with is
range_exons = [ e for e in exons if e.location.start >= segment.start and e.location.end = segment.end ]
# (drawn features will show exons connected by lines representing introns )
# OR
range_exons = [ e for e in exons if segment.start <= e.location.start <= e.location.end <= segment.end ]

# NOTE that this is not equivalent to
exon_features = gff.extract_features('mRNA', target_range=segment.range)
# (drawn features will show entire mRNAs)
# or
exon_features = gff.extract_features('exon', target_range=segment.range)
# (drawn features will show exons, but not connected with intron lines)
```

You can iterate over SeqFeatures
```py
for feature in gff.extract_features(["CDS","exon"], target_range=segment.range):
    # do stuff with feature
```

```py
# extract SeqFeatures, but paired with their corresponding seqids in a dict
seqid2features = gff.get_seqid2features()

# as above, but only select 'gene' features
seqid2features = gff.get_seqid2features(feature_type="gene")

# subselect features that only exist on a particular contig within a particular region
seqid = 'tig498'
region_start, region_end = 100000, 150000
features = [ f for f in seqid2features.get(seqid) if region_start <= f.location.start <= f.location.end <= region_end ]

# NOTE: the region_start is interpreted as 0-indexed, half-open.
# So if you want to check region 1-500, provide coordinates 0-500

```

```py

for seqid, size in gff.get_seqid2size().items():
```

#### Biopython SeqFeature objects
```py
feature.id
feature.type
feature.location.start
feature.location.end
feature.location.strand

```

#### Initializing the figure
Generates a `GenomeViz` object

```py
# initiate a canvas in which to draw tracks in
gv = GenomeViz()

# by default, feature height is 0.25 of track height
# you can alter this with feature_track_ratio
gv = GenomeViz(feature_track_ratio=0.5)

# add a x-axis
gv.set_scale_xticks()
```

#### Add a track
Generates a `FeatureTrack` object from the `GenomeViz` object

```py
# name your track 'tig018', and define it for the region between 10000 and 100000
track = gv.add_feature_track(name="tig018", segments=(10000, 100000))

# add a label for your track
# the label string will be inferred from the segment and
# be something like '10000-100000 bp'
track.add_sublabel()

# generate a track with multiple regions
# view multiple regions of the same contig on the same horizontal line
target_regions = {
    'region1': (17500, 25000),
    'region2': (40000, 55000),
    'region3': (70000, 82000)
}
# OR
# target_regions = dict(region1=(17500, 25000), region2=(40000, 55000), region3=(70000, 82000))
track = gv.add_feature_track(name="tig018", target_regions)
# each of these regions is now a FeatureSegment

# property that holds all corresponding Segment objects
track.segments

# extract the first Segment from a Track
segment = track.get_segment()

# draw a segment separator, '//' by default
track.set_segment_sep()
```

#### Segments
A `FeatureTrack` may thus contain one or more `FeatureSegment` objects

```py
# return the range of the segment as a tuple
segment.range

segment.name

# segment start coordinate
segment.start

# segment end coordinate
segment.end

# decorate a segment with a sublabel
segment.add_sublabel(f"{segment.name}: {segment.start:,} - {segment.end:,} bp")
```

We can iterate over multiple segments:

```py
for segment in track.segments:
    # do things with segment
```

#### Drawing features onto a segment or track
Onto segments or tracks we will draw `SeqFeature` objects as they are defined in Biopython


```py
# here, 'genes' can be a single SeqFeature object or a list of SeqFeature objects
segment.add_features(features=genes, plotstyle="arrow", arrow_shaft_ratio=1.0, color='steelblue', label_type="ID")
```

Plotstyle can be `arrow`, `bigarrow`, `bigbox`, `box`, `bigrbox`, `rbox`
`bigarrow` will place all genes on the same horizontal level regardless of strand
`arrow`    will place all forward strands above the line, and all negative strands below the line

Plotstyles are Matplotlib patches, and keyword arguments can be passed to the add_features() as follows

```py
patch_kws={'fc' : "steelblue", 'lw' : 1}), intron_patch_kws=dict(color="red", lw=2.0)
```

To draw what I call 'arrow blocks' (kind of like pointy swords)
we can set `arrow_shaft_ratio=1.0`

Colors follow the matplotlib naming scheme

If you want to draw hatching patterns on your features, use `lc` and `hatch` patterns

```py
# use /, //, or even /// for increasingly denser hatching patterns
# backslashes need to be escaped, with other backslashes, hence the large amount of backslashes
hatch = "///" if f.location.strand == "+" else "\\\\\\"
segment.add_features(f, plotstyle="arrow", hatch=hatch, arrow_shaft_ratio=0.7, fc=color )
```

```py
# draw genes as individual, but connected exons
# here exons can be a list of SeqFeatures that are exons,
# extracted with gff.extract_exon_features() as described above
segment.add_exon_features(exons, plotstyle="arrow", arrow_shaft_ratio=1.0)
```

#### Running BLAST, MUMmer and MMseqs

You can run BLASTN and TBLASTX (but is very slow) using GenomeViz. The results can then be used to 
draw alignments between the tracks.

```py
from pygenomeviz.align import Blast, AlignCoord, MMseqs, MUMmer

# run BLAST alignment & filter by user-defined threshold
gbk_list = ['tig00000497.gbk', 'tig00000498.gbk']
fasta_list = ['tig00000498.fasta', 'tig00000018.fasta', 'tig00000497.fasta' ]

# if more than two files, Blast() will run pairwise-comparisons in order, so
# tig498 vs tig018, tig018 vs tig497, but NOT tig498 vs tig0497

# blastn
align_coords = Blast(gbk_list, seqtype="nucleotide").run()
align_coords = Blast(fasta_list, seqtype="nucleotide").run()
# tblastx, but really slow
align_coords = Blast(gbk_list, seqtype="protein").run()

# you can also use other sequence comparison algorithms
align_coords = MMseqs(gbk_list).run()
align_coords = MUMmer(gbk_list).run()
```

BLAST(), MUMmer() and MMseqs() return a list of `AlignCoord` objects

```py
ac = align_coords[0]

ac.query_name

# how much of the query was aligned
ac.query_length

ac.ref_name

# how much of the reference was aligned
ac.ref_length

ac.query_link
# tuple of (ac.query_id, ac.query_name, ac.query_start, ac.query_end)
# example: ('tig00000497', 'tig00000497', 335126, 381555)

ac.ref_link
# equivalent of query_link

ac.identity
```

From the in-source-code documentation it looks like you can only feed in FASTA and GENBANK files
I guess this makes sense since GFF3 files do not contain sequence information.
Still, it would be nice if you could use a combination of FASTA and GFF3 if you don't have GENBANK files access

```py
# filter your results so only alignments that have a certain length and percent identity pass through
align_coords = AlignCoord.filter(align_coords, length_thr=500, identity_thr=80)

# filter results further: only include those that are in the region of interest
filtered_coords = []
for a in align_coords:
    q_region_start, q_region_end = selected_contigs.get(a.query_name)
    r_region_start, r_region_end = selected_contigs.get(a.ref_name)
    if not q_region_start <= a.query_start <= a.query_end <= q_region_end: continue
    if not r_region_start <= a.ref_start <= a.ref_end <= r_region_end: continue
    filtered_coords.append(a)
```

#### Drawing alignments between tracks

```py
if len(align_coords) > 0:
    min_ident = int(min([ac.identity for ac in filtered_coords if ac.identity]))
    color, inverted_color = "grey", "red"
    for ac in filtered_coords:
        gv.add_link(ac.query_link, ac.ref_link, color=color, inverted_color=inverted_color, v=ac.identity, vmin=min_ident)
    gv.set_colorbar([color, inverted_color], vmin=min_ident)
```

It seems that `gv.add_link()` looks for `FeatureSegment` objects that have the same `segment.name` as `ac.query_name` / `ac.ref_name` in `ac.query_link` / `ac.ref_link`.
Thus, ensure that you give names explicitly to your segments when you generate them. You can do that by passing a dictionary that includes seqids and regions to the
`segments` argument of `gv.add_feature_track()`

#### Saving image file

```py
gv.savefig('example.png')
```

