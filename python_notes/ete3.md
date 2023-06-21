ete3

### Loading a tree

Load the tree structure from a newick string.

The returned variable `t` is the root node for the tree.
`t` is a `TreeNode` object

`Tree()` is an alias for `TreeNode()`
which create `TreeNode` objects

```
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

```
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

```
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

Create a random tree object with random topology `t`
the `t` tree object is represented by its root node
`t` is an object of the Tree or TreeNode class
```
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
```
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

# .is_leaf() returns True when TreeNode object t is a leaf,
# False when it is an internal node
print(t.is_leaf())

# .get_tree_root returns the root of tree that the TreeNode object is in
# in this case it returns the same node,
# since the considered TreeNode object is already the root
# the print statement then prints the tree again in ascii characters
print(t.get_tree_root())

# .get_tree_root() applied on the TreeNode
# t.children[0] returns the root of entire tree t
print(t.children[0].get_tree_root())

# also this returns the root of the entire tree t
print(t.children[0].children[0].get_tree_root())

# iterate over tree leaves
for leaf in t:
    print(leaf.name)
```

### BarChartFace()

The deviations is a list of values, where each value represents the size of the error bar

```python
face = BarChartFace(
        values =
        labels =
)
```
