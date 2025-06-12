# Start monitoring
# zmodload zsh/zprof

# Instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Defer
source $HOME/zsh-defer/zsh-defer.plugin.zsh

# Path to Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Set Oh My Zsh theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Pre configuration for plugins
MAGIC_ENTER_GIT_COMMAND=' '
MAGIC_ENTER_OTHER_COMMAND=' '
export HISTORY_START_WITH_GLOBAL=true
export PER_DIRECTORY_HISTORY_TOGGLE='^[h'
zstyle '*:compinit' arguments -i -u -C
bindkey ' ' magic-space

# Plugins
plugins=(
  forgit
  sudo
  tmux-cssh
  aliases
  alias-finder
  command-not-found
  zsh-edit
  zsh-no-ps2
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-prompt-benchmark
  zsh-navigation-tools
  history
  dirhistory
  per-directory-history
  last-working-dir
  jump
  wd
  k
  direnv
  copypath
  cp
  safe-paste
  transfer
  extract
  universalarchive
  colored-man-pages
  fancy-ctrl-z
  globalias
  magic-enter
  httpie
  urltools
  web-search
  nmap
  jq
  percol
  gpg-agent
  ssh-agent
  ssh
  systemadmin
  profiles
  fzf-tab
  fzf-tab-source
)

# Manual plugin loading
source $HOME/.zsh-hist/zsh-hist.plugin.zsh

# Delayed plugin loading
zsh-defer eval "$(keychain --eval --quiet)"
zsh-defer source "$ZSH/plugins/jsontools/jsontools.plugin.zsh"

# Completetion configuration
fpath=($HOME/.cache/completions $fpath)
fpath+=("${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions/src")

# Blank line
# preexec() {echo}

# preexec() {
#   printf '\e[?25l'  # hide before command
# }
# precmd() {
#   tput civis
# }

# # Show cursor again after prompt is fully drawn
# zle-line-init() {
#   printf '\e[?25h'  # only show cursor, no blink toggle
#   zle -R
# }
# zle -N zle-line-init

# Fix cursor in tmux
# function reset_cursor_shape {
#   echo -ne '\e[5 q'
# }
# precmd_functions+=(reset_cursor_shape) 




# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Source Powerlevel
source $HOME/.p10k.zsh


# Argc comfiguration, argc_scripts=(... ...)
export ARGC_COMPLETIONS_ROOT="$HOME/.config/argc-completions"
export ARGC_COMPLETIONS_PATH="$ARGC_COMPLETIONS_ROOT/completions"
export PATH="$ARGC_COMPLETIONS_ROOT/bin:$PATH"
argc_scripts=($(ls -p -1 "$ARGC_COMPLETIONS_ROOT/completions" | sed -n 's/\.sh$//p'))
source <(argc --argc-completions zsh $argc_scripts)

# Autosuggestions configuration
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste)
ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_AUTOSUGGEST_USE_ASYNC=true
bindkey '\e[1;3C' autosuggest-execute

# Shell integrations
# [ ! -f "$HOME/.x-cmd.root/X" ] || . "$HOME/.x-cmd.root/X"
[ -s $HOME/.config/envman/PATH.env ] && source $HOME/.config/envman/PATH.env # Webi 
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
export NIX_CONFIG="experimental-features = nix-command flakes"
source "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-async/async.zsh"
. "$HOME/.cargo/env"
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh --disable-up-arrow | sed 's/atuin history start -- "$1"/atuin history start -- "$2"/')"
eval "$(zoxide init --cmd cd zsh)"



# History
SAVEHIST=10000
HISTSIZE=$(( SAVEHIST + SAVEHIST / 5 ))
HISTFILE=$HOME/.zsh_history
HISTDUP=erase
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HISTFCNTLLOCK
zstyle ':hist:*' auto-format no   
zstyle ':hist:*' expand-aliases yes  

# Options
unsetopt CORRECT
unsetopt CORRECT_ALL
setopt INTERACTIVE_COMMENTS
setopt NUMERIC_GLOB_SORT
setopt RECEXACT
setopt GLOBDOTS
setopt GLOB_COMPLETE
setopt GLOBSTARSHORT
setopt EXTENDED_GLOB
setopt NO_CASE_GLOB
setopt RCEXPANDPARAM
setopt SUNKEYBOARDHACK
setopt NOBEEP
setopt NOTIFY
setopt NO_GLOBAL_RCS

ZLE_RPROMPT_INDENT=0
READNULLCMD=bat
DISABLE_AUTO_TITLE=true
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"


# Aliases
unalias x 2>/dev/null
unalias gg 2>/dev/null

alias ba="bat --paging=auto --pager 'less -RF' --theme='Catppuccin Macchiato' --style='grid,numbers,changes'"
alias b="bat -pp --theme='Catppuccin Macchiato'"
help() {"$@" --help 2>&1 | bat --plain --language=help --theme='Catppuccin Macchiato'}
tr() {tldr "$@" | bat --plain --language=markdown --theme='Catppuccin Macchiato'}
alias ls="eza --group-directories-first --header --icons --group"
alias j="jump"
alias qq="xsel --clipboard <"
alias co="copypath"

cm() {mkdir -p -- "$1" >/dev/null && cd -- "$1"}
cl() {cd "$@" && ls}
alias n="micro"
alias zj="zellij"
alias ch="sudo chmod +x"
alias s="sudo -E zsh"
alias ex="extract"
alias de="sudo rm -rf"
alias k="ps aux | fzf --multi | awk '{print \$2}' | xargs -r sudo kill -15"
alias top="sudo -E btop"
alias i="sudo apt install -y"
alias re="omz reload"
alias so="source $HOME/.zshrc"


alias icon="column -mts ',' -o $'\t' $HOME/.config/icons/index.csv | fzf -d '\t' --with-nth=1,2,3,4 --header-lines=1 --bind 'enter:execute(echo {1})+abort,ctrl-q:execute-silent(echo -n {1} | xclip -selection clipboard)'" 
alias e="/mnt/c/Windows/explorer.exe ."
perm() {local target="${1:-.}"; sudo chown -R "$USER:$USER" "$target"; sudo chmod -R u+rwX,go+rX "$target"; echo "Permissions fixed"}

alias da="rclone copy Drive:/Linux/AWS/Files/ $HOME/files/ --include '*' -P"
alias ua="rclone copy $HOME/files/ Drive:/Linux/AWS/Files/ --include '*' -P"
dl() {local source="Drive:Linux/AWS/Files/"; local destination="$HOME/files/"; file="$1"; rclone copy "${source}${file}" "${destination}";}
ul() {local source=""; local destination="Drive:Linux/AWS/Files/"; source="$1"; rclone copy "${source}" "${destination}";}
0x() {curl -F file=@"$1" -F expires=168 https://0x0.st}
u() {curl -s -F "files[]=@$1" https://uguu.se/upload | jq -r '.files[0].url'}
alias ws="wormhole send"



# Completion configuration
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $HOME/.cache
# zstyle ':completion:*' list-dirs-first true

# Fzf configuration
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh


# Fzf-tab styling
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --tree --level=2 --color=always ${realpath}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' fzf-pad 4
zstyle ':fzf-tab:*' fzf-min-height 15
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' popup-min-size jj0 0
zstyle ':fzf-tab:complete:cd:' popup-pad 0 0 

# zstyle ':completion:*:*:eza:*' file-patterns '*(/):directories'

# zstyle ':completion:*:complete:(ls|cd|cp|mv|cat|more|tail|head|open):*' file-patterns '*(/):directories'

# zstyle ':completion:*:complete:(ls|cd|cp|mv|vim|cat|more|tail|head|open):*' file-patterns '*(-.)'
# zstyle ':completion:*:complete:(ls|cd|cp|mv|vim|cat|more|tail|head|open):*' file-sort name
compdef _files cat echo 
# compdef _directories ls eza

# zstyle ':fzf-tab:complete:cat:' fzf-flags '--walker=file,hidden'
zstyle ':fzf-tab:*' fzf-flags --query=
zstyle ':fzf-tab:complete:cd:' fzf-flags '--no-multi'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'

zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-bindings 'tab:toggle+down' 'shift-tab:toggle+up' 'space:accept' 'left:close'
zstyle ':fzf-tab:*' accept-line enter
zstyle ':fzf-tab:*' accept-line right
zstyle ':fzf-tab:*' continuous-trigger 'shift-right'

zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color always $word'

# zstyle ':fzf-tab:sources' config-directory ~/.config/fzf-tab-sources

# _fzf_complete_cat() {
#   _fzf_complete -- "$@" < <(
#     fdfind --type f --hidden --follow --no-ignore --exclude .git --max-depth 1 .
#   )
# }

# seq 5 | fzf --multi --bind 'enter:transform:(( FZF_SELECT_COUNT )) && echo accept || echo ignore'


bindkey '^Xh' _complete_help

# zsh-defer -t 0 compinit -i -u -C

# Fuzzy finder defaults
export FZF_DEFAULT_OPTS="
  --color=fg:#dadce9,fg+:#e9e9e9,bg:#292d3e,bg+:#33394f
  --color=hl:#c8ff9e,hl+:#baffe7,info:#ae98ff,marker:#ae98ff
  --color=prompt:#292d3e,spinner:#ae98ff,pointer:#ae98ff,header:#82AAFF
  --color=gutter:#292d3e,border:#343b54,scrollbar:#343b54,preview-bg:#292d3e
  --color=preview-border:#31374f,preview-scrollbar:#31374f,preview-label:#31374f,label:#31374f,query:#c8ff9e
  --border=rounded --preview-border=rounded --prompt='  '
  --pointer='▌' --marker='▌' --border-label='' --separator='' --no-scrollbar 
  --info=default --multi --cycle --highlight-line
  --bind 'ctrl-l:clear-query,home:first,end:last,enter:accept-non-empty'
  --tmux center
"

# Adjust background color based on environment
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=bg:#1f2335,preview-bg:#1f2335,gutter:#1f2335"
fi 

export BAT_THEME='Catppuccin Macchiato'

export FZF_TMUX=1
export FZF_TMUX_OPTS="-p 50%,50% --padding 1,5 --margin 1,0"

export FZF_DEFAULT_COMMAND="fd -H -t d -t f -t l -E /mnt/c -E .git -E .cache"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# plocate "" | fzf --preview 'bat --style=numbers --color=always {} || cat {}' --preview-window=right
# export FZF_DEFAULT_COMMAND="plocate -i '' | grep -vE '/mnt/|\.git/'"




# Fuzzy search
f() {
  fzf --height=70% --tmux 70% --multi --exact --layout=reverse --info=default --border \
      --preview "bat --paging=never --theme'=Sublime Snazzy' --style=numbers --color=always {}" \
      --preview-window "right,50%" \
      --bind "pgdn:page-down,pgup:page-up" \
      --bind "ctrl-q:execute-silent(cat {+} | xclip -selection clipboard)+reload(fd -t f --hidden)" \
      --bind "ctrl-x:execute(trash {+})+reload(find . -type f)" \
      --bind "ctrl-n:become(sudo -E micro {+})" \
      --bind "ctrl-r:become(source {+})"
}


# Fuzzy search in file
ff() {
  local INITIAL_QUERY="${*:-}"
  local RG_PREFIX="rg --line-number --no-heading --color=always --smart-case --search-zip --smart-case --sort=path --hidden --glob '!**/.git/*' \
                      --colors 'match:fg:0xea,0x47,0x70' --colors 'path:fg:0x7e,0xdc,0xf9' --colors 'line:fg:0x55,0x62,0x8a'"

  fzf --height=100% --tmux 70% --layout=reverse --multi --info=default --border --delimiter : --color="query:#ea4770" \
      --ansi --disabled --query "$INITIAL_QUERY" \
      --bind "start:reload:$RG_PREFIX {q}" \
      --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
      --bind "ctrl-p:toggle-preview" \
      --preview 'bat --theme="Catppuccin Macchiato" --style="numbers" --color=always {1} --highlight-line {2}' \
      --preview-window 'down,40%,+{2}-4' \
      --bind 'right:execute(sudo -E micro -statusline true {1}:{2} < /dev/tty)'
}

# Custom fuzzy search
fzf-find-widget() {
  local dir="${1:-$PWD}"  

  plocate "$dir" | awk -v dir="$dir" '$0 ~ dir {sub(dir "/?", ""); print}' | \
  fzf --height=70% --tmux 70% --multi --exact --layout=reverse --info=default --border \
      --preview 'bat --paging=never --theme=ansi --style=numbers --color=always {}' \
      --preview-window 'right,50%' \
      --bind 'pgdn:page-down,pgup:page-up' \
      --bind 'right:become(sudo -E micro {+})' \
      --bind "shift-left:reload(plocate / | awk '{print}')" \
      --bind "shift-right:reload(plocate '$dir' | awk -v dir='$dir' '\$0 ~ dir {sub(dir \"/?\", \"\"); print}')"

  echo -e "\r"
  zle redisplay
}

# Search within files and open multiple files
fzf-find-in-file-widget() {
  export TEMP=$(mktemp -u)
  trap 'rm -f "$TEMP"' EXIT

  local TRANSFORMER='
    rg_pat={q:1}      
    fzf_pat={q:2..}  

    if ! [[ -r "$TEMP" ]] || [[ $rg_pat != $(cat "$TEMP") ]]; then
      echo "$rg_pat" > "$TEMP"
      printf "reload:sleep 0.1; rg --line-number --no-heading --color=always --smart-case --sort=path --hidden --colors 'match:fg:0xea,0x47,0x70' --colors 'path:fg:0x7e,0xdc,0xf9' --colors 'line:fg:0x55,0x62,0x8a' %q || true" "$rg_pat"
    fi
    echo "+search:$fzf_pat"
  '

  local -a files
  local INITIAL_QUERY="${*:-}"

  files=("${(@f)$(fzf --height=100% --tmux 70%  --disabled --layout=reverse --info=default --border --multi --ansi --delimiter : --color="query:#ea4770,hl:#f9e592,hl+:#ffe579" --query "$INITIAL_QUERY" \
    --with-shell 'bash -c' \
    --bind "start,change:transform:$TRANSFORMER" \
    --bind "alt-down:preview-page-down,alt-up:preview-page-up,ctrl-s:execute(less +{2} {1})" \
    --bind "right:accept,alt-a:select-all,alt-d:deselect-all,ctrl-p:change-preview-window(99%|hidden|down,40%),ctrl-y:kill-line,alt-y:yank,alt-g:ignore,alt-s:toggle-sort" \
    --info-command='echo -e "\x1b[38;2;249;229;146m$FZF_MATCH_COUNT\x1b[0m/$FZF_TOTAL_COUNT"' \
    --preview-window 'down,40%,+{2}-4' \
    --preview 'bat --theme="Catppuccin Macchiato" --style=numbers --color=always {1} --highlight-line {2}' \
  )}")

  (( $? != 0 )) && return
  
  local -a micro_args
  for f in "${files[@]}"; do
    IFS=: read -r file line _ <<< "$f"
    micro_args+=("${file}:${line}")
  done

  micro -statusline true "${micro_args[@]}" < /dev/tty
}


file-folder() {
  selection=$(find / -type f ! -path "/proc/*" ! -path "/mnt/*" 2>/dev/null | fzf --exact --multi --height=80% \
    --preview='batcat {}' --preview-window='45%,border-sharp' \
    --bind='del:execute(rm -ri {+})' \
    --bind='ctrl-p:toggle-preview' \
    --bind='ctrl-d:reload(find / -type d ! -path "/proc/*" ! -path "/mnt/*" 2>/dev/null)' \
    --bind='ctrl-d:+change-preview(tree -C {})' \
    --bind='ctrl-d:+refresh-preview' \
    --bind='ctrl-f:+reload(find / -type f ! -path "/proc/*" ! -path "/mnt/*" 2>/dev/null)' \
    --bind='ctrl-f:+change-preview(batcat {})' \
    --bind='ctrl-f:+refresh-preview' \
  )

  if [ -d "$selection" ]; then
      cd $selection || exit
  elif [ -f "$selection" ]; then
      if sudo -u "$USER" test -w "$selection"; then
          eval "micro $selection"
  exit
      else
          eval "sudo micro $selection"
  exit
      fi
  fi
}


fzf-history-widget() {
  local selected_cmd

  selected_cmd=$(fc -rln 1 | fzf --height=70% --tmux 70% --scheme=history --exact --no-multi --no-sort --query "$LBUFFER" \
    --expect enter,ctrl-a,right,left \
    --bind 'ctrl-q:execute-silent(echo -n {} | xclip -selection clipboard)')

  key=$(head -n1 <<< "$selected_cmd")
  selected_cmd=$(tail -n +2 <<< "$selected_cmd")

  case "$key" in
    enter)
      BUFFER="$selected_cmd"
      zle accept-line
      ;;
    ctrl-a)
      BUFFER="$selected_cmd"
      CURSOR=0
      zle redisplay
      ;;
    right)
      BUFFER="$selected_cmd "
      CURSOR=$#BUFFER
      zle redisplay
      ;;
    left)
      BUFFER="${selected_cmd% *}"
      CURSOR=$#BUFFER
      zle redisplay
      ;;
    *)
      BUFFER=""
      zle redisplay
      ;;
  esac
}

# Fuzzy change directory
fzf-cd-widget() {
  local dir="${1:-$PWD}"
  local temp_dir

  temp_dir=$(
    find "$dir" -type d -printf "%P\n" 2>/dev/null | \
    fzf --height=80% --tmux 70% --layout=reverse --exact --no-multi --scheme=path \
        --preview "eza --tree --level=3 --color=always '$dir/{}'" \
        --preview-window=right:50%:wrap --ansi \
        --bind "shift-left:reload(find / -type d 2>/dev/null)" \
        --bind "shift-right:reload(find '$dir' -type d -printf '%P\n' 2>/dev/null)+change-query()" \
  )

  if [[ -n "$temp_dir" ]]; then
    cd "$temp_dir" || return
    zle accept-line
  else
    zle redisplay
  fi
}

ffd() {
  DIR=`find * -maxdepth 0 -type d -print 2> /dev/null | fzf --height=80% --tmux 70% --reverse --preview "eza --tree --level=3 --color=always {}" \
    --preview-window=right:50%:wrap` 
  cd "$DIR"
}

fzf-recency() {
  local dir=$(zoxide query -l | fzf --height=80% --tmux 70% --reverse --no-multi)
  
  if [[ -n "$dir" ]]; then
    cd "${dir/#\~/$HOME}"  
    zle .accept-line 
  else
    zle redisplay
  fi
}

# Truncate prompt length
function short_dir() {
  TRUNCATE_ON=$(( (TRUNCATE_ON + 1) % 3 ))
  p10k reload
  zle accept-line
}

# Remove right prompt
function toggle_right_prompt() {
  if (( ${#POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[@]} )); then
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
  else
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
      context
      command_execution_time_joined
      background_jobs_joined 
    )
  fi

  p10k reload
  zle accept-line
}


function lg() {
  export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir
  lazygit "$@"

  if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
    cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
    rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
  fi
}

# Yazi widget to change directory
function y() {

    local tmp cwd
    tmp="$(mktemp -t "yazi-cwd.XXXXXX")" || return
    zle -I  

    (
        exec </dev/tty >/dev/tty 2>/dev/tty
        yazi --cwd-file="$tmp"
    )

    IFS= read -r -d '' cwd < "$tmp"
    rm -f -- "$tmp"
    [[ -n "$cwd" && "$cwd" != "$PWD" ]] && builtin cd -- "$cwd"
    
    zle accept-line
}

# Run multiple background jobs
asy () {
  local worker_name=$1
  shift

  async_init 
  async_start_worker $worker_name -n

  for prog in "$@"; do
    async_job $worker_name $prog
  done
}

# Default tmux session launcher
tmux-launcher() {
  local session_name=${BUFFER:-session}

  # tmux -u new-session -A -s "$session_name" <>$TTY
  tmux -f ~/.tmux.conf -u new-session -A -s "$session_name" <> "$TTY"
  zle kill-buffer
  zle accept-line
}

# Activate widgets
zle -N fzf-find-widget
zle -N fzf-find-in-file-widget
zle -N fzf-history-widget
zle -N fzf-cd-widget
zle -N fzf-recency

zle -N tmux-launcher
zle -N short_dir
zle -N toggle_right_prompt
zle -N y    

# Hotkeys
bindkey '^F' fzf-find-widget
bindkey '^[f' fzf-find-in-file-widget
bindkey "${key[Up]}" fzf-history-widget
bindkey "\e[5~" fzf-cd-widget
bindkey "\e[6~" fzf-recency

bindkey "${key[End]}" tmux-launcher
bindkey '^S' short_dir
bindkey '^[.' toggle_right_prompt
bindkey "${key[Down]}" y
bindkey -s "^[-" "~/"
bindkey '^R' atuin-search
bindkey '^Z' undo


# Various
unsetopt PROMPT_SP
PROMPT_EOL_MARK=""
WORDCHARS="_.;~-*^|!?&#$%[](){}<>"
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'
export LS_COLORS="$(echo $LS_COLORS | sed 's/01;/00;/g')"
export PASTEL_COLOR_MODE=24bit
export COLORTERM=truecolor
export MICRO_TRUECOLOR=1
lesspipe.sh | source /dev/stdin

# Defaults
export EDITOR=micro
export SUDO_EDITOR=micro
export VISUAL=micro
export PAGER=less
export XDG_SESSION_TYPE=x11
export LANG=en_US.UTF-8
export LC_COLLATE=en_US.UTF-8
# unset LC_ALL
# export LC_ALL=en_US.UTF-8

# PATH
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/gem/ruby/3.3.0/bin:$PATH"

pokemon=(
  "volbeat" "duskull" "haunter" "hoppip" "lickitung" "vileplume" "butterfree" "dugtrio"
  "poliwag" "rapidash" "dewgong" "gengar" "onix" "koffing" "charizard" "arbok" "pikachu"
  "mr.mime" "magikarp" "dragonite" "s:gyarados" "mew" "mewtwo" "muk" "crobat" "s:azumarill"
  "unown-india" "unown-oscar" "unown-exclamation" "mantine" "entei" "ho-oh" "blaziken"
  "beautifly" "cascoon" "ludicolo" "seedot" "wingull" "surskit" "loudred" "azurill"
  "volbeat" "roselia" "wailmer" "s:spoink" "spinda" "cacnea" "seviper" "s:whiscash"
  "milotic" "castform-snowy" "chimecho" "salamence" "s:regirock" "metagross" "kyogre-primal"
  "groudon" "rayquaza" "deoxys" "empoleon" "burmy-sandy" "honchkrow" "spiritomb" "garchomp"
  "drapion" "lumineon" "magnezone" "electivire" "gliscor" "s:dusknoir" "froslass" "uxie"
  "s:giratina" "arceus-ghost"
)

alias poke='pokeshell -a "${pokemon[$((RANDOM % ${#pokemon[@]}))]}"'

# Timer
# for i in $(seq 1 10); do time zsh -i -c exit; done

# End monitoring
# zprof
