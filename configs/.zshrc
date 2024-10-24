# Path to Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Updates for Oh My Zsh
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 14

# Set Oh My Zsh theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git sudo jq fzf-tab zsh-autosuggestions zsh-syntax-highlighting history dirhistory command-not-found)

# Completetion configuration
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -Uz compinit && compinit

# Blank line
preexec() {echo}

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Source Powerlevel
source ~/.p10k.zsh

# Autocomplete configuration
[[ -r ~/.oh-my-zsh/plugins/znap/znap.zsh ]] || git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git ~/.oh-my-zsh/plugins/znap
source ~/.oh-my-zsh/plugins/znap/znap.zsh
znap source marlonrichert/zsh-autocomplete
zstyle ':autocomplete:history-search-backward:*' list-lines 10
bindkey -M menuselect ^M .accept-line
bindkey -M menuselect '^A' .beginning-of-line
bindkey -M menuselect '^[[D' .backward-char '^[OD' .backward-char
bindkey -M menuselect '^[[C' .forward-char '^[OC'  .forward-char
bindkey -M menuselect '^[[1;5D' .backward-word '^[1;5D' .backward-word

# Shell integrations
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init --cmd cd zsh)"

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# History
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Aliases
alias f="fzf --multi --layout=reverse --info=inline --border --height=80% --preview 'batcat --paging=never --theme=ansi-dark --style=numbers --color=always {}' --preview-window 'right,50%' --bind 'right:preview-down,left:preview-up,pgdn:preview-page-down,pgup:preview-page-up'"  
alias k="ps aux | fzf --multi | awk '{print \$2}' | xargs -r sudo kill -15"
alias b="batcat --paging=never --theme=ansi-dark"
alias ba="batcat --paging=never --theme=ansi-dark --style=changes"
alias c="rcat"
alias fd="fdfind"
alias i="sudo apt-get install -y"
alias sn="sudo nano"
alias sm="sudo nano +-1"
alias ch="sudo chmod +x"
alias de="sudo rm -rf"
alias rc="sudo nano +-1 ~/.zshrc"
alias p1="sudo nano ~/.p10k.zsh"
alias re="omz reload"
alias pale="palemoon/./palemoon"
alias da="rclone copy Drive:/Linux/AWS/Files/ ~/files/ --include '*' -P"
alias ua="rclone copy ~/files/ Drive:/Linux/AWS/Files/ --include '*' -P"
dl() {local source="Drive:Linux/AWS/Files/"; local destination="~/files/"; file="$1"; rclone copy "${source}${file}" "${destination}";}
ul() {local source=""; local destination="Drive:Linux/AWS/Files/"; source="$1"; rclone copy "${source}" "${destination}";}
bindkey -s "^[-" "~/"

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#dadce9,fg+:#e9e9e9,bg:#292d3e,bg+:#33394f
  --color=hl:#e3e5ec,hl+:#dcffc2,info:#ae98ff,marker:#ae98ff
  --color=prompt:#292d3e,spinner:#ae98ff,pointer:#ae98ff,header:#82AAFF
  --color=gutter:#292d3e,border:#343b54,scrollbar:#343b54,preview-bg:#292d3e
  --color=preview-border:#31374f,preview-scrollbar:#31374f,preview-label:#31374f,label:#31374f
  --color=query:#c8ff9e
  --border="rounded" --preview-window="border-rounded" --prompt="  "
  --marker="•" --pointer="•" --border-label="" --separator="" --scrollbar="" --info="default"'

ff() {
  local RG_PREFIX="rg --line-number --no-heading --color=always --smart-case --hidden --glob '!**/.git/*'"
  local INITIAL_QUERY="${*:-}"

  fzf --layout=reverse --multi --info=default --border --height=100% \
      --ansi --disabled --query "$INITIAL_QUERY" \
      --bind "start:reload:$RG_PREFIX {q}" \
      --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
      --delimiter : \
      --preview 'batcat --theme=base16 --color=always {1} --highlight-line {2}' \
      --preview-window 'down,40%,+{2}+3/3,~3' \
      --bind 'enter:become(sudo nano -Y sh $(for f in {+}; do echo "+$(cut -d: -f2 <<< $f) $(cut -d: -f1 <<< $f)"; done) )'
}

# AWS autocomplete
export PATH=/usr/libexec/:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
autoload bashcompinit && bashcompinit
# autoload -Uz compinit && compinit
complete -C '/usr/libexec/aws_completer' aws

# Various
WORDCHARS="_.;~-=*^|!?&#$%[](){}<>"
PROMPT_EOL_MARK=""
unsetopt PROMPT_SP

# Remove bold
LS_COLORS=$(echo $LS_COLORS | sed "s/01;/00;/g")
export LS_COLORS
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'

# Generated for envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Startup
echo "kali" | figlet -f fraktur | boxes -d ian_jones -a hcvc -p h6v0 | lolcat -f -a -d 1 -p 5 -F 0.03 -S 110

# PATH
export PATH=$PATH:~/.local/bin
