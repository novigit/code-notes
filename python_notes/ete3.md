ete3

### Loading a tree

Load the tree structure from a newick string.

The returned variable `t` is the root node for the tree.
`t` is a `TreeNode` object

`Tree()` is an alias for `TreeNode()`
which create `TreeNode` objects

```py
from ete3 import Tree

t = Tree("(A:1,(B:1,(E:1,D:1):0.5):0.5);")
# This newick format includes leaf names and branch lengths
#    /-A
# --|
#   |   /-B
#    \-|
#      |   /-E
#       \-|
#          \-D
```


Load a tree structure from a newick file.

You can also specify the newick format.
For instance, for named internal nodes we will use format 1.
The default format is 0
format 0 and 1 are 'flexible',
meaning they will load even if they miss e.g., support values
other formats are strict and will raise exceptions if the
provided tree does not strictly adhere to the requested format

ETE3 toolkit specificies several types of newick format types,
see their documentation

```py
from ete3 import Tree
t = Tree("rp56.nw")

t = Tree("(A:1,(B:1,(E:1,D:1)Internal_1:0.5)Internal_2:0.5)Root;", format=1)
#    /-A
# --|
#   |   /-B
#    \-|
#      |   /-E
#       \-|
#          \-D
# Apparently does not print internal node names though..
```

### Writing a tree to a Newick file

```py
from ete3 import Tree

# Loads a tree with internal node names
t = Tree("(A:1,(B:1,(E:1,D:1)Internal_1:0.5)Internal_2:0.5)Root;", format=1)

# .write() prints the tree in Newick format
print(t.write())
# (A:1.000000,(B:1.000000,(E:1.000000,D:1.000000)1.000000:0.500000)1.000000:0.500000);

# To print the internal node names you need to change the format:
print(t.write(format=1))
# (A:1.000000,(B:1.000000,(E:1.000000,D:1.000000)Internal_1:0.500000)Internal_2:0.500000);

# We can also write into a file
t.write(format=1, outfile="new_tree.nw")
```

### Basic Tree Attributes

Create a random tree object with random topology `t`.

The `t` tree object is represented by its root node.

`t` is an object of the Tree or TreeNode class.

```py
from ete3 import Tree

t = Tree()
t.populate(15)

# print tree t in ascii characters
# print only prints the topology, not the branch lengths
print(t)
#         /-aaaaaaaaak
#       /-|
#      |  |   /-aaaaaaaaal
#      |   \-|
#      |     |   /-aaaaaaaaam
#    /-|      \-|
#   |  |        |   /-aaaaaaaaan
#   |  |         \-|
#   |  |            \-aaaaaaaaao
#   |  |
#   |   \-aaaaaaaaaa
# --|
#   |      /-aaaaaaaaab
#   |   /-|
#   |  |  |   /-aaaaaaaaac
#   |  |   \-|
#   |  |     |   /-aaaaaaaaad
#   |  |      \-|
#    \-|        |   /-aaaaaaaaae
#      |         \-|
#      |            \-aaaaaaaaaf
#      |
#      |   /-aaaaaaaaag
#       \-|
#         |   /-aaaaaaaaah
#          \-|
#            |   /-aaaaaaaaai
#             \-|
#                \-aaaaaaaaaj
```

Inspect its attributes
```py
# print list of children nodes (2 children of the root node)
# ? actually a list of hash references?
print(t.children)

# prints subtree associated with the first child node
print(t.children[0])

# prints subtree associated with the second child node
print(t.children[1])

# returns the same as t.children
print(t.get_children())

# .up returns a pointer to the parents node.
# since the root node doesn't have a parent node, it returns None
print(t.up)

# .name returns a custom node's name, including leaves names
# in this case no custom node name was specified so it doesnt return anything
print(t.name)

# .dist returns the branch length from the node to its parent
# since its the root node it doesnt have a parent,
# so it returns the default value (1.0)
print(t.dist)

# .support returns the support value of the branch that 
# connects the node to its parent
print(t.support)
```

### Basic TreeNode methods

```py
# .is_leaf() returns True when TreeNode object t is a leaf,
# False when it is an internal node
t.is_leaf()

# .is_root() returns True when TreeNode object t is the root node
t.is_root()

# .get_tree_root returns the root of tree that the TreeNode object is in
# in this case it returns the same node,
# since the considered TreeNode object is already the root
# the print statement then prints the tree again in ascii characters
t.get_tree_root()

# .get_tree_root() applied on the TreeNode
# t.children[0] returns the root of entire tree t
t.children[0].get_tree_root()

# also this returns the root of the entire tree t
t.children[0].children[0].get_tree_root()

# .get_common_ancestor('a', 'b', 'c', ...) returns
# the node that is the last common ancestor of the requested leafs
common_ancestor = t.get_common_ancestor('a', 'b', 'c')
# using * unpacking
common_ancestor = t.get_common_ancestor(*outgroup_representatives)

# .get_leaves()
# get all leaf nodes
leaf_nodes = t.get_leaves()

# .get_leaf_names()
# get an iterable of strings that correspond to the leaf names
leaf_names = t.get_leaf_names()
```

### Unrooted trees

```py
from ete3 import Tree

# specify unrooted_tree, a Tree object
unrooted_tree = Tree( "(A,B,(C,D));" )
print(unrooted_tree)
#    /-A
#   |
# --|--B
#   |
#   |   /-C
#    \-|
#       \-D
```

Even though this is an unrooted tree, in this context it still as a root node, as in the top-most node.
ETE3 also calls this root of the unrooted tree the 'master' node.
The root node represents the whole tree structure.
The root node of an unrooted tree has more than two children nodes.

### Rooting trees
```py
# Outgroup rooting
# first get the common ancestor Node of your desired outgroup
common_ancestor = t.get_common_ancestor('taxon1','taxon2')
# then set that Node as your outgroup
t.set_outgroup(common_ancestor)

# Midpoint rooting
midpoint_node = t.get_midpoint_outgroup()
t.set_outgroup(midpoint_node)
```

### Search for particular nodes

```py
# use .search_nodes()
# this method returns a list
A = t.search_nodes(name="A")[0]

# shortcut
A = t&"A"
```



### Tree Traversing
```py
from ete3 import Tree

# load a tree
t = Tree('((((H,K)D,(F,I)G)B,E)A,((L,(N,Q)O)J,(P,S)M)C);', format=1)
print(t)
#             /-H
#          /-|
#         |   \-K
#       /-|
#      |  |   /-F
#    /-|   \-|
#   |  |      \-I
#   |  |
#   |   \-E
# --|
#   |      /-L
#   |   /-|
#   |  |  |   /-N
#   |  |   \-|
#    \-|      \-Q
#      |
#      |   /-P
#       \-|
#          \-S
```
Iterating over a tree returns a leaf per iteration

```py
for leaf in t:
    print(leaf.name)
```

`.traverse` returns an 'iterator' of the tree nodes in postorder
'postorder': traverse left subtree from leave to top, traverse right subtree from leave to top, visit the root

```py
for node in t.traverse("postorder"):
    print(node.name)
# H
# K
# D
# F
# I
# G
# B
# E
# A
# L
# N
# Q
# O
# J
# P
# S
# M
# C
```

other traversal options:
'preorder' - visit the root, then left tree nodes, then right tree nodes
'levelorder' - default. every node is visited on a given level before dropping down one level

Traverse over the tree in postorder, but skip the root node
the difference in output is one less empty line (this line represents the root node that did not have a name)
```py
for node in t.iter_descendants("postorder"):
    print(node.name)
# H
# K
# D
# F
# I
# G
# B
# E
# A
# L
# N
# Q
# O
# J
# P
# S
# M
# C
```

Traverse the tree upwards towards the root, starting from a specific node

```py
node = t.search_nodes(name="C")[0]
while node:
    print(node)
    # node.up returns a pointer to the parent node
    node = node.up
```

### Checking for monophyly

`.check_monophyly()` returns whether certain sets of leafs are monophyletic or not

```py
from ete3 import Tree

t =  Tree("((((((a, e), i), o),h), u), ((f, g), j));")
print(t)
#                   /-a
#                /-|
#             /-|   \-e
#            |  |
#          /-|   \-i
#         |  |
#       /-|   \-o
#      |  |
#    /-|   \-h
#   |  |
#   |   \-u
# --|
#   |      /-f
#   |   /-|
#    \-|   \-g
#      |
#       \-j

# check if all vowels are monophyletic, and if not, what their phyly is
print(t.check_monophyly(values=["a","e","i","o","u"], target_attr="name"))
## (False, 'polyphyletic', {Tree node 'h' (-0x7fffffffee25ea2a)})

# check if subset of vowels are monophyletic
print(t.check_monophyly(values=["a","e","i","o"], target_attr="name"))
## (True, 'monophyletic', set())

# these vowels are paraphyletic (a specific case of polyphyly)
print(t.check_monophyly(values=["i", "o"], target_attr="name"))
# (False, 'paraphyletic', {Tree node 'e' (0x117646a2), Tree node 'a' (0x1176469b)})
```

### Annotating a tree with some new attributes

Annotating the leafs of a tree by adding some property with `.add_features()`.
Here a color is added to each leaf

```py
# first generate a toy tree
t =  Tree("((((((4, e), i), o),h), u), ((3, 4), (i, june)));")
print(t)
#                   /-4
#                /-|
#             /-|   \-e
#            |  |
#          /-|   \-i
#         |  |
#       /-|   \-o
#      |  |
#    /-|   \-h
#   |  |
#   |   \-u
# --|
#   |      /-3
#   |   /-|
#   |  |   \-4
#    \-|
#      |   /-i
#       \-|
#          \-june

# then state which leaf should get which color
colors = {
    "a":"red", 
    "e":"green", 
    "i":"yellow",
    "o":"black",
    "u":"purple",
    "4":"green",
    "3":"yellow", 
    "1":"white", "5":"red",
    "june":"yellow"
}

# then annotate the tree
for leaf in t:
    leaf.add_features(color=colors.get(leaf.name, "none"))

# 'color' is just an example trait you could add as a feature to a node
# it can be whatever you wish, 'vowel', 'confidence', 'blergh'
node.add_features(vowel=False, confidence=1.0, blergh="Wut")

# regular printing of the tree will NOT show the colors
# you need the .get_ascii() method
print(t.get_ascii(attributes=["name", "color"], show_internal=False))
#                   /-4, green
#                /-|
#             /-|   \-e, green
#            |  |
#          /-|   \-i, yellow
#         |  |
#       /-|   \-o, black
#      |  |
#    /-|   \-h, none
#   |  |
#   |   \-u, purple
# --|
#   |      /-3, yellow
#   |   /-|
#   |  |   \-4, green
#    \-|
#      |   /-i, yellow
#       \-|
#          \-june, yellow
```

`.get_monophyletic` will return all nodes that are monophyletic for a certain trait

```py
# find nodes that are monophyletic for containing either green or yellow
for node in t.get_monophyletic(values=["green","yellow"], target_attr="color"): 
    print(node.get_ascii(attributes=["color","name"], show_internal=False))

#       /-green, 4
#    /-|
# --|   \-green, e
#   |
#    \-yellow, i

#       /-yellow, 3
#    /-|
#   |   \-green, 4
# --|
#   |   /-yellow, i
#    \-|
#       \-yellow, june
```

### Tree Style
```python
from ete3 import TreeStyle

tree_style = TreeStyle()
tree_style.show_scale = False       # suppress branch length scale
tree_style.show_leaf_name = False   # suppress taxon names
tree.ladderize()                    # top-to-bottom ordering
tree.ladderize(direction=1)         # bottom-to-top ordering

```


### BarChartFace()

The deviations is a list of values, where each value represents the size of the error bar

```python
face = BarChartFace(
        values = [0.10, 0.20, 0.05, 0.15],          # y-axis values
        labels = ['A', 'C', 'G', 'T'],              # x-axis labels
        colors = ['blue', 'red', 'red', 'blue'],    # list of colors for each bar in the chart
        min_value = 0                               # min y-value of barchart
        max_value = 0.30,                           # max y-value of barchart
        width = 200,                                # width of barchart
        height = 100,                               # height of barchart
        label_fsize = 9                             # font size of x-axis labels
        scale_fsize = 6                             # font size of y-axis labels
)
```

### SeqMotifFace()

The `seq` parameter is not strictly necessary, but if you wish to render for example
protein domains, it is necessary to load into the sequence so that the sequence ends
not associated with protein domains (i.e. the C-terminus) is properly rendered as a simple line

```python
face = SeqMotifFace(
        seq = "ETTVIDTQELLHFKHEG-RGPVFTSC",         # aa sequence of the entry.
        seq_format = "line",                        # shape of the sequence regions outside or under motifs
        gap_format = "blank",                       # "blank" omits the line, "line" simply shows a line visibly different from sequence region
        motifs = [ [motif1],[motif2],... ]          # list of lists containing motifs
)
```

Formatting of motif: `[start, end, shape, width, height, fgcolor, bgcolor, text_label]`
Example motif: `1, 310, "()", 100, 10, "black", "rgradient:blue", f"arial|7|black|ComplexI_30_kDa" `

```
shape           # shape of the motif

"[]"    rectangle
"()"    rounded rectangle
"<>"    diamond
"o"     oval
"[)"    does not work unfortunately

fgcolor         # color of the motif outline
bgcolor         # color of the motif body
height          # determines the drawing height of the motif
```
