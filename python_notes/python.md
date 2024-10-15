Python


# INTEGERS AND FLOATS

* Integers and floats are immutable 
This means that after changing the data,
a copy of the data is made into a new memory location

```python

# store a large number to an int, in a readable way
n: int = 1_000_000_000

# store a large number with scientific notation
# (this returns a float)
n: float = 1e9
```


# STRINGS

* Strings are an immutable data type
This means that after changing the data,
a copy of the data is made into a new memory location

## Wrapping long strings over multiple lines

```python

# 'sequence' will simply be a very long string
sequence: str = (
    "TAACCCTAACCCTAACCCTAACCCTAACCCTAACCCTAACCCTAACCCTAACCCTAACCC"
    "TGACCCTAACGGGTCAGGATAGGGTAATGAGAACCTGAACCCAAGCATGAACCCTGACCC"
    "TAGCCCTAACCCTGGCCCTCAACTCGAACCCTAGCCCTAACCCTGGCCCTCAACTCGAAC"
    "CCTAGCCCTAACCCTGGCCCTCAACTCGAACCCTAGCCCTAACCCTGGCCCTCAACTCGA"
    "ACCCTAGCCCTAACCCTGACCCTAACGGGTCAGGATAGGGTAATGAGAACCTGAACCCAA"
    "GCATGAACCCGAACCCTAGCCCTAACCCTGGCCCTCAACTCGAACCCTAGCCCTAACCCT"
)

# if you want to print a long string with newline characters
warning_message: str = (
    f"Warning: Gene {gene.id} on {gene.seqid} has only CDS features!\n"
    "This in principle OK but doesn't represent biology very well"
)

```

## f-strings

```python

# print string variables within a larger string
name: str = 'Joran'
age: int = 34
print(f'Hello, I am {name} and I am {age} years old')

# number formatting

# use .2f to format as (f)loat to round to (2) digits after the dot (.)
n: float = 1000000.5678
print(f'{n:.2f}')
# this will print '1000000.57'

# use , as a 1000 separator
print(f'{n:,.2f}')
# prints 1,000,000.57

# control the number of digits in a number
n: int = 12
print(f'{n:05d}')
# this will print '00012'

# do math
print(f"{2 * 37}")
print(f"{2 + 37}")

# print a large int with 1000 separators (here '_')
n: int = 1000000000
print(f'{n:_}')
# this will print '1_000_000_000'

# do the same, but with comma's as 1000 separators
print(f'{n:,}')

# string formatting

var: str = 'var'
# print a string aligned to the right of 20 spaces
print(f'{var:>20}')
# prints '                 var'

# print a string aligned to the left, followed by some other text
print(f'{var:<20}:helloworld')
# or
print(f'{var:20}:helloworld')
# prints 'var                 :helloworld'

# print a string aligned in the center of 20 spaces
print(f'{var:^20}')
# prints '        var        '

# do the same but with a different "fill" element
# by default a space
print(f'{var:_>20}')
# prints '_________________var'

# time formatting
from datetime import datetime
now: datetime = datetime.now()

# print day.month.year
print(f'{now:%d.%m.%y %H:%M:%S})
# prints '21.06.24 10:21:43'

# if you want to use AM / PM style
print(f'{now:%I%p}')
# prints '11AM'

# checking variable content
my_var = 'some_text'
print(f'{my_var = }')
# prints 'my_var = some_text'

# what if the string contains { or } characters?
# in f-strings, { and } have a special meaning
# to make them literal, add another {} :
i=10
my_regex = rf'(?:TGTTTGTT){{s<={i}}}'

# what if the string contains % characters?
# to make them literal, add another %
help="plots %%GC"

```

## raw strings

```python

# the \n, or other such characters, are interpreted literally and lose their special meaning
raw_string: str = r"Hello\nWorld"

# exception: backslash in the last position of the raw string still escapes the closing quote!!
raw_string: str = r"Hello World\"
# thus yields a SyntaxError
```

## printing to STDERR

```python

print(f'Checking intron {contig}:{start}-{stop} for RNAseq support', file=sys.stderr)
```

# LISTS

* Lists are mutable
This means that after changing the data,
the data remains in the same memory location

* Lists are useful for _homogeneous_ data

```python
fruits: list[str] = ['apple','orange','kiwi']

# Returns the length of the list
len(fruits)
```

## manipulate lists

```python

# Appends elements to the end of an existing list in-place
fruits.append('banana')

# Appends a new element at a desired index of an existing list, in-place
fruits.insert(1, 'banana')

# Concatenate list with other_list in-place
fruits.extend(other_list)

# Reverse the order in a list, in-place
fruits.reverse()
# Reverse the order in a list, but creates a new list
reversed_fruits = fruits[::-1]

# Sort a list in-place
# default = ASCIIbetical order, meaning Upper case come before lower case
fruits.sort()
fruits.sort(reverse=True)
# sort regular alphabetical order
fruits.sort(key=str.lower)

# Concatenate two lists
veggies: list[str] = ['broccoli','mushrooms']
foods: list[str] = fruits + veggies

# Replicate a list
fruits * 3
# ['apple', 'orange', 'kiwi', 'apple', 'orange', 'kiwi', 'apple', 'orange', 'kiwi']

# remove a value from a list using its index
del fruits[1]
# removes 'orange' from fruits

# remove an element from a list using its value
fruits.remove('orange')

```

## list unpacking

```python

colors: list[str] = ['red', 'blue', 'green', 'yellow']
red, blue, green = colors
red, *others = colors       # red = 'red', others = ['blue', 'green', 'yellow']
red, *_ = colors            # red = 'red', _ = ['blue', 'green', 'yellow']

```

## list and string slicing

Lists and strings are 0-indexed

> Each position in the list has a 'positive' and 'negative' index
> ['red', 'blue', 'green', 'yellow']
> [  0  ,   1   ,    2   ,    3    ]
> [ -4  ,  -3   ,   -2   ,   -1    ]

```python

# General slicing syntax
colors[ start : stop : step ]

# start = position at which your slice starts ( 0-indexed )
# stop  = slice up to but not including the stop position ( 0-indexed )
# step  = step size (by default 1)
```

Slicing returns a new list or string in memory!

Hence, `colors[::-1]` reverse the order of the list or string,
but does not change the list in-place, but rather returns a 
reversed copy of the list

Hence, `colors[-1]` returns the last item of the list
If you have a list of length 1, the index is only 0.
The first element won't have index 0 and -1, just 0


# TUPLES

* Tuples are immutable
This means that after changing the data,
a copy of the data is made into a new memory location

* Tuples are useful for _inhomogeneous_ data

```python

# orf = start, stop, strand, frame, id
orf = (0, 99, '+', '+1', 'orf00001')
```

# SETS

Sets are mutable

# DICTIONARIES

Dictionaries are mutable

```python
# Alternative ways to define a dict
dict1 = {'A': 'Geeks', 'B': 'For', }
# this notation may be useful when passing in a dictionary as an argument for a certain function
dict1 = dict(A='Geeks', B='For')

# Update or Extend a dictionary with another dictionary
dict1 = {'A': 'Geeks', 'B': 'For', }
dict2 = {'B': 'Geeks'}
dict1.update(dict2)
# dict1 = {'A': 'Geeks', 'B' : 'Geeks'}
dict3 = {'C': 'Jocks'}
dict1.update(dict3)
# dict1 = {'A': 'Geeks', 'B' : 'Geeks', 'C' : 'Jocks'}
```

# VARIABLES

Storing some data into a variable, is actually storing a
_reference_ to that data into a variable. The reference
points to an address in memory where the data resides.

You can check the memory address of a variable by
using the `id()` function:

```python

fruit = 'clementine'
id(fruit)
```

Creating a new copy of a variable thus actually copies
the _reference_, not the content

```python

# below, both food and fruit will have the same reference
# i.e. they both point to the same object in memory
food = fruit

# to create a copy in memory, i.e. another object in memory
# use copy.copy() or copy.deepcopy()
import copy
food = copy.copy(fruit)
food = copy.deepcopy(fruit)
```

```python

# assign multiple values at once
a, b = 4, 8
a, b, c, d = 4, "geeks", 3.14, True
```

# BUILT-IN FUNCTIONS

## enumerate()

```python

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

## zip()

```python

# Two lists of equal length
indices = ['a', 'b', 'c', 'd']
values = [1, 2, 3, 4]

# Using zip to combine the lists and dict to create a dictionary
result_dict = dict(zip(indices, values))
{'a': 1, 'b': 2, 'c': 3, 'd': 4}
```


# IF ELSE

```python

contig_strand = '+' if contig_frame > 0 else '-'

# assign multiple variables on a single line
end, step = (len(genes), 1) if direction == 'fwd' else (-1, -1)

```


# FUNCTIONS

# executes the function
some_function()

# the function object, that you can pass around to other stuff
some_function


```python

range(start,stop,step)              Returns a range object, only works with integers?
                                    Up to stop but not including stop
```

# ITERATORS

```python

# check if an iterator is empty
if not any(some_iterator):
```

# GENERATORS

A Generator is secretly just a function that returns an iterator

# API DOCUMENTATION

```python
# the star indicates that all keyword arguments MUST be written explicitly when
# calling the function. It won't guess the argument type by their position
set_scale_xticks(*, ymargin: float = 1.0, labelsize: float = 15, start: int = 0) -> None

```

# OBJECTS

## DOCUMENTATION

```python

print(help(some_object))
```

## FILTER OBJECT

```python

some_numbers = [1, 2, 3, 8, 9]
## apply a function that returns True or False on some iterator
f = filter( lambda x : x < 5, some_numbers )
## 'f' is a filter object
## it is a so-called lazy iterable, 
## which is only filters when called upon downstream in the script
## you can only iterate over it once!
```

## inspecting an object

```python

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

# TIPS AND TRICKS

Use `python -i script.py` to end up in interactive mode. Now you can inspect
the state of all the variables and objects and such

Even better, use `ipython -i script.py`

