Python

# VARIABLES
## variable assignment
```py
## assign multiple values at once
a, b = 4, 8
a, b, c, d = 4, "geeks", 3.14, True
```

# STRINGS
## f-strings
```py
name = Joran
age = 34
print(f'Hello, I am {name} and I am {age} years old')

### number formatting
n = 10.1234
print(f'{n:.2f}')           # 2f -> two digits after the dot, e.g. 10.12
n = 12
print(f'{n:05d}')           # 05d -> 5 digits, so 00012

### do math
print(f"{2 * 37}")
```

# LISTS
## list unpacking
```py
colors = ['red', 'blue', 'green', 'yellow']
red, blue, green = colors
red, *others = colors       # red = 'red', others = ['blue', 'green', 'yellow']
red, *_ = colors            # red = 'red', _ = ['blue', 'green', 'yellow']
```

# DICTIONARIES

```py
# Alternative ways to define a dict
dict1 = {'A': 'Geeks', 'B': 'For', }
# this notation may be useful when passing in a dictionary as an argument for a certain function
dict1 = dict(A='Geeks', B='For')

# Update or Extend a dictionary with another dictionary
dict1 = {'A': 'Geeks', 'B': 'For', }
dict2 = {'B': 'Geeks'}
 
dict1.update(dict2)
# dict1 = {'A': 'Geeks', 'B' : 'Geeks'}

# Update or Extend a dictionary with another dictionary
dict3 = {'C': 'Jocks'}
dict1.update(dict3)
# dict1 = {'A': 'Geeks', 'B' : 'Geeks', 'C' : 'Jocks'}
```

# ENUMERATE
```py
# by default i starts at 0
for i, element in enumerate(iterable):
    ...process i and element...

# clever trick if you want to introduce a step size in the enumerate counter
for i, element in enumerate(iterable):
    j = i*4
# i, j
# 0, 0
# 1, 4
# 2, 8
# 3, 12
# etc etc
```

# ZIPPING INTO A DICT
```py
# Two lists of equal length
indices = ['a', 'b', 'c', 'd']
values = [1, 2, 3, 4]

# Using zip to combine the lists and dict to create a dictionary
result_dict = dict(zip(indices, values))
{'a': 1, 'b': 2, 'c': 3, 'd': 4}
```

# SLICING
Lists and strings are 0-indexed
list[ start : stop : step ]
start = position at which your slice starts ( 0-indexed )
stop  = slice up to but not including the stop position ( 0-indexed )
step  = step size (by default 1)

Each position in the list has a 'positive' and 'negative' index
['red', 'blue', 'green', 'yellow']
[  0  ,   1   ,    2   ,    3    ]
[ -4  ,  -3   ,   -2   ,   -1    ]

Hence, list[-1] returns the last item of the list

list[::-1] reverse the order of the list

# IF ELSE
```py
contig_strand = '+' if contig_frame > 0 else '-'
```


# FUNCTIONS
```py
list.append('string')               Appends elements to an existing list
list.extend(other_list)             Concatenate list with other_list
len(list)				            Returns the length of the list
range(start,stop,step)              Returns a range object, only works with integers?
int(float)                          Returns integer from float
```

# API DOCUMENTATION
```py
# the star indicates that all keyword arguments MUST be written explicitly when
# calling the function. It won't guess the argument type by their position
set_scale_xticks(*, ymargin: float = 1.0, labelsize: float = 15, start: int = 0) -> None

```

# OBJECTS

## DOCUMENTATION
```py
print(help(some_object))
```

## FILTER OBJECT
```py
some_numbers = [1, 2, 3, 8, 9]
## apply a function that returns True or False on some iterator
f = filter( lambda x : x < 5, some_numbers )
## 'f' is a filter object
## it is a so-called lazy iterable, 
## which is only filters when called upon downstream in the script
## you can only iterate over it once!
```

## inspecting an object
```py
# get all methods and attributes of an object with dir()
import requests
r = requests.get('some_url')
print( dir(r) )

# get all values of all attributes of an object with vars()
print( vars(r) )

# neatly print each attribute value on a new line
from pprint import pprint
pprint( vars(r) )

# get the help of a response object if it exists
print( help(r) )
```

## GENERATOR OBJECT

