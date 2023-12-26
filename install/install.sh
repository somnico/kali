#!/usr/bin/zsh

# Update package information
sudo apt update

# Set the debconf frontend to noninteractive
echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

# Configure default keyboard layout 
echo "keyboard-configuration keyboard-configuration/layoutcode string no" | sudo debconf-set-selections
echo "keyboard-configuration keyboard-configuration/variantcode string winkeys" | sudo debconf-set-selections

# Set default values for Wireshark pop up
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections

# Install Kali
sudo apt install -y kali-desktop-xfce xfconf kali-defaults kali-tools-top10

# Install VNC server and expect tool
sudo apt install -y tightvncserver expect

touch ~/.Xauthority

# Start VNC server
expect -c "
spawn tightvncserver -geometry 1280x720
expect {
  \"Password:\" { send \"kalikali\r\"; exp_continue }
  \"Verify:\" { send \"kalikali\r\"; exp_continue }
  \"Would you like to enter a view-only password (y/n)?\" { send \"n\r\" }
}
expect eof
"
sleep 5

echo -e "kalikali\nkalikali" | sudo passwd kali

# Reset 
unset DEBIAN_FRONTEND


# Install wallpapers
sudo apt install -y kali-wallpapers-all

# Change wallpaper 
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image --create -t string -s /usr/share/backgrounds/kali-16x9/kali-layers.png
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s /usr/share/backgrounds/kali-16x9/kali-layers.png

xfconf-query --create --channel thunar --property /last-show-hidden --type bool --set true

# Change terminal settings 
mkdir -p /home/kali/.config/qterminal.org/
touch /home/kali/.config/qterminal.org/qterminal.ini

sudo chmod a+w /usr/share/qtermwidget5/color-schemes/
sudo curl -o /usr/share/qtermwidget5/color-schemes/Palenight.colorscheme https://raw.githubusercontent.com/somnico/kali/master/config/palenight.colorscheme
sudo sed -i 's/\(colorScheme=\).*/\1Palenight/' /home/kali/.config/qterminal.org/qterminal.ini

sudo sed -i 's/\(guiStyle=\).*/\1qt5ct-style/' /home/kali/.config/qterminal.org/qterminal.ini

# Install Powerline fonts
sudo apt-get install -y fonts-powerline

# Install fonts
git clone --depth=1 --branch=master https://github.com/ryanoasis/nerd-fonts.git nerd-fonts
sudo cp -r nerd-fonts/patched-fonts/Meslo /usr/share/fonts/truetype/meslo
./nerd-fonts/install.sh Meslo

# Change font
sudo sed -i 's/\(fontFamily=\).*/\1MesloLGS Nerd Font Mono/' /home/kali/.config/qterminal.org/qterminal.ini
sudo curl -o ~/.config/qt5ct/qt5ct.conf https://raw.githubusercontent.com/somnico/kali/master/config/qt5ct.conf

xfconf-query -c xsettings -p /Gtk/FontName -s "MesloLGS Nerd Font Mono 10"
xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "MesloLGS Nerd Font Mono 10"


# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Powerlevel10k 
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Set theme to powerlevel10k
sudo sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Customization
sudo sed -i '/^# alias ohmyzsh="mate ~\/.oh-my-zsh"/a\
alias rc="sudo nano ~/.zshrc"\
alias p1="sudo nano ~/.p10k.zsh"\
alias re="omz reload"
' ~/.zshrc

sudo sed -i 's+plugins=(git)+plugins=(\
  git\
  sudo\
  zsh-autosuggestions\
  zsh-syntax-highlighting\
  history\
  #dirhistory\
)+
' ~/.zshrc

sudo sed -i '/source $ZSH\/oh-my-zsh.sh/i\
preexec() {\
  echo\
}\
' ~/.zshrc

echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc

# curl https://gist.githubusercontent.com/somnico/a553105e88bd2f9f4be33860b7ce17b0/raw/ff645645a11a201ac25bef0f8f0fc3539c7fcd87/.zshrc > ~/.zshrc
source ~/.zshrc

# Install dconf-cli
sudo apt install -y dconf-cli

# Powerlevel configuration
curl https://gist.githubusercontent.com/somnico/b71f23f21f931d6d9c2445719c571ab5/raw/d9ca084732b2b9b8ecffff6e81091133dc19ce18/.p10k.zsh > ~/.p10k.zsh
source ~/.p10k.zsh

exec zsh


# Install helpers
sudo apt install -y nodejs npm
sudo npm install -g tldr
sudo apt install -y fzf

# Install a lot of random stuff
sudo apt install -y fortune cowsay lolcat figlet boxes cmatrix sl libaa-bin pv jp2a neofetch oneko
git clone https://github.com/hIMEI29A/FigletFonts.git
cd FigletFonts
make
cd ..

sudo apt install -y libncursesw5-dev
git clone https://gitlab.com/jallbrit/cbonsai
cd cbonsai
sudo make install
cd ..
