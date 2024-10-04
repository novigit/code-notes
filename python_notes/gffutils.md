GFFUTILS

A python library for dealing with GFF and GTF files

```py
# load the library
import gffutils

# report the version of the library
print(gffutils.__version__)
```

### Loading a GFF3 file

`gffutils` uses sqlite3 to organize the gff3 features into a database
Each feature is indexed with a so-called 'primary key'
By default the ID attribute, for example `ID=identifier`, is used to create the primary key

```py
# load a GFF file and create an sqlite3 database file
db = gffutils.create_db('file.gff3', 'file.db')

# load a GFF file and store the sqlite3 database into memory
db = gffutils.create_db('file.gff3', ':memory:')
## where db is a 'gffutils.interface.FeatureDB' object

# load an already created db from a file
db = gffutils.FeatureDB('file.db')

# create a new database from an iterator of Feature Objects (here 'new_features')
db = gffutils.create_db(new_features, dbfn=':memory:', merge_strategy='create_unique')
```

When loading a GFF3 file, two features may have the exact same attribute ID.
This does not work for sqlite3, as each entry must have a unique primary key.
`gffutils` can merge features with the same attribute ID to solve this issue.
There are several different merging strategies

```py
merge_strategy='merge'           : all attributes of features with the same primary key will be merged (combined?)
merge_strategy='create_unique'   : the first feature keeps its original primary key (key), the next will have a unique auto-incremented key (key_1, key_2, etc)
merge_strategy='error'           : a gffutils.DuplicateID exception will be raised. Try to fix the duplicate primary key issue yourself

# example
db = gffutils.create_db('file.gff3', ':memory:', merge_strategy="error")
```

Two or more features may have the exact same attribute ID if they are 'discontinuous' features referring to the same biological entity.
For example, multiple CDS features associated with one mRNA transcript that refers to a single protein coding sequence

Rather than using the ID attribute, you can decide yourself how you would like to construct the primary key, by providing a `id_spec` function:

```py
# specifying your own way of assigning unique id's to features using id_spec
def id_func(x):
    new_id = ''
    if x.featuretype == 'gene':
        new_id = x.attributes['ID'][0]
    elif x.featuretype == 'CDS':
        new_id = '-'.join( [x.attributes['ID'][0], x.seqid, str(x.start), str(x.end)] )
    return new_id

# example
db = gffutils.create_db('ST7C_to_ST7H_transfer.gff_polished', id_spec=id_func, dbfn=':memory:')
```

Relationships between parents and children in the database are constructed using the primary id's

### Accessing the db
```py
gene = db['ctg012.gene0001']
exon = db['ctg012.mRNA0001.exon01']
## where gene/exon is a 'Feature object'
# here 'ctg012.gene0001' is the primary key of the feature,
# which by default is retrieved from the 'ID=' field in the attributes (the 9th) column

# print the whole GFF record of this gene feature
## (i.e. equivalent to 1 line in the GFF3 file)
print(gene)
```


### Feature object attributes
```py
# get the 'dialect' of the db
## dialects are like different flavors of GFF formats
db.dialect
# example:
# {
#     'leading semicolon': False,
#     'trailing semicolon': False, 
#     'quoted GFF2 values': False, 
#     'field separator': ';', 
#     'keyval separator': '=', 
#     'multival separator': ',', 
#     'fmt': 'gff3', 
#     'repeated keys': False, 
#     'order': ['ID', 'Name', 'Parent']
# }

# get the pragmas/directives of gff3 file used for creating the db
## returns a list
db.directives

# get the primary key ('string')
gene.id

# get the contig
gene.seqid

# get the start and end coordinates of the requested gene ('integers')
gene.start
gene.end

# get the length of a feature
len(gene)

# get the featuretype ('gene', 'mRNA', 'exon', etc)
gene.featuretype

# get the score of the feature
## NOTE: the score is of type string!
gene.score

# get the direction of the feature
gene.strand

# get the phase of the feature if its a CDS feature
gene.frame
## in GFF3, phase = '.' if its not a CDS feature

# get the value of the Name= attribute
## returns a list of strings, even if its just 1 value
gene['Name']
gene['ID']
## returns a string, i.e. the first value of the list
gene['Name'][0]

# access the attributes of a feature
gene.attributes         # returns an attribute object, which behaves like a dict of lists
gene.attributes.items() # returns a list [] of tuples (): [ ('ID',['ctg012.gene0001']) , ('Name',['gene0001']) ]
gene.attributes['Name']
gene.attributes['ID']
exon.attributes['Parent']
```


### Create a new Feature object
```py
# using gffutils.feature.Feature()
new_feature_obj = gffutils.feature.Feature(
    seqid='some_new_id',
    source='EVM',
    featuretype='exon',
    start=255080,
    end=255843,
    score='.',
    strand='+',
    frame='.',
    attributes='ID=some_new_id.exon01;Parent=some_new_id'
)

# using gffutils.feature.feature_from_line()
## NOTE that fields need to be delimited by tabs!
default_feature = 'some_new_id\tEVM\texon\t255080\t255843\t.\t+\t.\tID=some_new_id.exon-1;Parent=some_new_id' + '\n'
new_feature_obj = gffutils.feature.feature_from_line(line=default_feature)
```

### Update the attributes of a feature object
```py
# assign 'newID' to overwrite the oldID
## this update does NOT automatically update intron.id
intron.attributes['ID'][0] = 'newID' 

# assign a new ID by changing the old ID
intron.attributes['ID'][0] = i.attributes['ID'][0].replace('exon','intron')

# update the .id, which gffutils uses to access elements of the db
intron.id = 'newID'

# add an entirely new attribute to a Feature object
intron.attributes['call'] = 'true'

# strip the attribute object so it contains absolutely nothing
intron.attributes = {}

# remove a particular field from the attributes
intron.attributes.pop('Name')

# check if a particular field exists in the attributes
if 'Name' in intron.attributes:
    ... do stuff ...
```

### Get the DNA sequence of a particular gene feature

The function gets the DNA sequence from a provided FASTA file
```py
gene.sequence('ergo_cyp_genome.fasta')
```

### Useful FeatureDB methods

db.seqids()
```py
# get all contig names
for s in db.seqids():
    print(s)
```

db.children()
```py
# db.children() traverse down the entire hierarchy from top gene feature to bottom CDS features

# get all children (mRNAs, CDSs, exons, introns) from a gene
for c in db.children('ctg012.gene0001'):
    print(c)

# db.children('ctg012.gene0001') returns a generator object
list(db.children('ctg012.gene0001'))
# returns a list of feature objects
# [ <Feature mRNA (tig00000012:248937-250896[+]) at 0x11452d828>, 
#   <Feature CDS (tig00000012:248937-250153[+]) at 0x11452d780>, 
#   <Feature CDS (tig00000012:250212-250310[+]) at 0x11452d7f0>, 
#   <Feature CDS (tig00000012:250452-250896[+]) at 0x11452d940>, 
#   <Feature exon (tig00000012:248937-250153[+]) at 0x11452da90>, 
#   <Feature exon (tig00000012:250212-250310[+]) at 0x11452dbe0>, 
#   <Feature exon (tig00000012:250452-250896[+]) at 0x11452dd30> ]

# retrieve all exons or CDSs from a particular gene
exons = db.children('ctg012.gene0001', featuretype='exon')
cdss  = db.children('ctg012.gene0001', featuretype='CDS')
cdss  = db.children(gene, featuretype='CDS')
# here 'exons' and 'cdss' are generator object FeatureDB._relation
# .children() requires at least the ID argument or the Feature object

# iterate over the exons of a particular gene
[ exon.id for exon in db.children('ctg012.gene0001', featuretype='exon') ]
## returns the IDs of the exons
## ['ctg012.mRNA0001.exon01', 'ctg012.mRNA0001.exon02', 'ctg012.mRNA0001.exon03']

# ensure that the features are iterated over in a expected order
introns = db.children(gene, featuretype="intron", order_by="start")

# limit features to those on a certain contig
introns = db.children(gene, featuretype="intron", order_by="start", limit='contig')
```

db.parents()
```py
# access the parents of a particular feature
exon = db['ctg012.mRNA0001.exon01']
for f in db.parents(exon):
    print(f.id)
# this may return the gene and mRNA parent of this exon feature
```

db.all_features()
```py
# iterate over all features of a db
for f in db.all_features():
    print(f)

# iterate over all features of a db - in a certain region
for f in db.all_features(limit='contig01:1000-9000'):
    print(f)

# iterate over all features of a db - in a logical order
for f in db.all_features(order_by=('seqid','start','attributes')):
    print(f)

for f in db.all_features(order_by=('seqid','start','featuretype'), reverse=True):
    print(f)
```

db.region()
```py
# iterate over all features of a db - on one particular contig
for f in db.region(seqid='contig01', start=1):
    print(f)

# iterate over all gene features of contig01
for f in db.region(seqid='contig01', start=1, featuretype='gene'):
    print(f)
```

db.features_of_type()
```py
# iterate over all features of a particular type
for f in db.features_of_type(featuretype='exon'):
    print(f)

# iterate over all features of multiple types
for f in db.features_of_type(featuretype=('exon','gene','rRNA')):
    print(f)

# iterate over all features of a particular type - in a certain region
for f in db.features_of_type(featuretype='exon',limit='contig01:1000-9000'):
    print(f)

# check what feature types are present in the db
for t in db.featuretypes():
    print(t)
```

db.iter_by_parent_childs()
```py
# get an overview of all parents and their children

## .iter_by_parent_childs() returns a generator object
## essentially a long list, where each entry is a list of feature objects,
## which convey parent-children relationships
## i.e. 
## [<Feature gene (tig00000498:1097802-1109351[-]) at 0x1111e60b8>, 
##  <Feature mRNA (tig00000498:1097802-1109351[-]) at 0x110831588>, 
##  <Feature CDS (tig00000498:1097802-1109351[-]) at 0x1111d04e0>, 
##  <Feature exon (tig00000498:1097802-1109351[-]) at 0x1111d0e80>]
for p in db.iter_by_parent_childs():
    for f in p:
        print(f.id)
```

### Construct intergenic space features between genes
```py
genes = db.features_of_type( 'gene', order_by=('seqid','start') )
# in this context the order_by flag is important, because
# the .interfeatures method does -for reasons- not sort the gene features by coordinates,
# which can lead to erroneous inferred intergenic regions

igss = db.interfeatures(genes,new_featuretype='intergenic_space')
# the new 'intergenic_space' features will have IDs like
# ID=ctg498.gene0459,ctg498.gene046
# if you want to update your db with these features,
# db.update() will complain that the ID has more than one value
# to assign a primary key, ID must only have one value
# you can merge both values into one with a custom id_spec function:

db.update(igss, id_spec=lambda x : '-'.join(x.attributes['ID']))
# NOTE however that the attribute ID remains unchanged
# only feature.id will now be ctg498.gene0459-ctg498.gene04
# to change the attribute ID as well, you can use a transform function

def transform(f):
    f['ID'] = [ '-'.join(f.attributes['ID']) ]
    f.source = 'gffutils'
    return f

db.update(igss, transform=transform, merge_strategy='error')

# the transform function takes a feature object, transforms it, and
# then returns the transformed feature object. In this case we
# transformed its attribute ID
```


### Construct intron features between exons within a gene
```py
gene0001 = db['ctg012.gene0001']
gene0001_exons = db.children(gene0001, featuretype='exon')
for f in db.interfeatures(gene0001_exons, new_featuretype='intron', merge_attributes=True):
    print(f)
# merge_attributes=True is useful when providing a list of exons;
#    if False then the newly created introns may contain the same parent ID multiple times

# a more direct approach to create introns between exons is to use db.create_introns()
for f in db.create_introns():
    print(f)
# which prints out all the new intron features
# the newly created introns have multiple IDs by default: the neigboring exons, i.e.
# ID=exon1,exon2; Parent=mRNA1
```

### Update the current database with new Feature objects
```py
db.update(data)
# where 'data' is an iterable of feature objects

# update the current database with created introns
db.update(db.create_introns())

## this will not work if intron features have multiple IDs separated by commas
## like exon1,exon2 (see above)
## adjust your GFF file such that exons and CDSs do not have IDs
## (this is also compliant with GFF3 format)

## OR update the names of the attribute features before doing the db.update():

# infer and add intron features
introns = list(db.create_introns(merge_attributes=True))

# edit ID attributes of introns
## intron features have ID=exon1,exon2 as format
## this breakse .update(), so we need to adjust their IDs
for i in introns:

    # remove the second exon of the ID
    i.attributes['ID'].pop(1)

    # give the intron feature an intron ID!
    i.attributes['ID'][0] = i.attributes['ID'][0].replace('exon','intron')

# update db with new introns
db.update(introns)
```

### Print updated gff record in logical order
```py
for g in db.features_of_type('gene', order_by=('seqid', 'start')):
    print()
    print(g)
    for f in db.children(g, order_by='start'):
        print(f)
```

or to force gene -> mRNA -> exon, intron, CDS
```py
for g in db.features_of_type('gene', order_by=('seqid', 'start')):
    print()
    print(g)
    for m in db.children(g, featuretype=('mRNA','tRNA')):
        print(m)
        for f in db.children(m, order_by='start'):
            print(f)
```





Command Line Interface

```sh
# the gffutils package also comes with a cli tool!
gffutils-cli

# get help
gffutils-cli -h

# create a db from a gff3 file
gffutils-cli create test.simple.gff3
## creates test.simple.gff3.db
```

