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

# Set default values for Wireshark pop up
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections

# Install Kali
sudo apt-get install -y kali-desktop-xfce xfconf kali-defaults kali-tools-top10 

# Install other tools
sudo apt-get install -y neovim ghidra dirb

# Install VNC server and expect
sudo apt-get install -y tightvncserver expect

# Set VNC paswword
expect << 'EOF'
set timeout 10

spawn vncpasswd

expect {Password:}
send "kalikali\r"

expect {Verify:}
send "kalikali\r"

expect {Would you like to enter a view-only password (y/n)?}
send "n\r"

expect eof
EOF


# Set password
echo -e "kalikali\nkalikali" | sudo passwd kali

# Install wallpapers
sudo apt install -y kali-wallpapers-all

# Change wallpaper 
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image --create -t string -s /usr/share/backgrounds/kali-16x9/kali-layers.png

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

xfconf-query -c xfce4-panel -p /panels/panel-1/icon-size -n -t int -s 20 
xfconf-query -c xfce4-panel -p /panels/panel-1/size -n -t int -s 36
xfconf-query -c xfce4-panel -p /panels/panel-1/background-style -n -t int -s 1
xfconf-query -c xfce4-panel -p /panels/panel-1/background-rgba -n -t double -t double -t double -t double -s 0.160784 -s 0.176471 -s 0.243137 -s 1

# Install fonts
git clone --depth=1 --branch=master https://github.com/ryanoasis/nerd-fonts.git nerd-fonts
sudo cp -r nerd-fonts/patched-fonts/DejaVuSansMono /usr/share/fonts/truetype/dejavu
./nerd-fonts/install.sh DejaVuSansMono

# Change global fonts
xfconf-query -c xsettings -p /Gtk/FontName -s "DejaVuSansM Nerd Font Mono 11"
xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "DejaVuSansM Nerd Font Mono 10"

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

# Install Powerlevel10k 
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Set theme to powerlevel10k
sudo sed -i 's+ZSH_THEME="robbyrussell"+ZSH_THEME="powerlevel10k/powerlevel10k"+' .zshrc


# Customization
sudo sed -i '/^# alias ohmyzsh="mate ~\/.oh-my-zsh"/a\
alias rc="sudo nano ~/.zshrc"\
alias p1="sudo nano ~/.p10k.zsh"\
alias re="omz reload"' ~/.zshrc

sudo sed -i 's+plugins=(git)+plugins=(\
  git\
  sudo\
  zsh-autosuggestions\
  zsh-syntax-highlighting\
  history\
  dirhistory\
)+' ~/.zshrc

sudo sed -i '/source $ZSH\/oh-my-zsh.sh/i\
preexec() {\
  echo\
}\
' ~/.zshrc

echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc
echo 'unsetopt PROMPT_SP' >> ~/.zshrc
echo 'export PATH=$PATH:/home/kali/.local/bin' >> ~/.zshrc

# Install dconf-cli
sudo apt-get install -y dconf-cli

# Powerlevel configuration
curl https://gist.githubusercontent.com/somnico/b71f23f21f931d6d9c2445719c571ab5/raw/ > ~/.p10k.zsh


# Install gdb
sudo apt-get install -y gdb

# Install pwntools
sudo apt-get install -y python3 python3-pip python3-dev git libssl-dev libffi-dev build-essential
python3 -m pip install --upgrade pip --no-warn-script-location
python3 -m pip install --upgrade pwntools --no-warn-script-location

# Download peda
git clone https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit

# PID script for gdb
curl -O https://raw.githubusercontent.com/somnico/kali/master/scripts/gdb_pid.sh
sudo chmod +x gdb_pid.sh


# Install helpers
sudo apt-get install -y nodejs npm
sudo npm install -g tldr
sudo apt-get install -y fzf


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
sudo make install
cd ..

sudo curl -o /etc/boxes/boxes-config https://raw.githubusercontent.com/somnico/kali/master/configs/boxes-config
sudo curl -o /usr/share/figlet/fraktur.flf https://raw.githubusercontent.com/somnico/kali/master/configs/fraktur.flf

cat << 'EOF' >> ~/.zshrc
echo "kali" | figlet -f fraktur | boxes -d ian_jones -a hcvc -p h6v1 | lolcat -f -a -d 1 -p 5 -F 0.03 -S 30
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
echo "export PATH=/usr/libexec/:$PATH
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C '/usr/libexec/aws_completer' aws" >> ~/.zshrc


# Reset debconf
unset DEBIAN_FRONTEND

# Update terminal
exec zsh

# Start VNC server
touch ~/.Xauthority
tightvncserver -geometry 1600x900


# Notes

# Consistent gist links
# gistusercontent/raw or gistusercontent/raw/filename 
 
# More backgrounds
# sudo mkdir -p /usr/share/backgrounds/windows
# sudo curl -o /usr/share/backgrounds/windows/windows-wallpaper-1.jpg https://raw.githubusercontent.com/somnico/kali/master/images/windows-wallpaper-1.jpg

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

# Various 
# xfconf-query -c xfce4-desktop -p /desktop-icons/gravity --create -t int -s 1
# xfconf-query -c xsettings -p /Net/PreferredApplications/TextEditor -n -t string -s "org.xfce.mousepad.desktop" 
# xfdesktop -A  

# Greetings
# echo "kali" | figlet -f fraktur | boxes -d twisted -a hcvc -p h6v1 | awk -v cols=$(tput cols) '{ printf "%*s\n", (cols + length) / 2, $0 }' | lolcat -f -a -d 1 -p 5 -F 0.03 -S 30
# fortune | cowsay -f calvin | boxes -d columns -a c | awk -v cols=$(tput cols) '{ printf "%*s\n", (cols + length) / 2, $0 }' | lolcat -a -d 1 -S 20
# fm6000 -dog -l 50 -say "$(echo "KALI" | figlet -f big)" | lolcat -a -d 1 -S 19
# fortune | cowsay -f "$(ls /usr/share/cowsay/cows | sort -R | head -1)" | while IFS= read -r line; do printf "%s" "$line" | while IFS= read -n1 -r char; do printf "%s" "$char"; sleep 0.0001; done; echo; done;

# Alternatives
# 3d_diagonal, Big_Money-ne, Chiseled, cosmike, doubleshorts, Elite, doubleshorts, fraktur, Georgia11, ghost, henry3d, lildevil, larry3d, lineblocks
# columns, ian_jones, twisted

# Remove VNC settings
# sudo rm -rf ~/.vnc/passwd ~/.vnc/xstartup
# sudo rm -rf /tmp/.X*-lock /tmp/.X11-unix/X*
# sudo kill -9 $(ps aux | grep '[X]tightvnc' | awk '{print $2}')

# Xfconf reference
# for channel in $( xfconf-query --list | tail --lines=+2 | sort ); do printf -- '\n\e[1;36m%s\e[m\n' "${channel}"; xfconf-query --list --verbose --channel "${channel}"; done

# Color reference
# for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
