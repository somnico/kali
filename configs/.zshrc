export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git sudo zsh-autosuggestions zsh-syntax-highlighting history dirhistory command-not-found)

preexec() {echo}

source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ -r ~/.oh-my-zsh/plugins/znap/znap.zsh ]] || git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git ~/.oh-my-zsh/plugins/znap
source ~/.oh-my-zsh/plugins/znap/znap.zsh
znap source marlonrichert/zsh-autocomplete
bindkey -M menuselect ^M .accept-line

eval "$(zoxide init zsh)"

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
alias da="rclone copy Drive:/Linux/AWS/Files/ /home/kali/files/ --include '*' -P"
alias ua="rclone copy /home/kali/files/ Drive:/Linux/AWS/Files/ --include '*' -P"
dl() {local source="Drive:Linux/AWS/Files/"; local destination="/home/kali/files/"; file="$1"; rclone copy "${source}${file}" "${destination}";}
ul() {local source=""; local destination="Drive:Linux/AWS/Files/"; source="$1"; rclone copy "${source}" "${destination}";}
bindkey -s "^[-" "~/"

echo "kali" | figlet -f fraktur | boxes -d ian_jones -a hcvc -p h6v0 | lolcat -f -a -d 1 -p 5 -F 0.03 -S 110

WORDCHARS="_.;~-=*^|!?&#$%[](){}<>"
PROMPT_EOL_MARK=""
unsetopt PROMPT_SP

export PATH=/usr/libexec/:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C '/usr/libexec/aws_completer' aws

export PATH=$PATH:/home/kali/.local/bin
