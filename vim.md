# VIM


#### Search and Replace
```sh
# search replace between current line and 2 next lines
:.,+2s/foo/bar/g

# convert multiple spaces in a row to tabs on a single line
:s/\s\+/\t/g

# convert multiple spaces in a row to tabs on all lines
:%s/\s\+/\t/g
```

#### While in insert mode
```
# autocomplete filename
ctrl-X + ctrl-F
```

#### Folding
According to vim docs, the letter 'z' sort of looks like a fold
... we'll roll with it

```
'za'        # toggle fold
'zo'        # open a fold
'zO'        # open a fold and all of its nested folds at once
'zc'        # close a fold
'zC'        # close a fold and all of its parent folds at once
'zM'        # close all folds in the file
'zR'        # expand all folds in the file
'zj'        # move cursor to the next fold
'zk'        # move cursor to previous fold
```

#### Line wrapping
```
:set wrap
:set nowrap
```

#### Macros
```
'q<letter>'  # start recording a macro
'q'          # end   recording
'@<letter>'  # execute macro
```
Macros are stored in the register
to see the register, type `:register`

#### Execute code
```
:w !python
:w !bash
```
