TMUX - Terminal MUtlipleXer

# General

```bash

tmux                                        # Start a new tmux session
tmux a                                      # Attach to the last used existing session
tmux a -t <my_session>                      # Attach to the desired session
tmux ls                                     # List existing sessions
tmux new -s <my_session>                    # Start a new session with a desired session name
tmux kill-ses -t <my_session>               # Kill a session
tmux new -s <my_session> -n <my_window>     # Start a new name session with a named window
```

# While in tmux

```
<prefix> 
by default Ctrl-b               I like to set it to ctrl-space

<prefix> d                      Detach from session
<prefix> b                      Rename session

<prefix> c                      Create a new window
<prefix> ,                      Rename current window
<prefix> &                      Close current window, ctrl-d also works
<prefix> n                      Go to next window
<prefix> p                      Go to previous window
<prefix> <number>               Go to window <number>

<prefix> x                      Kill current pane
<prefix> %                      Split window vertically
<prefix> "                      "Split window horizontally
<prefix> <arrow-key>            Move cursor to another pane
<prefix> :                      Enter command prompt

<prefix> Option-1               Layout panes in preset 'even-horizontal'
<prefix> Option-2               Layout panes in preset 'even-vertical'    ,i.e. make two landscapes on top of each other
<prefix> Option-3               Layout panes in preset 'main-horizontal'
<prefix> Option-4               Layout panes in preset 'main-vertical'
<prefix> Option-5               Layout panes in preset 'tiled'

<prefix> [                      Enter copy-mode
<prefix> <PgUp>                 Enter copy-mode, which allows you to scroll up and down

<prefix> t                      Show time. Press any key to get out
```

# While in command prompt
```
:kill-session                   Kill current session
:show-environment               Shows environment variables
:kill-window                    Kill current window
```

# While in copy mode
```
C-d / C-u                       Scroll up and down just like in vim
Shift-k / Shift-j               Scroll page up and down one line
h, j, k, l                      Move up down sideways etc
space                           Start selection
enter                           Finish selection and put into clipboard
q                               Exit copy mode
```

# While in command prompt
```
swap-window -s 3 -t 2           Change order of windows by swapping window 3 with window 2
move-window -b -t 3             Move current window to position 3
```

# Duplicate $PATH entries

Starting tmux sessions can do some funny things with the `$PATH`. That is because tmux starts a new login-shell,
which loads the `.profile` again, which causes `$PATH` modifications to load a second time.
So if you start an iTerm2 session, the $PATH modifications are done. Then, when you start tmux session,
all those modifications are added to the $PATH once more.

The solution is to add an if statement in your `.profile` before making your `$PATH` modifications:
```sh
if [[ -z $TMUX ]]; then
    # add repositories and tools to PATH
    export PATH="/Users/joran/repositories/broCode:$PATH"
    export PATH="/Users/joran/repositories/gospel_of_andrew:$PATH"
    ...
fi
```

`[[ -z $TMUX ]]` evaluates True when $TMUX is NOT set. Hence when starting a TMUX session,
it will evaluate false, and the `$PATH` will not be appended

# Change in order of $PATH entries

On MacOS, every time you start a new iTerm2 or tmux session, a login-shell is invoked.
Whenever a login-shell is invoked, `/etc/profile` is loaded. On MacOS, this also
starts a tool called "path_helper". See the default `/etc/profile` below:

```sh
# System-wide .profile for sh(1)

if [ -x /usr/libexec/path_helper ]; then
	eval `/usr/libexec/path_helper -s`
fi

if [ "${BASH-no}" != "no" ]; then
	[ -r /etc/bashrc ] && . /etc/bashrc
fi
```

The edit below will ensure that path_helper only runs when
it is NOT a tmux session

```sh
# Change to make it work with tmux
if [ -x /usr/libexec/path_helper ]; then
    if [ -z "$TMUX" ]; then
        eval `/usr/libexec/path_helper -s`
    fi
fi
```
