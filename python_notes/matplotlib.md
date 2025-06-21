MATPLOTLIB

matplotlib - a python library for plotting stuff

```python
import matplotlib.pyplot as plt

# for each independent new figure in a script,
# initilize a new figure like so
plt.figure()
```

# Histogram

```python
## if data is a simple list of numbers...
plt.hist(data, bins=30, edgecolor='black')
# edgecolor = color of bar edges

# add labels and title
plt.xlabel('Relative intron location')
plt.ylabel('Frequency')
plt.title('Histogram')
```

#### Show the specified plot in an interactive window
```python
# show when executing python script
plt.show()
```

#### Save the plot to an image file

```python

plt.savefig('histogram.png')

# adjust resolution
plt.savefig('histogram.png', dpi=250)
```


# Multiple subplots (or Axes)

```python
# define two subplots, one on top of another
fig, axs = plt.subplots(ncols=2, nrows=1)
# 2 rows, 1 column

# define a single subplot (default behaviour)
fig, ax = plt.subplots()

# define six subplots, three rows of two subplots
fig, axs = plt.subplots(3, 2)

# define figure size
# by default x and y units are inches
fig, axs = plt.subplots(2,1, figsize=(3.5, 2.5))
# using cm's instead
fig, axs = plt.subplots(2,1, figsize=(3.5*cm, 2.5*cm))
# using pixels
fig, axs = plt.subplots(2,1, figsize=(3.5*px, 2.5*px))
```

`fig` here refers to the object representing the entire figure
`axs` refers to the one or more subplots (or Axes) within the figure


# Subplot (or Axes) indexing

```python
# define a single subplot (default behaviour)
fix, ax = plt.subplots()
# no indexing required, 'ax' refers to the single subplot

# define three subplots, on top of each other
fig, axs = plt.subplots(ncols=1, nrows=3)

|--------|
| axs[0] |
| axs[1] |
| axs[2] |
|--------|

# define six subplots, three rows of two subplots
fig, axs = plt.subplots(3, 2)

|--------------------------------|
| axs[0,0] | axs[0,1] | axs[0,2] |
| axs[1,0] | axs[1,1] | axs[1,2] |
| axs[2,0] | axs[2,1] | axs[2,2] |
|--------------------------------|

# define that the 3rd plot will have twice the height compared to the first two plots
fig, axs = plt.subplots(nrows=3, ncols=1, gridspec_kw={'height_ratios' : [1,1,2]})
```

# Annotate subplots

```python
# axs[0] refers to subplot 1,
# axs[1] refers to subplot 2
axs[0].hist(data1, bins=30)
axs[1].hist(data2, bins=30)

# add titles and axis labels
axs[0].set_title('Histogram of data1')

# set and edit axis labels
axs[0].set_ylabel('Frequency')
# you can use newline characters
axs[0].set_ylabel(f'Illumina\nCoverage')
# increase distance (padding) between label and axis
axs[0].set_ylabel(f'Frequency', labelpad=20)
# rotate label and center horizontally (ha) and/or vertically (va)
axs[0].set_ylabel(f'Frequency', rotation='horizontal', va='center')

# set and edit tick marks
axs[0].set_xticks([0, 100])

# suppress entire subplots
axs[0].set_visible(False)

# draw an empty subplot,
# useful if you want to create some spacing between some but not all subplots
axs[0].plot()
axs[0].set_visible(False)

# suppress the entire x-axis or y-axis
axs[0].xaxis.set_visible(False)
axs[0].yaxis.set_visible(False)

# suppress axis labels and tickmarks
# by passing an empty list
axs[0].set_xticks([])
axs[0].set_xticklabels([])

# suppress certain spines
# (the edges of the box that the plot is in)
axs[2].spines['right'].set_visible(False)
axs[2].spines['top'].set_visible(False)
axs[2].spines['bottom'].set_visible(False)
axs[2].spines['left'].set_visible(False)

# adjust the space between subplots
plt.subplots_adjust(hspace=0.4)
```

# Add text to subplots

```python
# add 'text' to a certain coordinate
axs[0].text(x_coord, y_coord, 'text',
           ha='center', va='center',
           fontsize=16)

# as above, but also add a white box that neatly fits around 'text'
bbox=dict(facecolor='white', edgecolor='white', boxstyle='round,pad=0.5')
axs[0].text(x_coord, y_coord, 'text',
           ha='center', va='center',
           fontsize=16, bbox=bbox)
```

# Draw a straight line

```python
# draw a straight horizontal line through y = 0
plt.axhline(y = 0, color='black', linestyle = '-')

# draw a straight horizontal line through y = 0, on "z-layer" 1
plt.axhline(y = 0, color='black', linestyle = '-', zorder=1)

# draw a straight line from x1 to x2,
# where x1 and x2 are values between 0 (leftmost) and 1 (rightmost)
# i.e., fractions of x-axis length
plt.axhline(y = 0, xmin=0, xmax=1)

```

# Drawing patches

In Matplotlib, a "patch" refers to a graphical object used to represent shapes such as rectangles, 
circles, polygons, etc. These patches are drawn on the plot to visualize various elements like
shapes, annotations, or regions of interest.

Rectangles

```python
# adding a rectangle
from matplotlib.patches import Rectangle

#                +------------------+
#                |                  |
#              height               |
#                |                  |
#               (xy)---- width -----+

ax.add_patch(Rectangle(xy=(xcoord, ycoord), 
                       width=10, 
                       height=5, 
                       edgecolor='black',
                       facecolor='blue',
                       linewidth=1))
## add option "zorder=2" so that Rectangle is drawn on top of the horizontal line
```

Polygons

```python
# adding a polygon
from matplotlib.patches import Polygon

# each [x,y] is a coordinate of a corner of the polygon
# you wish to draw
coords = [ [0,0], [0,2], [2,2], [2,0] ]
ax.add_patch(Polygon(xy=coords,
                     closed=True,
                     edgecolor='black',
                     facecolor='blue',
                     linewidth=1))
```

Circles and Ellipses

```python
from matplotlib.patches import Circle, Ellipse

# xy coordinates are the circle's center
ax.add_patch(Circle(
        xy=(1,1),
        radius=5,
        facecolor='green',
))

# xy coordinates are the ellipse center
# width and height are diameters
ax.add_patch(Ellipse(
        xy=(1,1),
        width=5,
        height=5,
        facecolor='green',
))
```
