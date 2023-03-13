#!/bin/bash

tmux                            Start a new tmux session
tmux a                          Attach to the last used existing session
tmux a -t <my_session>          Attach to the desired session
tmux ls                         List existing sessions
tmux new -s <my_session>        Start a new session with a desired session name
tmux kill-ses -t <my_session>   Kill a session

tmux new -s <my_session> -n <my_window>     Start a new name session with a named window

WHILE IN TMUX
<prefix> is by default Ctrl-b   I like to set it to ctrl-space

<prefix> d                      Detach from session
<prefix> b                      Rename session

<prefix> c                      Create a new window
<prefix> ,                      Rename current window
<prefix> &                      Close current window
<prefix> n                      Go to next window
<prefix> p                      Go to previous window
<prefix> <number>               Go to window <number>

<prefix> x                      Kill current pane
<prefix> %                      Split window vertically
<prefix> "                      "Split window horizontally
<prefix> <arrow-key>            Move cursor to another pane
<prefix> :                      Enter command prompt

<prefix> [                      Enter copy-mode
<prefix> <PgUp>                 Enter copy-mode, which allows you to scroll up and down

WHILE IN COMMAND PROMPT
:kill-session                   Kill current session

WHILE IN COPY MODE
C-d / C-u                       Scroll up and down just like in vim
Shift-k / Shift-j               Scroll page up and down one line
h, j, k, l                      Move up down sideways etc
space                           Start selection
enter                           Finish selection and put into clipboard
q                               Exit copy mode

WHILE IN COMMAND PROMPT
swap-window -s 3 -t 2           Change order of windows by swapping window 3 with window 2
