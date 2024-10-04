# argparse

argparse is a standard module that comes with the base installation of python

```python
# load argparse
import argparse
```

#### Starting the parser

```python
# start the argument parser
parser = argparse.ArgumentParser(
            description=
        '''
        some description of your script
        ''',
        formatter_class=argparse.RawTextHelpFormatter
)
```

The `formatter_class=argparse.RawTextHelpFormatter` part ensures that formatting,
(newlines, tabs, etc) remain respected, when executing your script with the `-h` flag.

#### Passing arguments to the parser

##### Passing an input file 

```python
parser.add_argument(
        "-g", "--gff3",
        dest='gff3_file',
        type=str,
        required=True,
        help="Input GFF3 genome file")
```

`-g` is the short option
`--gff3` is the long option

value of option is held in `args.gff3_file`
`type=str` tells it to store the passed argument as a string
`required=True` defines the script needs this argument to work
`help="..."` is the text displayed when running script with -h


##### Passing an integer 

```python
parser.add_argument(
        "-w", "--window_size",
        dest='wdw_size',
        type=int,
        required=False,
        default=3,
        help="Window size for determining high-cov regions")
```

`required=False` defines that this is an optionable argument
if it is not stated, it will have default value 3

##### Setting a on/off switch like option

```python
parser.add_argument(
        '--my-option',
         action='store_true')
```

If `--my-option` is called on the cmd line, `args.my_option` will be True.
If not, it will be False

##### Passing multiple arguments to a single option

For example, `--slice_sites gtag gcag atac`

```python
parser.add_argument(
    '-s', '--strings',
    nargs='+',  # or '*' if you want to allow 0 or more arguments
    type=str,
    help='List of strings'
)
```

#### Ending the parser

```python
# collect arguments in args
args = parser.parse_args()
```

