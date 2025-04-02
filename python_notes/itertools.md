Itertools - a built-in Python module for working with iterators and generators


An ITERATABLE is any object that can be iterated over.
These include strings, lists, tuples, dictionaries, sets


# Loading itertools

```python

import itertools
```

# itertools.tee()

Create n _iterators_ from any iterable

```python

iterable = [1, 2, 3, 4, 5]

# Create two iterators that are one step apart
iterator1, iterator2, iterator3 = itertools.tee(iterable, 3)
```

# itertools.count()

Make an iterator that returns evenly spaced values.
0, 1, 2, 3, 4, etc
0, 3, 6, 9, 12, etc

```python

# here 'counter' is an 'itertools.count' object
counter = itertools.count(start=0, step=1)
# note that there is no stop argument, 
# the counter will go on indefinitely

first  = next(counter) # 0
second = next(counter) # 1
third  = next(counter) # 2

# index a list

# itertools.count() is useful here because 
# it works with any length of 'data'
data = ['100','200','300','400']
zip_obj = zip( data, itertools.count() )

# zip() pairs up the items of both iterators together in order in tuples
# zip() output length is determined by the shortest input iterator
# in other words, zip() pairs the iterables until the shortest iterable is exhausted
print(list(zip_obj))
# [('100', 0), ('200', 1), ('300', 2), ('400', 3)]
```

# itertools.cycle()

```python

# normally when iterating over an iterator, it becomes exhausted at the end
for d in data:
    print(d)
## 100, 200, 300, 400

# itertools.cycle allows you to indefinitely cycle over the iterator:
for d in itertools.cycle(data):
    print(d)
## 100, 200, 300, 400, 100, 200, 300, 400, 100, etc    
```


# itertools.repeat()

```python

# returns an iterator which indefinitely returns the same value
itertools.repeat(2)
## the value can be any object

# runs indefinitely unless the times= argument is defined
itertools.repeat(2, times=3)

# example use
list(map(pow, range(10), itertools.repeat(2)))

## [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
## map() here pairs the values of range(10)
## with the values of itertools.repeat(2)
## and provides them to the pow function
## so pow(0,2), pow(1,2), pow(2,2), pow(3,2) etc
```

# itertools.chain()

```python

# chain various iteratables together in a combined iterator
letters = ['a', 'b', 'c', 'd', 'e']
numbers = [0, 1, 2, 3]
names = ['Corey', 'Nicole']

combined = itertools.chain(letters, numbers, names)

for i in combined:
    print(item)
```

# itertools.product()

```python

# get the cartesian product of two iterables
arr1 = [1, 2, 3]
arr2 = [5, 6, 7]
for x, y in itertools.product(arr1, arr2):
    # ...
    # (1,5) (1,6) (1,7) (2,5) (2,6) etc

# get the cartesian product of an iterable with itself
for x, y in itertools.product(arr1):
    # ...
    # (1,1) (1,2) (1,3) (2,1) (2,2) etc

# you can have more than two iterables
arr3 = [8, 9]
for x, y, z in itertools.product(arr1, arr2, arr3):
    # ...
    # (1,5,8) (1,5,9) (1,6,8) (1,6,9) etc


itertools.product(arr1, arr1, arr1):
# is equivalent to
itertools.product(arr1, repeat=3):
```
