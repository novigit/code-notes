Mummer - a package for aligning genome level nucleotides

# Create a dotplot

```bash
# align against itself with nucmer
nucmer -maxmatch -nosimplify <contig.fasta> <contig.fasta>
## this generates a 'out.delta' file

# optionally generate a tabular alignment file ala blast
show-coords -r -c -H out.delta > coords.txt

# then generate the plot
mummerplot -t png out.delta
```
