seaborn

### Loading an example dataset

```py
import seaborn as sns

# import the iris dataset
iris = sns.load_dataset("iris")

# iris is a pandas DataFrame
type(iris)
# <class 'pandas.core.frame.DataFrame'>
```

### Properties of the pandas dataframe
```py
# show only the first 10 rows of iris
iris.head(10)

   sepal_length  sepal_width  petal_length  petal_width species
0           5.1          3.5           1.4          0.2  setosa
1           4.9          3.0           1.4          0.2  setosa
2           4.7          3.2           1.3          0.2  setosa
3           4.6          3.1           1.5          0.2  setosa
4           5.0          3.6           1.4          0.2  setosa
5           5.4          3.9           1.7          0.4  setosa
6           4.6          3.4           1.4          0.3  setosa
7           5.0          3.4           1.5          0.2  setosa
8           4.4          2.9           1.4          0.2  setosa
9           4.9          3.1           1.5          0.1  setosa
```

### Changing the pandas dataframe
```py
# remove the 'species' column from iris and put it in its own datatype
species = iris.pop('species')

# species is a pandas Series
type(species)
# <class 'pandas.core.series.Series'>
```

### pandas Series

A pandas Series is thus essentially a single column from a pandas DataFrame

```py
# show first 10 rows of the Series
species.head(10)

# get only the unique values of a series
species.unique()

# this returns a Numpy Array
type( species.unique() )
<class 'numpy.ndarray'>

# create a new series based on a current series and a dict
## for example
## series is

0    setosa
1    setosa
2    versicolor
3    versicolor
4    virginica
5    virginica
6    virginica

## and dict is
lut = {'setosa': 'r', 'versicolor': 'b', 'virginica': 'g'}

## then
row_colors = species.map(lut)

## yields
0    r
1    r
2    b
3    b
4    g
5    g
6    g
```


