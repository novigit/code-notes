# VIM

# Lesser known vim motions

`_` to move to first non-whitespace character in the line, stay in normal mode

# Fast exit of Insert mode

Use Ctrl-C instead of Escape

# File handling

```sh
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

# Search and Replace

```sh

# convert multiple spaces in a row to tabs on a single line
:s/\s\+/\t/g

# convert multiple spaces in a row to tabs on all lines
:%s/\s\+/\t/g

# convert spaces into newline characters
:%s/\s/\r/g

# replace pattern, but confirm each time
:%s/pattern/replacement/c

# search replace between current line and last line of file 
:.,$s/foo/bar/g

# search replace between current line and 2 next lines
:.,+2s/foo/bar/g

# search replace in a visual block
## select block via ctrl-v
## press esc
:%s/\%Vfoo/bar/g

# search replace with visual line mode
## highlight lines you want to use
## press ':'
## ':'<,'>' should now appear
## complete the command by appending ':'<,'>' with
:s/foo/bar/g

# delete all empty lines
:g/^$/d

# delete all occurrances of a pattern you found
/\v\[\&.*
# then
:%s//

# highlight all instances of a word in the file
# press '*' while cursor is on the word
# press 'n' and 'N' to move forwards and backwards

# replace all instances of a word you found with *
:%s//bar/g
```

#### While in insert mode
```
# autocomplete filename
ctrl-X + ctrl-F

# autocomplete pattern that exists in the file somewhere
ctrl-X + ctrl-I

# insert a ^I character
ctrl-V + ctrl-I

# enter insert-normal mode
# enter a single normal mode command and then immediately return to insert mode
ctrl-o

# move the cursor while in insert mode, using the insert-normal mode
ctrl-o + <motion>
ctrl-o + a      # move the cursor one to the right
ctrl-o + b      # move the cursor one word back
```

#### Cursor movement
```
While in normal mode

# move to previous cursor position
ctrl-o

# move to next cursor position
ctrl-i
```

#### Whitespace
```
:set list
```

#### Tab management
```
# make all tabs consistent
## either 4 spaces if :set expandtab in .vimrc
## or ^I if :set expandtab not set in .vimrc
:retab

# highlight a paragraph of code, then press '='
```

#### Key mapping

```
:map and :noremap:
    :map creates a mapping that applies in all modes, including Normal, Visual, Select, and Operator-pending mode.
    :noremap creates a mapping that is not recursive. It means that if the mapping invokes another mapping, the second mapping won't be affected by noremap. This is usually preferred unless you have a specific reason to use map.

:imap and :inoremap:
    :imap creates a mapping specific to Insert mode.
    :inoremap creates a non-recursive mapping specific to Insert mode.

:vmap and :vnoremap:
    :vmap creates a mapping specific to Visual and Select mode.
    :vnoremap creates a non-recursive mapping specific to Visual and Select mode.

:nmap and :nnoremap:
    :nmap creates a mapping specific to Normal mode.
    :nnoremap creates a non-recursive mapping specific to Normal mode.

:omap and :onoremap:
    :omap creates a mapping specific to Operator-pending mode.
    :onoremap creates a non-recursive mapping specific to Operator-pending mode.

# check if any insert mode key bindings start with <Esc>
:imap <Esc>
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
'zM'        # close all folds in the file ( I guess the M looks like a folded line )
'zR'        # expand all folds in the file
'zj'        # move cursor to the next fold
'zk'        # move cursor to previous fold
```

#### Line wrapping
```
:set wrap
:set nowrap
```

#### Syntax highlighting
Useful to turn off syntax highlighting when dealing with JSON files
```
:syntax off
```

#### Copying to the system-clipboard

Select what you want to copy with VISUAL mode.
Then, while still in VISUAL mode, type `"+y`.
`"+` for specifying system-clipboard, and `y` for yank.

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

#### From less to vim shortcut
Simply enter 'v' while in less to open the file for editing in vim


#### Language Server Protocol (LSP)

By letting vim (the client) talk to a language server (the server), vim acquires many powerful features akin to an Integrated Development Environment (IDE). This includes linting, warnings, errors, autocompletion etc.
It needs plugins to do so, however. The ones I installed are called `vim-lsp` and `vim-lsp-settings`. As far as I understand, `vim-lsp` provides the interface for vim to interact with a language server and `vim-lsp-settings` allows one to easily install and uninstall language servers.

Once you have installed both plugins, and open up for example a Python file, vim will ask you if you want to install the Python language server with the command `:LspInstallServer`. By default it will install `pylsp-all`, but you can specify other Python servers if you like with `:LspInstallServer <some-server>`. If you'd like to switch to another server, you can uninstall the original server with `:LspUninstallServer`.

The default behaviour of a language server can be quite aggressive and overwhelm you with warnings and error messages. To customize the behaviour of the server, you need to create a `settings.json` file (kind of similar to how things work with VsCode). For settings that will work for all files on your computer (i.e. global settings), store it at `~/.local/share/vim-lsp-settings/settings.json`. You can also directly edit this file from within Vim with `:LspSettingsGlobalEdit`. For settings that will work for all files in a project folder (i.e. local settings), store it at `<proj-dir>/.vim-lsp-settings/settings.json`. Local settings override global settings.

Here is an example `settings.json` file that disables pycodestyle:
```json
{
    "pylsp-all": {
        "workspace_config": {
            "pylsp": {
                "plugins": {
                    "pycodestyle": {
                        "enabled": false
                    }
                }
            }
        }
    }
}
```

