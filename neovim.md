Neovim

# File and buffer handling

```bash

# force refresh a buffers content
# useful if an external action wrote to a file open in vim
:e!

# open the previously opened file
:e#

# go to next buffer
:bnext
:bn

# go to previous buffer
:bprevious
:bp
```

# Check filetype
Check filetype of current buffer

```
:set filetype?
```
# Searching with regular expressions

```lua

-- Quantifiers
-- Look for 0 or more repetitions of pattern
/{pattern}\*
-- Look for 1 or more repetitions of pattern
/{pattern}\+

-- Other quantifiers
 \{,4}		-- 0, 1, 2, 3 or 4
 \{3,}		-- 3, 4, 5, etc.
 \{0,1}		-- 0 or 1, same as \=
 \{0,}		-- 0 or more, same as *
 \{1,}		-- 1 or more, same as \+
 \{3}		    -- 3
```

# Splitting a window vertically

```lua

-- Splits the window into two buffers
CTRL-w v

-- Move focus to other window/buffer
CTRL-w w
-- :bnext
-- :bn
-- :bprevious
-- :bp

-- Move focus to buffer below
CTRL-w j

-- Close window
CTRL-w q
-- :bdelete
-- :bd
```

# Show differences between to files

```bash

nvim -d file1 file2
```
