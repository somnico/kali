##
#   Navigate directory history using ALT-LEFT and ALT-RIGHT. ALT-LEFT moves back to directories
#   that the user has changed to in the past, and ALT-RIGHT undoes ALT-LEFT.
#
#   Navigate directory hierarchy using ALT-UP and ALT-DOWN.
#   ALT-UP moves to higher hierarchy (cd ..)
#   ALT-DOWN moves into the first directory found in alphabetical order
#

dirhistory_past=($PWD)
dirhistory_future=()
export dirhistory_past
export dirhistory_future

export DIRHISTORY_SIZE=30

# Pop the last element of dirhistory_past.
# Pass the name of the variable to return the result in.
# Returns the element if the array was not empty,
# otherwise returns empty string.
function pop_past() {
  setopt localoptions no_ksh_arrays
  if [[ $#dirhistory_past -gt 0 ]]; then
    typeset -g $1="${dirhistory_past[$#dirhistory_past]}"
    dirhistory_past[$#dirhistory_past]=()
  fi
}

function pop_future() {
  setopt localoptions no_ksh_arrays
  if [[ $#dirhistory_future -gt 0 ]]; then
    typeset -g $1="${dirhistory_future[$#dirhistory_future]}"
    dirhistory_future[$#dirhistory_future]=()
  fi
}

# Push a new element onto the end of dirhistory_past. If the size of the array
# is >= DIRHISTORY_SIZE, the array is shifted
function push_past() {
  setopt localoptions no_ksh_arrays
  if [[ $#dirhistory_past -ge $DIRHISTORY_SIZE ]]; then
    shift dirhistory_past
  fi
  if [[ $#dirhistory_past -eq 0 || $dirhistory_past[$#dirhistory_past] != "$1" ]]; then
    dirhistory_past+=($1)
  fi
}

function push_future() {
  setopt localoptions no_ksh_arrays
  if [[ $#dirhistory_future -ge $DIRHISTORY_SIZE ]]; then
    shift dirhistory_future
  fi
  if [[ $#dirhistory_future -eq 0 || $dirhistory_futuret[$#dirhistory_future] != "$1" ]]; then
    dirhistory_future+=($1)
  fi
}

# Called by zsh when directory changes
autoload -U add-zsh-hook
add-zsh-hook chpwd chpwd_dirhistory
function chpwd_dirhistory() {
  push_past $PWD
  # If DIRHISTORY_CD is not set...
  if [[ -z "${DIRHISTORY_CD+x}" ]]; then
    # ... clear future.
    dirhistory_future=()
  fi
}

function dirhistory_cd(){
  DIRHISTORY_CD="1"
  cd $1
  unset DIRHISTORY_CD
}

# Move backward in directory history
function dirhistory_back() {
  local cw=""
  local d=""
  # Last element in dirhistory_past is the cwd.

  pop_past cw
  if [[ "" == "$cw" ]]; then
    # Someone overwrote our variable. Recover it.
    dirhistory_past=($PWD)
    return
  fi

  pop_past d
  if [[ "" != "$d" ]]; then
    dirhistory_cd $d
    push_future $cw
  else
    push_past $cw
  fi
}


# Move forward in directory history
function dirhistory_forward() {
  local d=""

  pop_future d
  if [[ "" != "$d" ]]; then
    dirhistory_cd $d
    push_past $d
  fi
}


# Bind keys to history navigation
function dirhistory_zle_dirhistory_back() {
  # Erase current line in buffer
  zle .kill-buffer
  dirhistory_back
  zle .accept-line
}

function dirhistory_zle_dirhistory_future() {
  # Erase current line in buffer
  zle .kill-buffer
  dirhistory_forward
  zle .accept-line
}

zle -N dirhistory_zle_dirhistory_back
zle -N dirhistory_zle_dirhistory_future

for keymap in emacs vicmd viins; do
  # dirhistory_back
  bindkey -M $keymap "\e[2B" dirhistory_zle_dirhistory_back    # xterm in normal mode
  bindkey -M $keymap "\e[1;2B" dirhistory_zle_dirhistory_back  # xterm in normal mode
  # bindkey -M $keymap "\e[1;3B" dirhistory_zle_dirhistory_back  # xterm in normal mode
  bindkey -M $keymap "\e\e[B" dirhistory_zle_dirhistory_back   # Putty
  bindkey -M $keymap "\eO2B" dirhistory_zle_dirhistory_back    # GNU screen

  case "$TERM_PROGRAM" in
  Apple_Terminal) bindkey -M $keymap "^[[B" dirhistory_zle_dirhistory_back ;; # Terminal.app
  iTerm.app) bindkey -M $keymap "^[^[[B" dirhistory_zle_dirhistory_back ;;   # iTerm2
  esac

  if (( ${+terminfo[kcub1]} )); then
    bindkey -M $keymap "^[${terminfo[kcub1]}" dirhistory_zle_dirhistory_back  # urxvt
  fi

  # dirhistory_future
  bindkey -M $keymap "\e[2A" dirhistory_zle_dirhistory_future    # xterm in normal mode
  bindkey -M $keymap "\e[1;2A" dirhistory_zle_dirhistory_future  # xterm in normal mode
  # bindkey -M $keymap "\e[1;3A" dirhistory_zle_dirhistory_future  # xterm in normal mode
  bindkey -M $keymap "\e\e[A" dirhistory_zle_dirhistory_future   # Putty
  bindkey -M $keymap "\eO2A" dirhistory_zle_dirhistory_future    # GNU screen

  case "$TERM_PROGRAM" in
  Apple_Terminal) bindkey -M $keymap "^[[A]" dirhistory_zle_dirhistory_future ;; # Terminal.app
  iTerm.app) bindkey -M $keymap "^[^[[A" dirhistory_zle_dirhistory_future ;;   # iTerm2
  esac

  if (( ${+terminfo[kcuf1]} )); then
    bindkey -M $keymap "^[${terminfo[kcuf1]}" dirhistory_zle_dirhistory_future # urxvt
  fi
done

#
# HIERARCHY Implemented in this section, in case someone wants to split it to another plugin if it clashes bindings
#

# Move up in hierarchy
function dirhistory_up() {
  cd .. || return 1
}

# Move down in hierarchy
function dirhistory_down() {
  cd "$(find . -mindepth 1 -maxdepth 1 -type d | sort -n | head -n 1)" || return 1
}


# Bind keys to hierarchy navigation
function dirhistory_zle_dirhistory_up() {
  zle .kill-buffer   # Erase current line in buffer
  dirhistory_up
  zle .accept-line
}

function dirhistory_zle_dirhistory_down() {
  zle .kill-buffer   # Erase current line in buffer
  dirhistory_down
  zle .accept-line
}

zle -N dirhistory_zle_dirhistory_up
zle -N dirhistory_zle_dirhistory_down

for keymap in emacs vicmd viins; do
  # dirhistory_up
  bindkey -M $keymap "\e[2D" dirhistory_zle_dirhistory_up    # xterm in normal mode
  bindkey -M $keymap "\e[1;2D" dirhistory_zle_dirhistory_up  # xterm in normal mode
  # bindkey -M $keymap "\e[1;3D" dirhistory_zle_dirhistory_up  # xterm in normal mode
  bindkey -M $keymap "\e\e[D" dirhistory_zle_dirhistory_up   # Putty
  bindkey -M $keymap "\eO2D" dirhistory_zle_dirhistory_up    # GNU screen

  case "$TERM_PROGRAM" in
  Apple_Terminal) bindkey -M $keymap "^[b" dirhistory_zle_dirhistory_up ;;  # Terminal.app
  iTerm.app) bindkey -M $keymap "^[^[[D" dirhistory_zle_dirhistory_up ;;     # iTerm2
  esac

  if (( ${+terminfo[kcuu1]} )); then
    bindkey -M $keymap "^[${terminfo[kcuu1]}" dirhistory_zle_dirhistory_up # urxvt
  fi

  # dirhistory_down
  bindkey -M $keymap "\e[2C" dirhistory_zle_dirhistory_down    # xterm in normal mode
  bindkey -M $keymap "\e[1;2C" dirhistory_zle_dirhistory_down  # xterm in normal mode
  # bindkey -M $keymap "\e[1;3C" dirhistory_zle_dirhistory_down  # xterm in normal mode
  bindkey -M $keymap "\e\e[C" dirhistory_zle_dirhistory_down   # Putty
  bindkey -M $keymap "\e02C" dirhistory_zle_dirhistory_down    # GNU screen

  case "$TERM_PROGRAM" in
  Apple_Terminal) bindkey -M $keymap "^[f" dirhistory_zle_dirhistory_down ;;  # Terminal.app
  iTerm.app) bindkey -M $keymap "^[^[[C" dirhistory_zle_dirhistory_down ;;     # iTerm2
  esac

  if (( ${+terminfo[kcud1]} )); then
    bindkey -M $keymap "^[${terminfo[kcud1]}" dirhistory_zle_dirhistory_down # urxvt
  fi
done

# Function to go to the home directory
function dirhistory_home() {
  cd ~ || return 1
}

function dirhistory_zle_dirhistory_home() {
  zle .kill-buffer
  dirhistory_home
  zle .accept-line
}

zle -N dirhistory_zle_dirhistory_home

for keymap in emacs vicmd viins; do
  # bindkey -M $keymap "H" dirhistory_zle_dirhistory_home
  bindkey -M $keymap "^[OH" dirhistory_zle_dirhistory_home # Windows terminal
  bindkey -M $keymap "^[1~" dirhistory_zle_dirhistory_home # Tmux
done

unset keymap
