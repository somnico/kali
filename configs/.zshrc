# Path to Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Updates for Oh My Zsh
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 14

# Set Oh My Zsh theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git sudo jq zsh-autosuggestions zsh-syntax-highlighting history dirhistory command-not-found)

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
bindkey -M menuselect ^M .accept-line

# Zoxide configuration
eval "$(zoxide init zsh)"

# Aliases
alias b="batcat --paging=never --theme=ansi"
alias ba="batcat --paging=never --theme=ansi --style=changes"
alias c="rcat"
alias f="fdfind"
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

# Startup
echo "kali" | figlet -f fraktur | boxes -d ian_jones -a hcvc -p h6v0 | lolcat -f -a -d 1 -p 5 -F 0.03 -S 110

# AWS autocomplete
export PATH=/usr/libexec/:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C '/usr/libexec/aws_completer' aws

# various
WORDCHARS="_.;~-=*^|!?&#$%[](){}<>"
PROMPT_EOL_MARK=""
unsetopt PROMPT_SP

# Bold
LS_COLORS=$(echo $LS_COLORS | sed "s/01;/00;/g")
export LS_COLORS
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'

# PATH
export PATH=$PATH:~/.local/bin
