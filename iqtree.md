iqtree

# Basic tree search

```bash

# find the ML tree
iqtree -s example.aln -m LG -nt 4

# find the ML tree, using +G4 to model rate heterogeneity across sites
# using 4 discreet rate classes
iqtree -s example.aln -m LG+G4 -nt 4

# find the ML tree, using +F to take amino acid frequencies from the alignment
iqtree -s example.aln -m LG+G4+F -nt 4

# find the ML tree, using +C60 (or another mixture model) to model site classes
iqtree -s example.aln -m LG+C60+G4+F -nt 4

# find the ML tree, with non-parametric bootstraps
iqtree -s example.aln -m LG+G4 -nt 4 -b 100

# find the ML tree, with ultra-fast bootstraps
iqtree -s example.aln -m LG+G4 -nt 4 -bb 1000

```

# Estimate the likelihood of a tree given all parameters set

```bash

# -a sets the alpha shape parameter for gamma distribution
# -te constrains the tree search to the topology defined in the provided newick file
# -blfix constrains the branch lengths to those defined in the newick file
iqtree -s example.aln -m LG+G -a 0.5 -te constraint.newick -blfix
```

# Tree search using Post Median Site Frequency (PMSF) mixture model

```sh
```

# Topology Test

```sh
```

# Tree search using Functional Divergence (FunDi) model

```sh
# taxon1,taxon2,taxon3 is all the taxa on one side of the fundi branch
# the other set is all taxa on the other side of the fundi branch and is inferred
# ,estimate tells iqtree to estimate Rho
iqtree -s example.aln -m LG+C60+F+G4 -te constraint.newick --fundi taxon1,taxon2,taxon3,estimate

# 0.60 tells iqtree to use a Rho of 0.60
iqtree -s example.aln -m LG+C60+F+G4 -te constraint.newick --fundi taxon1,taxon2,taxon3,0.60
```

```sh
```

```sh
```

```sh
```

```sh
```

```sh
```
