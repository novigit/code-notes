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

## case

```python
# show string in UPPERCASE
string.upper()
# in lower case
string.lower()
# in Title Case
string.title()
```

## stripping whitespace and newlines

```python

txt = '\n   HelloWorld    \n'

# removes all leading and trailing white space characters
# and newline characters from a string:
txt.strip()

# remove only leading characters
txt.lstrip()

# remove only trailing characters
txt.rstrip()
```

## stripping prefixes

```python

url = 'http://www.google.com'
url.removeprefix('http://')
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

# CONSTANTS

A constant is a variable who's value remains constant
throughout the execution of the entire program

```python
# the convention is to name constants with ALL CAPS
MAX_CONNECTIONS = 5000
```

# LISTS

* Lists are _mutable_
This means that after changing the data,
the data remains in the same memory location

* Lists are _ordered_

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

# Remove the last item in a list in-place and store it into a new variable
last_fruit = fruits.pop()

# Remove the first item in a list in-place and store it into a new variable
first_fruit = fruits.pop(0)

# Remove the third item in a list in-place and store it into a new variable
third_fruit = fruits.pop(2)

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

# Sort a list, but create a new list
sorted_fruits: list[str] = sorted(fruits)

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
# NOTE: it will only remove the first instance of 'orange' in the list 

# find the index of an element in a list using its value
fruits.index('orange')
# NOTE: it will return only the index of the first instance
# or 'orange' in the list

```

## list unpacking

```python

colors: list[str] = ['red', 'blue', 'green', 'yellow']
red, blue, green = colors
red, *others = colors       # red = 'red', others = ['blue', 'green', 'yellow']
red, *_ = colors            # red = 'red', _ = ['blue', 'green', 'yellow']
```

* Above, the `*others` and `*_` pack variables into a list,
because they take values from a list! If the input was a tuple,
they would have been packed into a tuple

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

# get the first two but not the third element
colors[:2]

# get all elements from the third onwards
colors[2:]

# get all elements from the third-to-last element onwards
colors[-3:]

# get a copy of the entire list
new_list = colors[:]
```

Slicing returns a new list or string in memory!

Hence, `colors[::-1]` reverse the order of the list or string,
but does not change the list in-place, but rather returns a 
reversed copy of the list

Hence, `colors[-1]` returns the last item of the list
If you have a list of length 1, the index is only 0.
The first element won't have index 0 and -1, just 0

# TUPLES

* Tuples are _immutable_
This means that after changing the data,
a copy of the data is made into a new memory location

* Tuples are _ordered_

* Tuples are useful for _inhomogeneous_ data

```python

# orf = start, stop, strand, frame, id
orf = (0, 99, '+', '+1', 'orf00001')

# a tuple must have at least one comma when creating
# (they are defined by the presence of a comma)
# so when making a tuple with a single element, do
some_tuple = (1,)
```

## tuple packing and unpacking

```python

colors: set[str] = ('red', 'blue', 'green', 'yellow')

# unpacks colors into red and 'others', another tuple
# 'blue', green', and 'yellow' are packed into a new list called others
red, *others = colors       # red = 'red', others = ['blue', 'green', 'yellow']
```

# SETS

* Sets are _mutable_

* Sets are _unordered_, and have no duplicate elements

* Set elements must be immutable, so lists and dictionaries are
not allowed to be elements

* The main advantage of a set over a list is that it is extremely
computationally efficient to check whether an item is part of a set

* Sets are useful for when you want to compare multiple collections,
and find the intersect, union, etc

```python

# initialize a set
fruits = set('clementine', 'peach', 'pineapple')
# or
fruits = {'clementine', 'peach', 'pineapple'}
```

## manipulate sets

```python

# add a single item
fruits.add('nectarine')

# add multiple items
# lists, tuples, strings and other hash sets are accepted
# duplicates are purged when added to the list
fruits.update(['nectarine','pear'])
```

# DICTIONARIES

* Dictionaries are mutable and unordered

Unordered-ness is associated with extremely efficient lookup.
Just like sets?

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

# update dict with a new key-value pair
dict1['D'] = 'Archer'
# update dict with new key-value pair,
# but only if key does not yet exist in dict
dict1.setdefault('D', 'Pam') # this would not update the dict
# essentially short hand for
if 'D' not in dict1:
    dict['D'] = 'Pam'

# retrieve the value of a key
value = dict1['A']
# if 'A' doesn't exist, assign 'nothing' to value
value = dict1.get('A', 'nothing')

# check if key exists in dict
if 'A' in dict1:
    print('A is in dict1')
# equivalent to
if 'A' in dict.keys():
    print('A is in dict1')

# delete a key-value pair by it's key
del dict['A']

# applying list() on a dict returns the keys as a list
list(dict1) # [ 'A', 'B', 'C' ]
# as of 3.7, it will return them in the order at which keys were
# inserted into the dict. This means python somehow remembers
# the insertion order. Prior to 3.7, the insertion order is not remembered

# applying set() on a dict returns the keys as a set
set(dict1) # { 'A', 'B', 'C' }

# isolating the keys, values and items (key-value pairs) in
# so-called 'dict_keys', 'dict_values' and 'dict_items' objects
# these are iterable, but can not be appended like true lists can
for k in dict:
    print(k)
for k in dict.keys():
    print(k)
for v in dict.values():
    print(v)
for k, v in dict.items():
    print(k, v)

# loop over the keys after they've been sorted
# remember, sorted() returns a copy of whatever its sorting
for k in sorted(dict.keys()):
    print(k)

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

# IF ELSE

## Ternary notation?

```python

contig_strand = '+' if contig_frame > 0 else '-'

# assign multiple variables on a single line
end, step = (len(genes), 1) if direction == 'fwd' else (-1, -1)

```

## None

`None` evaluates to False, in conditionals:

```python

# we will not print age here, because
# None evaluates to False
age = None
if age:
    print(age)
```

# BUILT-IN FUNCTIONS

## print()

```python

# print a string with newline characters shown
print(repr(some_string))
```

## range()


```python

# returns a range object, only works with integers?
range(start,stop,step)
# Up to stop but not including stop !
```

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

# CUSTOM FUNCTIONS

## parameters and arguments

* Variables that are written as input in the function _definition_
are called *parameters*

* Variables that are written as input in function  _calls_
are called *arguments*

* In reality these two terms are used interchangeably,
but this should be the proper terminology

## a variable number of parameters

### function defintion

```python

# pack multiple arguments into a single object
# in the function definition
def pizza(*toppings) -> tuple[str]:
    return toppings

# these arguments are packed into the tuple 'toppings'
pizza('anchovies', 'mozzarella', 'ananas')

# also works with a single argument
pizza('anchovies')
```

* In this case `*toppings` packs elements into a tuple,
because all arguments in a function call are essentially
in a tuple itself!

### function call

```python

# unpack a list or tuple directly in the function call
args = [1, 2, 3]
# first arg = 1, second = 2, third = 3
my_function(*args)
# equivalent to
my_function(1, 2, 3)

# unpack a dictionary directly into the function call
kwargs = {'a': 1, 'b': 2, 'c': 3}
my_function(**kwargs)
# equivalent to 
my_function(a=1, b=2, c=3)
```

## functions as objects

```python

# calling a function
some_function()

# the function object, that you can pass around to other stuff
some_function
```



```python

```

# ITERATORS

```python

# check if an iterator is empty
# NOTE: this consumes all elements up to the first True element!
if not any(some_iterator):

# get the last value of some iterator
# also works if iterator has just a single element
# in that case the single element will be captured by 'last'
*_, last = some_iterator
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

# ERRORS

## try except else block

```python

try:
    # some code that could throw some error
except SomeError:
    # code to execute if error is caught
else:
    # code to execute ONLY if error was not caught
```

## Catching library exceptions

In the example below, the `NewickError` class is defined in the library,
in the 'newick.py', under the 'ete3/parser/' directory.

```python
from ete3.parser.newick import NewickError

try:
    tree = Tree('some_tree.newick')
except NewickError:
    sys.exit('could not read tree file')

```

# TIPS AND TRICKS

Use `python -i script.py` to end up in interactive mode. Now you can inspect
the state of all the variables and objects and such

Even better, use `ipython -i script.py`


# Buffered print output

By default, Python _buffers_ output to STDOUT and STDERR, which may cause print statements to not show up immediately, especially if the script is running in batch mode.

As far as I can tell, there are two types of buffered modes: _line-buffered_ and _fully-buffered_.

If you invoke a script simply by `python script.py`, and the script is outputting to the terminal, its _line-buffered_ by default.
The buffer containing text is flushed every time it encounters a newline.

However, if you invoke the script from within let's say neovim, or on a computer cluster that writes the output to a file,
python may choose to only flush the buffer when the buffer is full, regardless of any newline characters.
This is done to increase performance.

Solution: Use the -u (unbuffered) flag when running the Python script, which forces Python to output in real-time.

python -u your_script.py

Alternatively, you can add flush=True to your print statements:

print("Your message here", flush=True)


