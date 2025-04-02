### EMBOSS Utilities

Old stuff, but still really useful

#### dotmatcher for Dotplots

```bash

# show extensive help
dotmatcher -help -verbose
```

```bash

# basic usage
dotmatcher \
    -asequence <input.fasta> \
    -bsequence <input.fasta> \
    -windowsize 20 \
    -threshold 75 \
    -graph png \
    -goutfile <outfile_prefix> \
    -gtitle dotplot

## suffix is always .1.png
```

PNG is by default quite low resolution. To generate a higher
resolution image, use `-graph ps` and then

```bash

# 300 dpi
convert \
    -density 300 \
    -background white \
    -alpha remove \
    -rotate 90 \
    <outfile_prefix>.ps <outfile_prefix>.png
```
