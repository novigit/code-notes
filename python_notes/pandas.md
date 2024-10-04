PANDAS

# Loading pandas

```python

import pandas as pd
```

# Loading some file

```python

# read some tab separated file into a Pandas DataFrame
df = pd.read_csv('some_file.tsv', sep='\t')

# the separator is by default ','
# header lines are automatically inferred by default

# read some table that has some lines commented above the table
df = pd.read_csv('some_file.tsv', sep='\t', comment='#')
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

# extract a Series from a DataFrame
# ( a Series is essentially a single column of a DataFrame)
df['Column1']
df.Column1
```

# Working with Series

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
```

## Numerical Operations with a Series

```python

# multiply each value in a Series with some value
# this is 'vectorization'
series * 1000

# sum a Series
np.sum(series)

# apply e^ to each value in a Series
# e^ = exponential function
# (e.g. for transforming LnL to L values)
import numpy as np
np.exp(series)

# apply log base e to each value
# log() is by default the natural logarithm
np.log(series)
```
