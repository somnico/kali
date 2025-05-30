# Start monitoring
# zmodload zsh/zprof

# Instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Defer
source ~/zsh-defer/zsh-defer.plugin.zsh

# Path to Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Set Oh My Zsh theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Configuration for plugins
zstyle :omz:plugins:ssh-agent quiet yes
zstyle :omz:plugins:keychain agents gpg,ssh
zstyle :omz:plugins:keychain options --quiet
# zstyle :omz:plugins:keychain identities <SSH key filenames in ~/.ssh/> <GPG key ID --list-secret-keys>
MAGIC_ENTER_GIT_COMMAND=' '
MAGIC_ENTER_OTHER_COMMAND=' '
export HISTORY_START_WITH_GLOBAL=true
export PER_DIRECTORY_HISTORY_TOGGLE='^[h'
zbell_duration=20
zstyle '*:compinit' arguments -i -u -C
bindkey ' ' magic-space

# Plugins
plugins=(
  git
  sudo
  jq
  tmux
  tmux-cssh
  aliases
  alias-finder
  zsh-no-ps2
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-navigation-tools
  command-not-found
  history
  dirhistory
  per-directory-history
  last-working-dir
  zoxide
  jump
  wd
  direnv
  copypath
  cp
  safe-paste
  transfer
  poetry
  poetry-env
  extract
  universalarchive
  colored-man-pages
  fancy-ctrl-z
  zsh-autocomplete
  fzf-tab
  thefuck
  globalias
  magic-enter
  httpie
  urltools
  web-search
  nmap
  jsontools
  percol
  gpg-agent
  ssh-agent
  ssh
  systemadmin
  zsh-prompt-benchmark
  profiles
  zbell
)

# Delayed plugin loading
zsh-defer eval "$(keychain --eval --quiet)"

# Completetion configuration
fpath=(~/.cache/completions $fpath)
fpath+=("${ZSH_CUSTOM:-${ZSH:-$HOME/.oh-my-zsh}/custom}/plugins/zsh-completions/src")

# Blank line
preexec() {echo}

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Source Powerlevel
source ~/.p10k.zsh


# Autocomplete configuration
() {local k; for k in $'\e[A' $'\eOA'; do bindkey "$k" up-line-or-history; done}
bindkey -M menuselect ^M .accept-line
bindkey -r "^[[1;3A"
zstyle ':completion:correct-word:*' max-errors 0

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' file-patterns '%p'
zstyle ':completion:*' menu no
zstyle ':completion:*' rehash true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache

# Argc comfiguration, argc_scripts=(... ...)
export ARGC_COMPLETIONS_ROOT="/home/kali/.config/argc-completions"
export ARGC_COMPLETIONS_PATH="$ARGC_COMPLETIONS_ROOT/completions/linux:$ARGC_COMPLETIONS_ROOT/completions"
export PATH="$ARGC_COMPLETIONS_ROOT/bin:$PATH"
argc_scripts=( $(ls -p -1 "$ARGC_COMPLETIONS_ROOT/completions/linux" "$ARGC_COMPLETIONS_ROOT/completions" | sed -n 's/\.sh$//p') )
source <(argc --argc-completions zsh $argc_scripts)

# Autosuggestions configuration
zstyle ':bracketed-paste-magic' active-widgets '.self-*'
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste)
ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_AUTOSUGGEST_USE_ASYNC=true
bindkey '\e[1;3C' autosuggest-execute

# Fzf configuration
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# enable-fzf-tab
source <(fzf --zsh)

my-fzf-tab() {
  functions[compadd]=$functions[-ftb-compadd]
  zle fzf-tab-complete
}
zle -N my-fzf-tab
bindkey "^I" my-fzf-tab

# Shell integrations
[ -s ~/.config/envman/PATH.env ] && source ~/.config/envman/PATH.env # Webi 
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh --disable-up-arrow | sed 's/atuin history start -- "$1"/atuin history start -- "$2"/')"


# History
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
HISTDUP=erase
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HISTFCNTLLOCK
setopt HIST_REDUCE_BLANKS

# Options
setopt CORRECT
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

DISABLE_AUTO_TITLE=true
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"


# Aliases
alias fd="fdfind"
alias b="batcat --paging=never --theme=ansi"
alias ba="batcat --paging=never --theme=ansi --style=changes"
alias ls="eza --group-directories-first --header --icons --group"
alias qq="xsel --clipboard <"
alias cop="copypath"
alias j="jump"

mkcd() {sudo mkdir -p -- "$1" && cd -- "$1"}
alias i="sudo apt-get install -y"
alias sn="sudo nano"
alias sm="sudo nano +-1"
alias rc="sudo nano +-1 ~/.zshrc && re"
alias p1="sudo nano ~/.p10k.zsh"
alias s="sudo -E zsh"
alias ch="sudo chmod +x"
alias de="sudo rm -rf"
alias k="ps aux | fzf --multi | awk '{print \$2}' | xargs -r sudo kill -15"
alias top="sudo XDG_CONFIG_HOME=$HOME/.config btop"
alias re="omz reload"
alias so="source ~/.zshrc"

alias e="/mnt/c/Windows/explorer.exe ."
alias pale="palemoon/./palemoon"

alias txs="tmuxinator start"
alias txo="tmuxinator open"	
alias txn="tmuxinator new"	
alias txl="tmuxinator list"

perm() {local target="${1:-.}"; sudo chown -R "$USER:$USER" "$target"; sudo chmod -R u+rwX,go+rX "$target"; echo "Permissions fixed"}

alias da="rclone copy Drive:/Linux/AWS/Files/ ~/files/ --include '*' -P"
alias ua="rclone copy ~/files/ Drive:/Linux/AWS/Files/ --include '*' -P"
dl() {local source="Drive:Linux/AWS/Files/"; local destination="~/files/"; file="$1"; rclone copy "${source}${file}" "${destination}";}
ul() {local source=""; local destination="Drive:Linux/AWS/Files/"; source="$1"; rclone copy "${source}" "${destination}";}
0x() {curl -F file=@"$1" -F expires=168 https://0x0.st}
u() {curl -s -F "files[]=@$1" https://uguu.se/upload | jq -r '.files[0].url'}
alias ws="wormhole send"


# Fuzzy finder defaults
export FZF_DEFAULT_OPTS="
  --color=fg:#dadce9,fg+:#e9e9e9,bg:#292d3e,bg+:#33394f
  --color=hl:#c8ff9e,hl+:#baffe7,info:#ae98ff,marker:#ae98ff
  --color=prompt:#292d3e,spinner:#ae98ff,pointer:#ae98ff,header:#82AAFF
  --color=gutter:#292d3e,border:#343b54,scrollbar:#343b54,preview-bg:#292d3e
  --color=preview-border:#31374f,preview-scrollbar:#31374f,preview-label:#31374f,label:#31374f
  --color=query:#c8ff9e
  --border=rounded --preview-window=border-rounded --prompt='  '
  --marker='▌' --pointer='▌' --border-label='' --separator='' --scrollbar='' --info=default
  --tmux center
"

export FZF_TMUX=1
export FZF_TMUX_OPTS=""

# Adjust background color based on environment
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=bg:#1f2335,preview-bg:#1f2335,gutter:#1f2335"
fi 

# export FZF_DEFAULT_COMMAND="fdfind -H -t d --follow -E /mnt/c -E .git"
# export FZF_DEFAULT_COMMAND="locate -i '' | grep -vE '/mnt/|\.git/'"

# Fzf-tab styling
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --tree --level=3 --color=always ${realpath}'
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' popup-pad 100 100
zstyle ':fzf-tab:*' popup-min-size 20 10


tes() {
  result=$(fdfind -t d -E "/mnt" | fzf $1)
  cd $result
  unset result
}

# Fuzzy search
f() {
  fzf --multi --exact --layout=reverse --info=default --border --height=70% \
      --preview "batcat --paging=never --theme=ansi --style=numbers --color=always {}" \
      --preview-window "right,50%" \
      --bind "pgdn:page-down,pgup:page-up" \
      --bind "ctrl-q:execute-silent(cat {+} | xclip -selection clipboard)+reload(fdfind -t f --hidden)" \
      --bind "ctrl-x:execute(trash {+})+reload(find . -type f)" \
      --bind "ctrl-n:become(sudo nano {+})" \
      --bind "ctrl-r:become(source {+})"
}

# Custom fuzzy search
fzf-find-widget() {
  local dir="${1:-$PWD}"

  locate "$dir" | awk -v dir="$dir" '$0 ~ dir {sub(dir "/?", ""); print}' | \
  fzf --multi --exact --layout=reverse --info=default --border --height=70% \
      --preview 'batcat --paging=never --theme=ansi --style=numbers --color=always {}' \
      --preview-window 'right,50%' \
      --bind 'pgdn:page-down,pgup:page-up' \
      --bind 'ctrl-n:become(sudo nano {+})' \
      --bind "shift-left:reload(locate / | awk '{print}')" \
      --bind "shift-right:reload(locate '$dir' | awk -v dir='$dir' '\$0 ~ dir {sub(dir \"/?\", \"\"); print}')"

  echo -e "\r"
  zle redisplay
}

# Fuzzy search in file
ff() {
  local RG_PREFIX="rg --line-number --no-heading --color=always --smart-case --hidden --glob '!**/.git/*'"
  local INITIAL_QUERY="${*:-}"

  fzf --layout=reverse --multi --info=default --border --height=100% \
      --ansi --disabled --query "$INITIAL_QUERY" \
      --bind "start:reload:$RG_PREFIX {q}" \
      --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
      --delimiter : \
      --preview 'batcat --theme=base16 --style="numbers" --color=always {1} --highlight-line {2}' \
      --preview-window 'down,35%,+{2}-3' \
      --bind 'enter:become(sudo nano -Y sh $(for f in {+}; do echo "+$(cut -d: -f2 <<< $f) $(cut -d: -f1 <<< $f)"; done))'
}

# Fuzzy history search
fzf-history-widget() {
  local selected_cmd temp_cmd

  temp_cmd=$(fc -rln 1 | tac | fzf +s --height=60% --exact --tac --query "$LBUFFER" \
    --bind 'enter:accept' \
    --bind 'right:execute-silent(echo {} > ~/.fzf_right_arrow_cmd)+abort' \
    --bind 'ctrl-a:execute-silent(echo {} > ~/.fzf_ctrl_a_cmd)+abort' \
    --bind 'left:execute-silent(echo "$(echo {} | sed "s/[^ ]* *$//")" > ~/.fzf_left_arrow_cmd)+abort' \
    --bind 'ctrl-c:abort' \
    --bind 'ctrl-q:execute-silent(echo -n {} | xclip -selection clipboard)+abort'
    )

  if [[ $? -eq 0 ]]; then
    BUFFER=$temp_cmd
    zle accept-line

  elif [[ -f ~/.fzf_right_arrow_cmd ]]; then
    BUFFER="$(<~/.fzf_right_arrow_cmd) "
    rm ~/.fzf_right_arrow_cmd
    CURSOR=$#BUFFER
    zle redisplay

  elif [[ -f ~/.fzf_ctrl_a_cmd ]]; then
    BUFFER="$(<~/.fzf_ctrl_a_cmd)"
    rm ~/.fzf_ctrl_a_cmd
    CURSOR=0
    zle redisplay

  elif [[ -f ~/.fzf_left_arrow_cmd ]]; then
    BUFFER="$(<~/.fzf_left_arrow_cmd)"
    rm ~/.fzf_left_arrow_cmd
    CURSOR=$#BUFFER
    zle redisplay

  else
    BUFFER=""
    zle redisplay
  fi
}

# Fuzzy change directory
fzf-cd-widget() {
  local dir="${1:-$PWD}"
  local temp_dir

  temp_dir=$(
    find "$dir" -type d -printf "%P\n" 2>/dev/null | \
    fzf --layout=reverse --exact --height=80% \
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

# Recent directories
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':completion:*:*:cdr:*:*' menu selection
zstyle ':completion:*' recent-dirs-insert fallback
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-max 0
zstyle ':chpwd:*' recent-dirs-file ~/.cache/.chpwd-recent-dirs

fzf-recency() {
  local dir
  # dir=$(cdr -l | awk '{$1=""; print substr($0,2)}' | fzf --height=80% --reverse)
  dir=$(zoxide query -l | fzf --height=80% --reverse)
  
  if [[ -n "$dir" ]]; then
    cd "${dir/#\~/$HOME}"  
    zle .accept-line 
  else
    zle reset-prompt
  fi
}

function short_dir() {
  TRUNCATE_ON=$(( (TRUNCATE_ON + 1) % 3 ))
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

# Activate widgets
zle -N fzf-find-widget
zle -N fzf-history-widget
zle -N fzf-cd-widget
zle -N fzf-recency

zle -N short_dir

# Hotkeys
bindkey '^F' fzf-find-widget
bindkey "${key[Up]}" fzf-history-widget
bindkey "\e[5~" fzf-cd-widget
bindkey "\e[6~" fzf-recency

bindkey -s "^[-" "~/"
bindkey '^Z' undo
bindkey '^S' short_dir

# Various
export LC_ALL="C"
WORDCHARS="_.;~-*^|!?&#$%[](){}<>"
PROMPT_EOL_MARK=""
unsetopt PROMPT_SP

# Remove bold
# export LS_COLORS="$(vivid generate dracula)"
export LS_COLORS="$(echo $LS_COLORS | sed 's/01;/00;/g')"
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'

# Startup
# echo "kali" | figlet -f fraktur | boxes -d ian_jones -a hcvc -p h6v0 | lolcat -f -a -d 1 -p 5 -F 0.03 -S 110

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


# Default editor
export EDITOR=nano

# Long paths
hash -d h=/long/useless/path/to/project

# PATH
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.local/share/gem/ruby/3.3.0/bin:$PATH"

# Timer
# for i in $(seq 1 10); do time zsh -i -c exit; done

# End monitoring
# zprof
