PANDAS

# Loading pandas

```python

import pandas as pd
```

# Loading some file

```python

# read some tab separated file into a Pandas DataFrame
df: pd.DataFrame = pd.read_csv('some_file.tsv', sep='\t')

# the separator is by default ','
# header lines are automatically inferred by default

# read some table that has some lines commented above the table
df: pd.DataFrame = pd.read_csv('some_file.tsv', sep='\t', comment='#')
```

# Inspecting a DataFrame

```python

# a Pandas DataFrame is more formally a
# 'pandas.core.frame.DataFrame'
type(df)

# basic info
df.info()

# how many rows?
len(df)

# for each column, state datatypes used
# e.g. float64, int64, string, etc
df.dtypes

# get mean, stddev, quartiles, min, max for each column
df.describe()

# show top and bottom rows
df.head()
df.tail()

# get column names
df.columns # returns an Index Object
df.columns[0] # returns name of first column
df.columns[1] # returns name of second column

# extract a Series from a DataFrame
# ( a Series is essentially a single column of a DataFrame)
df['Column1']
df.Column1
```

# Working with Series

A `Series` is like a Python list in that it's an ordered collection of values.
But it also has an _explicit_ index, and it has a _data type_ (e.g. `int64`)

## Example Series

```python
pd.Series([3.14, 2.71, 1.41])

# 0  3.14
# 1  2.71
# 2  1.41
# dtype: float64
```

A `Series` is often indexed with 0-based integers, but it doesn't have to be!

```python

# Create a pandas Series with a custom index
data = [10, 20, 30, 40]
index_labels = ['a', 'b', 'c', 'd']  # Custom index labels

# Create the Series
s = pd.Series(data, index=index_labels)

# a    10
# b    20
# c    30
# d    40
# dtype: int64

# Accessing an element using a custom index
print(s['b'])  # Output: 20
```

## Inspecting a Series

```python

series = df.Column1

# inspect head and tail
series.head()
series.tail()

# get the maximum value in a Series
max(series)

# get the 10 largest values
series.nlargest(10)

# randomly sample 10 values
series.sample(10)

# return unique entries
series.unique()
```

## Numerical Operations with a Series

```python

# multiply each value in a Series with some value
# this is 'vectorization'
series * 1000


import numpy as np
# sum a Series
np.sum(series)

# apply e^ to each value in a Series
# e^ = exponential function
# (e.g. for transforming LnL to L values)
np.exp(series)

# apply log base e to each value
# log() is by default the natural logarithm
np.log(series)
```

# Working with DataFrames

## The .groupby() method

This allows you to essentially 'soft-split' your dataframe into multiple smaller dataframes,
grouped based on some condition. For example, lets say you have this dataframe:

```txt
# Species         Kingdom         no_genes

# Emiliania       Prostists       38549
# Arabidopsis     LandPlants      38311
# Saccharomyces   Fungi           6011
# Homo            Animals         20000
# Ergobibamus     Prostists       6600
# Equus           Animals         5000
# ZeaMays         LandPlants      7000
```

If you apply `df.groupby('Kingdom')` it will return a `DataFrameGroupBy` object,
which I suppose you could think of an table that sort of looks like this:

```txt
# Species         Kingdom         no_genes

# Emiliania       Prostists       38549
# Ergobibamus     Prostists       6600
----
# Saccharomyces   Fungi           6011
----
# Homo            Animals         20000
# Equus           Animals         5000
----
# ZeaMays         LandPlants      7000
# Arabidopsis     LandPlants      38311
```

Now we can ask pandas to interrogate each of these grouped 'sub' dataframes.
For example

```python
# count the rows in each group
df.groupby('Kingdom').size()

# Kingdom
# Protists 2
# Fungi 1
# Animals 2
# LandPlants 2

```

From a `DataFrameGroupBy` object, we can extract single columns, yielding
a `SeriesGroupBy` object. `df.groupby('Kingdom')['no_genes']`.
You could visualize it as follows:

```txt
# Kingdom       no_genes
                  
# Prostists     38549
# Prostists     6600
----
# Fungi         6011
----
# Animals       20000
# Animals       5000
----
# LandPlants    7000
# LandPlants    38311
```

Now we can ask pandas to interrogate each of these grouped series
For example

```python
# calculate the mean number of genes per kingdom
df.groupby('Kingdom')['no_genes'].mean()

# Kingdom
# Protists 41000
# Fungi 6011
# Animals 12500
# LandPlants 22500

# another interesting one is .idxmax(), which returns the index of the row
# (of the original dataframe) that has the maximum value of that column for that group
max_index: Series = df.groupby('Kingdom')['no_genes'].idxmax()

# Kingdom
# Protists 1
# Fungi 3
# Animals 4
# LandPlants 7
```
