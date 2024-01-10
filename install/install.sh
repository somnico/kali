#!/usr/bin/zsh

# Remove message
touch ~/.hushlogin

# Update package information
sudo apt-get update

# Set debconf to noninteractive
echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

# Configure default keyboard layout 
echo "keyboard-configuration keyboard-configuration/layoutcode string no" | sudo debconf-set-selections
echo "keyboard-configuration keyboard-configuration/variantcode string winkeys" | sudo debconf-set-selections

# Set default value for Wireshark pop up
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections

# Set default value for OpenSSH pop up
echo 'openssh-server openssh-server/upgrade-configuration select install' | sudo debconf-set-selections

# Upgrade pacakges
# sudo apt-get upgrade -y

# Install Kali
sudo apt-get install -y kali-desktop-xfce xfconf kali-defaults kali-tools-top10 

# Install other tools
sudo apt-get install -y neovim ghidra exiftool dirb dig dconf-cli tightvncserver expect


# Setup VNC server "kalikali"
mkdir -p /home/kali/.vnc
sudo wget -P /home/kali/.vnc/ https://raw.githubusercontent.com/somnico/kali/master/configs/passwd
sudo chown -R kali:kali /home/kali/.vnc
sudo chmod 700 /home/kali/.vnc
sudo chmod 600 /home/kali/.vnc/*

# Set password "kali"
sudo wget -N -P /etc/ https://raw.githubusercontent.com/somnico/kali/master/configs/shadow

# Set time
sudo timedatectl set-timezone Europe/Oslo

# Change wallpaper 
sudo apt install -y kali-wallpapers-all
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image --create -t string -s /usr/share/backgrounds/kali-16x9/kali-layers.png

# Change icons
sudo mkdir -p /usr/share/icons/Flat-Remix-Blue-Dark/apps/scalable/
sudo curl -o /usr/share/icons/Flat-Remix-Blue-Dark/apps/scalable/firefox-esr.svg https://raw.githubusercontent.com/somnico/kali/master/images/icons/firefox-esr.svg
sudo curl -o /usr/share/icons/Flat-Remix-Blue-Dark/apps/scalable/org.xfce.filemanager.svg https://raw.githubusercontent.com/somnico/kali/master/images/icons/org.xfce.filemanager.svg
sudo curl -o /usr/share/icons/Flat-Remix-Blue-Dark/apps/scalable/utilities-terminal.svg https://raw.githubusercontent.com/somnico/kali/master/images/icons/utilities-terminal.svg

# Various settings
xfconf-query --create --channel thunar --property /last-show-hidden --type bool --set true

xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-home -s false
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-filesystem -s false
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-trash -s false

sudo mkdir -p /home/kali/.config/xfce4/panel/launcher-5/
sudo mkdir -p /home/kali/.config/xfce4/panel/launcher-6/
sudo mkdir -p /home/kali/.config/xfce4/panel/launcher-7/
sudo mkdir -p /home/kali/.config/xfce4/xfconf/xfce-perchannel-xml/

sudo curl -o /home/kali/.config/xfce4/panel/launcher-5/launcher-5.desktop https://raw.githubusercontent.com/somnico/kali/master/configs/launcher-5.desktop
sudo curl -o /home/kali/.config/xfce4/panel/launcher-6/launcher-6.desktop https://raw.githubusercontent.com/somnico/kali/master/configs/launcher-6.desktop
sudo curl -o /home/kali/.config/xfce4/panel/launcher-7/launcher-7.desktop https://raw.githubusercontent.com/somnico/kali/master/configs/launcher-7.desktop
sudo curl -o /home/kali/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml https://raw.githubusercontent.com/somnico/kali/master/configs/xfce4-panel.xml

xfconf-query -c xfce4-panel -p /panels/panel-1/icon-size -n -t int -s 22
xfconf-query -c xfce4-panel -p /panels/panel-1/size -n -t int -s 36
xfconf-query -c xfce4-panel -p /panels/panel-1/background-style -n -t int -s 1
xfconf-query -c xfce4-panel -p /panels/panel-1/background-rgba -n -t double -t double -t double -t double -s 0.160784 -s 0.176471 -s 0.243137 -s 1

# Install font
sudo mkdir -p /usr/share/fonts/truetype/consolas/
sudo wget -P /usr/share/fonts/truetype/consolas/ https://github.com/somnico/kali/raw/master/images/fonts/ConsolasNerdFontMono.ttf 

# Change global font
xfconf-query -c xsettings -p /Gtk/FontName -s "Consolas NF 11"
xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "Consolas NF 10"

# Change terminal settings 
mkdir -p /home/kali/.config/qterminal.org/
touch /home/kali/.config/qterminal.org/qterminal.ini

mkdir -p /home/kali/.config/qt5ct/
touch /home/kali/.config/qt5ct/qt5ct.conf

sudo chmod a+w /usr/share/qtermwidget5/color-schemes/
sudo curl -o /usr/share/qtermwidget5/color-schemes/Palenight.colorscheme https://raw.githubusercontent.com/somnico/kali/master/configs/palenight.colorscheme

sudo curl -o /home/kali/.config/qterminal.org/qterminal.ini https://raw.githubusercontent.com/somnico/kali/master/configs/qterminal.ini
sudo curl -o /home/kali/.config/qt5ct/qt5ct.conf https://raw.githubusercontent.com/somnico/kali/master/configs/qt5ct.conf


# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/fdellwing/zsh-bat.git $ZSH_CUSTOM/plugins/zsh-bat
sudo apt-get install -y bat zoxide lsd

# Plugin customization
sudo curl -o /home/kali/.oh-my-zsh/plugins/dirhistory/dirhistory.plugin.zsh https://raw.githubusercontent.com/somnico/kali/master/configs/dirhistory.plugin.zsh

# Install Powerlevel10k 
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Set theme to powerlevel10k
sudo sed -i 's+ZSH_THEME="robbyrussell"+ZSH_THEME="powerlevel10k/powerlevel10k"+' ~/.zshrc

# Keybinds
sudo curl -o /home/kali/.oh-my-zsh/lib/key-bindings.zsh https://raw.githubusercontent.com/somnico/kali/master/configs/key-bindings.zsh

# Customization
sudo sed -i 's+plugins=(git)+plugins=(\
  git\
  sudo\
  zsh-autosuggestions\
  zsh-syntax-highlighting\
  history\
  dirhistory\
  command-not-found\
)+' ~/.zshrc

mkdir -p ~/.oh-my-zsh/plugins/znap/
sudo sed -i '/source $ZSH\/oh-my-zsh.sh/a\
\
[[ -r ~/.oh-my-zsh/plugins/znap/znap.zsh ]] || git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git ~/.oh-my-zsh/plugins/znap\
source ~/.oh-my-zsh/plugins/znap/znap.zsh\
znap source marlonrichert/zsh-autocomplete\
bindkey -M menuselect '\\r' .accept-line
' ~/.zshrc

sudo sed -i '/source $ZSH\/oh-my-zsh.sh/i\
preexec() {\
  echo\
}\
' ~/.zshrc

sudo sed -i '/^# alias ohmyzsh="mate ~\/.oh-my-zsh"/a\
alias b="batcat --paging=never --theme=ansi"\
alias ba="batcat --paging=never --theme=ansi --style=changes"\
alias c="rcat"\
alias f="fdfind"\
alias i="sudo apt-get install -y"\
alias sn="sudo nano"\
alias sm="sudo nano +-1"\
alias ch="sudo chmod +x"\
alias de="sudo rm -rf"\
alias rc="sudo nano +-1 ~/.zshrc"\
alias p1="sudo nano ~/.p10k.zsh"\
alias re="omz reload"\
alias pale="palemoon/./palemoon"\
alias da="rclone copy Drive:/Linux/AWS/Files/ /home/kali/files/ --include '\''*'\'' -P"\
alias ua="rclone copy /home/kali/files/ Drive:/Linux/AWS/Files/ --include '\''*'\'' -P"\
' ~/.zshrc

echo 'dl() { local source="Drive:Linux/AWS/Files/"; local destination="/home/kali/files/"; file="$1"; rclone copy "${source}${file}" "${destination}"; }' >> ~/.zshrc
echo 'ul() { local source=""; local destination="Drive:Linux/AWS/Files/"; source="$1"; rclone copy "${source}" "${destination}"; }' >> ~/.zshrc
echo '' >> ~/.zshrc
echo 'WORDCHARS="_.;~-=*^|!?&#$%[](){}<>"'>> ~/.zshrc
echo 'PROMPT_EOL_MARK=""' >> ~/.zshrc
echo 'unsetopt PROMPT_SP' >> ~/.zshrc
echo '' >> ~/.zshrc
echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
echo '' >> ~/.zshrc
echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc
echo '' >> ~/.zshrc
echo 'export PATH=$PATH:/home/kali/.local/bin' >> ~/.zshrc
echo '' >> ~/.zshrc

# Powerlevel configuration
curl https://gist.githubusercontent.com/somnico/b71f23f21f931d6d9c2445719c571ab5/raw/ > ~/.p10k.zsh


# Install pwntools
sudo apt-get install -y python3 python3-pip python3-dev git libssl-dev libffi-dev build-essential
source ~/.profile
python3 -m pip install --upgrade pip --no-warn-script-location
python3 -m pip install --upgrade pwntools --no-warn-script-location

# Install gdb
sudo apt-get install -y gdb

# Download peda
git clone https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit

# Script for gdb
curl -o /home/kali/peda/pid.sh https://raw.githubusercontent.com/somnico/kali/master/scripts/gdb_pid.sh
sudo chmod +x pid.sh

# Install helpers
sudo apt-get install -y nodejs npm
sudo npm install -g tldr
sudo apt-get install -y fzf fd-find ripgrep
sudo updatedb

# Install browser
wget "https://www.palemoon.org/download.php?mirror=eu&bits=64&type=linuxgtk3" -O palemoon.tar.xz
tar -xvf palemoon.tar.xz
rm palemoon.tar.xz

# Install rclone
sudo curl https://rclone.org/install.sh | sudo bash
python3 -m pip install gdown --no-warn-script-location
mkdir -p /home/kali/.config/rclone/ /home/kali/files/
# sudo curl -L -o /home/kali/.config/rclone/rclone.conf "your_link"

# Install a bunch of random stuff
sudo apt-get install -y fortune cowsay lolcat boxes neofetch cmatrix moreutils sl libaa-bin pv jp2a oneko scdoc pkg-config

yes | sudo sh -c "$(curl https://codeberg.org/anhsirk0/fetch-master-6000/raw/branch/main/install.sh)"

sudo apt-get install -y figlet 
git clone https://github.com/hIMEI29A/FigletFonts.git
cd FigletFonts
sudo make
cd ..

sudo apt-get install -y libncursesw5-dev
git clone https://gitlab.com/jallbrit/cbonsai
cd cbonsai
sudo make install 2> /dev/null
cd ..

sudo curl -o /etc/boxes/boxes-config https://raw.githubusercontent.com/somnico/kali/master/configs/boxes-config
sudo curl -o /usr/share/figlet/fraktur.flf https://raw.githubusercontent.com/somnico/kali/master/configs/fraktur.flf

cat << 'EOF' >> ~/.zshrc
echo "kali" | figlet -f fraktur | boxes -d ian_jones -a hcvc -p h6v0 | lolcat -f -a -d 1 -p 5 -F 0.03 -S 110
EOF


# Setup AWS CLI
expect << 'EOF'
set timeout 10

spawn aws configure

expect {AWS Access Key ID \[*\]:}
send "your_id_here\r"

expect {AWS Secret Access Key \[*\]:}
send "your_key_here\r"

expect {Default region name \[*\]:}
send "eu-north-1\r"

expect {Default output format \[*\]:}
send "\r"

expect eof
EOF

# Add AWS CLI autocompletion
echo '' >> ~/.zshrc
echo "export PATH=/usr/libexec/:$PATH
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C '/usr/libexec/aws_completer' aws" >> ~/.zshrc


# Reset debconf
unset DEBIAN_FRONTEND

# Start VNC server
tightvncserver -geometry 1600x900        

# Update terminal
exec zsh
                                         

# Notes

# Consistent gist links
# gistusercontent/raw or gistusercontent/raw/filename 
 
# Set password
# echo -e "kali\nkali" | sudo passwd kali

# Commands for file sharing
# Web application instead of Desktop app in Google Credentials
# rclone config
# rclone lsd Drive:
# curl -L -o file.type "https://drive.google.com/uc?id=id_here"

# More backgrounds
# sudo mkdir -p /usr/share/backgrounds/windows
# sudo curl -o /usr/share/backgrounds/windows/windows-wallpaper-1.jpg https://raw.githubusercontent.com/somnico/kali/master/images/backgrounds/kali-actiniaria.png

# More fonts
# git clone --depth=1 --branch=master https://github.com/ryanoasis/nerd-fonts.git nerd-fonts
# ./nerd-fonts/install.sh FiraCode
# sudo cp -r nerd-fonts/patched-fonts/FiraCode/Regular /usr/share/fonts/truetype/firanerd

# GUI updates
# xfdesktop -Q && xfdesktop &
# pkill xfce4-panel && xfce4-panel &

# Install only one font family 
# sudo apt-get install -y subversion
# svn checkout --depth=empty https://github.com/ryanoasis/nerd-fonts/trunk/patched-fonts
# cd patched-fonts
# svn update --set-depth=infinity DejaVuSansMono
# cd ..
# sudo cp -r patched-fonts/DejaVuSansMono/Regular/DejaVuSansMNerdFontMono-Regular.ttf /usr/share/fonts/truetype/dejavu

# Various fonts
# sudo apt-get install -y fonts-powerline

# Individual entries for qterminal 
# sudo sed -i 's/\(colorScheme=\).*/\1Palenight/' /home/kali/.config/qterminal.org/qterminal.ini
# sudo sed -i 's/\(guiStyle=\).*/\1qt5ct-style/' /home/kali/.config/qterminal.org/qterminal.ini
# sudo sed -i 's/\(fontFamily=\).*/\1DejaVuSansM Nerd Font Mono/' /home/kali/.config/qterminal.org/qterminal.ini

# Change syntax highlighting theme
# git clone https://github.com/dracula/zsh-syntax-highlighting.git
# sudo sed -i '/# ZSH_CUSTOM=\/path\/to\/new-custom-folder/a\
# \
# source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.sh' ~/.zshrc

# Various docks
# sudo apt-get install -y cairo-dock
# sudo apt-get install -y plank
# sudo apt-get install -y intltool libx11-dev libxext-dev libxrender-dev libxtst-dev pkg-config libglib2.0-dev libgtk-3-dev libwnck-3-dev libxfce4ui-2-dev libxfce4panel-2.0-dev 
# sudo apt-get install -y wget xorg-dev libglib2.0-cil-dev golang-gir-gio-2.0-dev libgtk-3-dev libwnck-3-dev libxfce4ui-2-dev libxfce4panel-2.0-dev intltool
# wget https://archive.xfce.org/src/panel-plugins/xfce4-docklike-plugin/0.4/xfce4-docklike-plugin-0.4.0.tar.bz2
# tar -xvjf xfce4-docklike-plugin-0.4.0.tar.bz2 && cd xfce4-docklike-plugin-0.4.0
# ./configure
# make
# sudo make install

# Greetings
# fortune | cowsay -f "$(ls /usr/share/cowsay/cows | sort -R | head -1)" | lolcat -a -d 1
# echo "kali" | figlet -f fraktur | boxes -d twisted -a hcvc -p h6v1 | awk -v cols=$(tput cols) '{ printf "%*s\n", (cols + length) / 2, $0 }' | lolcat -f -a -d 1 -p 5 -F 0.03 -S 30
# fortune | cowsay -f calvin | boxes -d columns -a c | awk -v cols=$(tput cols) '{ printf "%*s\n", (cols + length) / 2, $0 }' | lolcat -a -d 1 -S 20
# fm6000 -dog -l 50 -say "$(echo "KALI" | figlet -f big)" | lolcat -a -d 1 -S 19
# fortune | cowsay -f "$(ls /usr/share/cowsay/cows | sort -R | head -1)" | while IFS= read -r line; do printf "%s" "$line" | while IFS= read -n1 -r char; do printf "%s" "$char"; sleep 0.0001; done; echo; done;

# Display clock
# while sleep 1;do tput sc;tput cup 0 $(($(tput cols)-29));date;tput rc;done &

# Alternatives
# 3d_diagonal, Big_Money-ne, Chiseled, cosmike, doubleshorts, Elite, doubleshorts, fraktur, Georgia11, ghost, henry3d, lildevil, larry3d, lineblocks
# columns, ian_jones, twisted

# Remove VNC settings
# sudo rm -rf ~/.vnc/passwd ~/.vnc/xstartup
# sudo rm -rf /tmp/.X*-lock /tmp/.X11-unix/X*
# sudo kill -9 $(ps aux | grep '[X]tightvnc' | awk '{print $2}')

# Various 
# xfconf-query -c xfce4-desktop -p /desktop-icons/gravity --create -t int -s 1
# xfconf-query -c xsettings -p /Net/PreferredApplications/TextEditor -n -t string -s "org.xfce.mousepad.desktop" 
# xfdesktop -A  

# Xfconf reference
# for channel in $( xfconf-query --list | tail --lines=+2 | sort ); do printf -- '\n\e[1;36m%s\e[m\n' "${channel}"; xfconf-query --list --verbose --channel "${channel}"; done

# Keybind reference
# https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets
# /home/kali/.oh-my-zsh/lib/key-bindings.zsh
# bindkey 
# showkey --ascii
# man ascii

# Color reference
# for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
