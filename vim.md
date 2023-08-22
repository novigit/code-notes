# VIM

#### File handling
```sh
# force refresh a buffers content
# useful if an external action wrote to a file open in vim
:e!

# open the previously opened file
:e#
```

#### Search and Replace
```sh
# convert multiple spaces in a row to tabs on a single line
:s/\s\+/\t/g

# convert multiple spaces in a row to tabs on all lines
:%s/\s\+/\t/g

# convert spaces into newline characters
:%s/\s/\r/g

# search replace between current line and last line of file 
:.,$s/foo/bar/g

# search replace between current line and 2 next lines
:.,+2s/foo/bar/g

# search replace in a visual block
## select block via ctrl-v
## press esc
:%s/\%Vfoo/bar/g

# delete all empty lines
:g/^$/d

# delete all occurrances of a pattern you found
/\v\[\&.*
# then
:%s//
```

#### While in insert mode
```
# autocomplete filename
ctrl-X + ctrl-F

# autocomplete pattern that exists in the file somewhere
ctrl-X + ctrl-I

# insert a ^I character
ctrl-V + ctrl-I
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

