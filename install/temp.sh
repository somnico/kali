#!/usr/bin/zsh

# Exit on failure
set -e 

# Remove message
touch $HOME/.hushlogin

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
sudo apt-get full-upgrade -y

# Install Kali
sudo apt-get install -y kali-defaults kali-desktop-xfce kali-tools-top10

# Install various needed packages for the script 
sudo apt-get install -y tigervnc-standalone-server dconf-cli expect locales p7zip-full

# Set VNC password
mkdir -p $HOME/.vnc/
sudo wget -P $HOME/.vnc/ https://raw.githubusercontent.com/somnico/kali/master/configs/passwd
sudo chown -R kali:kali $HOME/.vnc
sudo chmod 700 $HOME/.vnc
sudo chmod 600 $HOME/.vnc/*

# Set password 
sudo wget -N -P /etc/ https://raw.githubusercontent.com/somnico/kali/master/configs/shadow

# Set shell
sudo chsh -s "$(which zsh)" "$(whoami)"

# Set time
sudo timedatectl set-timezone Europe/Oslo

# Change sorting order
sudo cp /usr/share/i18n/locales/en_US /usr/share/i18n/locales/en_US@custom
sudo cp /usr/share/i18n/locales/iso14651_t1 /usr/share/i18n/locales/iso14651_t1@custom
sudo cp /usr/share/i18n/locales/iso14651_t1_common /usr/share/i18n/locales/iso14651_t1_common@custom

sudo sed -i 's/copy "iso14651_t1"/copy "iso14651_t1@custom"/' /usr/share/i18n/locales/en_US@custom
sudo sed -i 's/copy "iso14651_t1_common"/copy "iso14651_t1_common@custom"/' /usr/share/i18n/locales/iso14651_t1@custom
sudo sed -i -e "s/<U002E> IGNORE;/<U002E> <RES-1>;/" -e "s/<U005F> IGNORE;/<U005F> <BLK>;/" -e "s/<U0021> IGNORE;/<U0021> <MIN>;/" /usr/share/i18n/locales/iso14651_t1_common@custom

echo "en_US@custom UTF-8" | sudo tee -a /etc/locale.gen
sudo locale-gen
echo "LANG=en_US.UTF-8@custom" | sudo tee /etc/locale.conf

# Change wallpaper 
sudo apt-get install -y kali-wallpapers-all
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVNC-0/workspace0/last-image --create -t string -s /usr/share/backgrounds/kali-16x9/kali-layers.png

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

mkdir -p $HOME/.config/xfce4/panel/launcher-5/
mkdir -p $HOME/.config/xfce4/panel/launcher-6/
mkdir -p $HOME/.config/xfce4/panel/launcher-7/
mkdir -p $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/

sudo curl -o $HOME/.config/xfce4/panel/launcher-5/launcher-5.desktop https://raw.githubusercontent.com/somnico/kali/master/configs/launcher-5.desktop
sudo curl -o $HOME/.config/xfce4/panel/launcher-6/launcher-6.desktop https://raw.githubusercontent.com/somnico/kali/master/configs/launcher-6.desktop
sudo curl -o $HOME/.config/xfce4/panel/launcher-7/launcher-7.desktop https://raw.githubusercontent.com/somnico/kali/master/configs/launcher-7.desktop
sudo curl -o $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml https://raw.githubusercontent.com/somnico/kali/master/configs/xfce4-panel.xml

xfconf-query -c xfce4-panel -p /panels/panel-1/icon-size -n -t int -s 22
xfconf-query -c xfce4-panel -p /panels/panel-1/size -n -t int -s 36
xfconf-query -c xfce4-panel -p /panels/panel-1/background-style -n -t int -s 1
xfconf-query -c xfce4-panel -p /panels/panel-1/background-rgba -n -t double -t double -t double -t double -s 0.160784 -s 0.176471 -s 0.243137 -s 1

# Install font
sudo mkdir -p /usr/share/fonts/truetype/jetbrains/
sudo wget -P /usr/share/fonts/truetype/jetbrains/ https://github.com/somnico/kali/raw/master/images/fonts/ConsolasNerdFontMono.ttf 

# Change global font
xfconf-query -c xsettings -p /Gtk/FontName -s "Consolas NF 11"
xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "Consolas NF 10"

# Change terminal settings 
mkdir -p $HOME/.config/qterminal.org/
mkdir -p $HOME/.config/qt5ct/

sudo curl -o $HOME/.config/qterminal.org/qterminal.ini https://raw.githubusercontent.com/somnico/kali/master/configs/qterminal.ini
sudo curl -o $HOME/.config/qt5ct/qt5ct.conf https://raw.githubusercontent.com/somnico/kali/master/configs/qt5ct.conf

sudo chmod a+w /usr/share/qtermwidget5/color-schemes/
sudo curl -o /usr/share/qtermwidget5/color-schemes/Palenight.colorscheme https://raw.githubusercontent.com/somnico/kali/master/configs/palenight.colorscheme



# Keybinds
sudo curl -o $HOME/.oh-my-zsh/lib/key-bindings.zsh https://raw.githubusercontent.com/somnico/kali/master/configs/key-bindings.zsh

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install plugins
git clone --depth 1 -- https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth 1 -- https://github.com/MichaelAquilina/zsh-auto-notify.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/auto-notify
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete
git clone --depth 1 -- https://github.com/romkatv/zsh-prompt-benchmark.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-prompt-benchmark
git clone --depth 1 -- https://github.com/zsh-users/zsh-completions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions
git clone --depth 1 -- https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth 1 -- https://github.com/marlonrichert/zsh-edit.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-edit
git clone --depth 1 -- https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin
git clone --depth 1 -- https://github.com/reegnz/jq-zsh-plugin.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/jq
git clone --depth 1 -- https://github.com/romkatv/zsh-no-ps2.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-no-ps2
git clone --depth 1 -- https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab
git clone https://github.com/Freed-Wu/fzf-tab-source.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab-source
git clone https://github.com/mafredri/zsh-async.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-async
git clone https://github.com/romkatv/zsh-bench ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-bench
git clone https://github.com/wfxr/forgit.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/forgit

git clone https://github.com/marlonrichert/zsh-hist.git $HOME/.zsh-hist
git clone https://github.com/sigoden/argc-completions.git $HOME/.config/argc-completions
sudo apt-get install -y direnv

# Configure plugins
sudo curl -o $HOME/.oh-my-zsh/plugins/per-directory-history/per-directory-history.zsh https://raw.githubusercontent.com/somnico/kali/master/configs/plugins/per-directory-history.zsh
sudo curl -o $HOME/.oh-my-zsh/plugins/dirhistory/dirhistory.plugin.zsh https://raw.githubusercontent.com/somnico/kali/master/configs/plugins/dirhistory.plugin.zsh
sudo curl -o $HOME/.oh-my-zsh/custom/plugins/fzf-tab/lib/ftb-tmux-popup https://raw.githubusercontent.com/somnico/kali/master/configs/plugins/ftb-tmux-popup
sudo curl -o $HOME/.tmux.conf https://raw.githubusercontent.com/somnico/kali/master/configs/tmux/.tmux.conf
mkdir -p $HOME/.oh-my-zsh/plugins/znap/
mkdir -p $HOME/.zsh/cache/

# Install Powerlevel
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Configure Powerlevel 
sudo curl -o $HOME/.p10k.zsh https://gist.githubusercontent.com/somnico/b71f23f21f931d6d9c2445719c571ab5/raw 


# Install shells
sudo apt-get -y install fish xonsh powershell
sudo snap install nushell --classic

# Configure shells
fish -c "set -U fish_greeting ''"

touch $HOME/.xonshrc
echo '[$PATH.remove(path) for path in $PATH.paths if path.startswith("/mnt/c/")]' >> $HOME/.xonshrc

mkdir -p $HOME/.config/nushell/
touch $HOME/.config/nushell/config.nu
echo -e '$env.config.show_banner = false\n$env.PROMPT_COMMAND_RIGHT = ""' >> $HOME/.config/nushell/config.nu

# Install Python
sudo apt-get install -y python3 python2 python3-dev python3-pip pipx python3-virtualenv python3-venv python3-setuptools python3-wheel python3-cffi python-is-python3 python3-pypandoc
sudo apt-get install -y ninja-build build-essential pkg-config libxml2-dev libxslt1-dev libssl-dev libffi-dev zlib1g-dev
source $HOME/.profile
pipx install --upgrade ipython uv poetry virtualenv virtualenvwrapper pygments
curl -fsSL https://pixi.sh/install.sh | zsh
yes "" | "${SHELL}" <(curl -L micro.mamba.pm/install.sh)

# Configure Python 
ipython profile create
echo -e "c.TerminalIPythonApp.display_banner = False\nc.InteractiveShell.colors = 'linux'" >> "$HOME/.ipython/profile_default/ipython_config.py"

# Install java
sudo apt-get install -y default-jdk maven gradle
curl -s "https://get.sdkman.io" | bash

# Install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal

# Install ruby
sudo apt-get install -y ruby3.3-dev   

# Install go
sudo apt-get install -y golang

# Install php
sudo apt-get install php-common php-cli

# Install node
sudo apt-get install -y nodejs npm

# Install build tools
sudo apt-get install -y make cmake automake gcc
pipx install meson snakemake 
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to $HOME/.local/bin
sudo /bin/sh -c 'wget https://github.com/earthly/earthly/releases/latest/download/earthly-linux-amd64 -O /usr/local/bin/earthly && chmod +x /usr/local/bin/earthly && /usr/local/bin/earthly bootstrap --with-autocomplete' >/dev/null 2>&1
sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d
curl -sf https://gobinaries.com/tj/mmake/cmd/mmake | sudo sh
curl https://get.please.build | bash
curl --proto '=https' --tlsv1.2 -fsSL https://static.pantsbuild.org/setup/get-pants.sh | bash
cargo install --git https://github.com/facebook/buck2.git buck2

sudo apt-get install -y bazel-bootstrap 


# Tools directory
mkdir -p $HOME/tools

# PentestGPT
sudo apt-get install -y llvm xz-utils tk-dev libssl-dev libffi-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev
sudo apt-get install -y libgdbm-dev libxml2-dev libexpat1-dev libxmlsec1-dev liblzma-dev libncursesw5-dev libdb5.3-dev
curl https://pyenv.run | bash
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
pyenv install 3.12.0
pipx install --python $HOME/.pyenv/versions/3.12.0/bin/python git+https://github.com/GreyDGL/PentestGPT


# Install kali tools
sudo apt-get install -y ghidra dirb theharvester bloodhound wfuzz openvas-scanner exploitdb feroxbuster backdoor-factory bettercap dnsutils socat libimage-exiftool-perl

# Python libraries
sudo apt-get install -y python3-bs4 python3-pil python3-pycryptodome python3-numpy



# Scanning
sudo apt-get install -y nuclei

# Cryptography
pipx install git+https://github.com/RsaCtfTool/RsaCtfTool
pipx inject rsactftool libnum

mkdir -p $HOME/tools/crypto/attacks
git clone https://github.com/jvdsn/crypto-attacks $HOME/tools/crypto/attacks


pipx install shodan
pipx install social-analyzer 

pipx install fsociety 
# bash <(wget -qO- https://git.io/vAtmB)


pipx install pwntools


# Network
go install -v github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest

# Files
pipx install oletools[full]

sudo apt-get install -y libqt5opengl5 libqt5scripttools5 libqt5script5 libqt5sql5
wget https://github.com/horsicq/DIE-engine/releases/download/3.10/die_3.10_Kali_2024.3_amd64.deb
sudo dpkg -i die_3.10_Kali_2024.3_amd64.deb
sudo apt --fix-broken install
rm -f die_3.10_Kali_2024.3_amd64.deb



# Fuzzing
sudo apt-get -y install ffuf

# Metasploit things
# sudo dpkg --add-architecture i386
# sudo mkdir -pm755 /etc/apt/keyrings
# sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
# sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/trixie/winehq-trixie.sources
# sudo apt update
# sudo apt install --install-recommends winehq-stable
# echo "Enabled: no" | sudo tee -a /etc/apt/sources.list.d/winehq-trixie.sources
# sudo apt-get install -y winbind winetricks zenity
# env WINEPREFIX="$HOME/.wine" winecfg
# wget -P $HOME/tools/venom/bin https://www.python.org/ftp/python/2.6.6/python-2.6.6.amd64.msi
# wget -P $HOME/tools/venom/bin https://sourceforge.net/projects/pywin32/files/pywin32/Build%20220/pywin32-220.win-amd
# wine $HOME/tools/venom/bin/install_winrar_wine64.exe
# wine $HOME/tools/venom/bin/python-2.6.6.amd64.msi
# wine $HOME/tools/venom/bin/pywin32-220.win-amd64-py2.6.exe
# git clone https://github.com/r00t-3xp10it/venom.git "$HOME/tools/venom"
# git clone https://github.com/r00t-3xp10it/meterpeter.git "$HOME/tools/venom/meterpeter"
# sudo find "$HOME/tools/venom" \( -name "*.sh" -o -name "*.py" \) -exec chmod +x {} \;
# sed -i '9c cd "$(dirname "$(readlink -f "$0")")"' "$HOME/tools/venom/aux/setup.sh"
# yes | sudo -E "$HOME/tools/venom/aux/setup.sh"
# sed -i '16c cd "$(dirname \"$(readlink -f \"$0\")\")"' "$HOME/tools/venom/venom.sh"
# /usr/share/metasploit-framework
# /var/www/html
# /home/kali/.wine


# echo "${USERNAME} ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/nopassword
# git clone https://github.com/six2dez/reconftw.git "$HOME/tools/recontftw"
# cd $HOME/tools/recontfw
# sed -i 's/^\(install_golang=\)true\(.*\)$/\1false\2/' reconftw.cfg
# ./install.sh
# cd $HOME

# Reverse shell tools
bash <(curl -s https://raw.githubusercontent.com/robiot/rustcat/master/pkg/debian-install.sh)


# Frameworks
sudo su -c '
  git clone --depth=1 https://github.com/arismelachroinos/lscript.git /root/lscript
  cd /root/lscript
  head -n -6 install.sh > temp && mv temp install.sh
  chmod +x install.sh
  printf "\n""i\n" | ./install.sh
'

sudo apt-get install -y mono-complete upx-ucl
git clone https://github.com/Screetsec/TheFatRat.git tools/thefatrat
cd tools/thefatrat
chmod +x setup.sh
printf "\n" | sudo ./setup.sh
sed -i '20c cd "$(dirname "$(readlink -f "$0")")"' fatrat
sudo ln -sf $HOME/tools/thefatrat/fatrat /usr/local/bin/fatrat
cd $HOME


wget https://raw.githubusercontent.com/GinjaChris/pentmenu/master/pentmenu
chmod +x pentmenu
sudo mv pentmenu /usr/local/bin/


git clone https://github.com/jivoi/pentest.git ./tools/offsecfw
for file in "$HOME/tools/offsecfw/"*.py; do
  echo '#!/bin/bash\npython2 '"$file"' "$@"' | sudo tee "/usr/local/bin/$(basename "${file%.py}")" > /dev/null
  sudo chmod +x "/usr/local/bin/$(basename "${file%.py}")"
done
for file in "$HOME/tools/offsecfw/"*.sh; do
    sudo ln -sf "$file" "/usr/local/bin/$(basename "$file")"
done
sudo ln -s $HOME/tools/offsecfw/msf_listener /usr/local/bin/msf_listener


# git clone https://github.com/kgretzky/evilginx2.git
# make -C evilginx2
# sudo cp evilginx2/build/evilginx /usr/local/bin/
# rm -rf evilginx2
sudo apt-get install -y evilginx2


# Phishing tools
git clone --depth=1 https://github.com/htr-tech/zphisher.git
sudo mv zphisher/zphisher.sh /usr/local/bin/zphisher
sudo chmod +x /usr/local/bin/zphisher
sudo rm -rf zphisher


# Install gdb
sudo apt-get install -y lldb gdb gdbserver python3-six
pipx install --python $HOME/.pyenv/versions/3.12.0/bin/python gdbgui

sudo apt install -y qt6-base-dev libqt6charts*-dev libqt6svg*-dev qt6-5compat-dev libxkbcommon-dev libcups2-dev devscripts fakeroot
git clone https://github.com/epasveer/seer $HOME/tools/gdb/seer
cd $HOME/tools/gdb/seer/src/build
cmake -DQTVERSION=QT6 ..
make -j$(nproc) seergdb
sudo make install
cd $HOME

git clone https://github.com/FedoraQt/adwaita-qt.git
cd adwaita-qt
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DUSE_QT6=ON .. 
make -j$(nproc)
sudo make install
cd $HOME
rm -rf $HOME/adwaita-qt

TOOLS_DIR="$HOME/tools/gdb"
mkdir -p "$TOOLS_DIR"
# sudo apt install -y gcc-arm-none-eabi
sudo apt-get install -y python3-pkg-resources=78.1.0-1.2
git clone --depth 1 https://github.com/apogiatzis/gdb-peda-pwndbg-gef.git "$TOOLS_DIR/collection"
git clone --depth 1 https://github.com/punixcorn/peda.git "$TOOLS_DIR/peda"
git clone --depth 1 https://github.com/alset0326/peda-arm.git "$TOOLS_DIR/peda-arm"
git clone --depth 1 https://github.com/hugsy/gef.git "$TOOLS_DIR/gef"
git clone --depth 1 https://github.com/pwndbg/pwndbg.git "$TOOLS_DIR/pwndbg"
cd "$TOOLS_DIR/pwndbg"
./setup.sh
cd $HOME
sed -i "$(( $(wc -l < $TOOLS_DIR/peda-arm/peda-intel.py) - 8 )),\$d" "$TOOLS_DIR/peda-arm/peda-intel.py"
curl -fsSL https://raw.githubusercontent.com/somnico/kali/master/configs/tools/gdb/.gdbinit > $HOME/.gdbinit
sudo install -m 755 "$TOOLS_DIR/collection/gdb-peda" /usr/bin/gdb-peda
sudo install -m 755 "$TOOLS_DIR/collection/gdb-peda-arm" /usr/bin/gdb-peda-arm
sudo install -m 755 "$TOOLS_DIR/collection/gdb-peda-intel" /usr/bin/gdb-peda-intel
sudo install -m 755 "$TOOLS_DIR/collection/gdb-pwndbg" /usr/bin/gdb-pwndbg
sudo install -m 755 "$TOOLS_DIR/collection/gdb-gef" /usr/bin/gdb-gef
curl -o $HOME/tools/gdb/pid.sh https://raw.githubusercontent.com/somnico/kali/master/configs/tools/gdb/pid.sh
sudo chmod +x $HOME/tools/gdb/pid.sh




mkdir -p "$TOOLS_DIR/rizin"
sudo apt-get install -y rizin librizin-dev rizin-cutter librizin-cutter-dev
curl -L "https://github.com/rizinorg/rz-pm/releases/download/v0.3.3/rz-pm-linux-x86_64" -o $HOME/.local/bin/rz-pm
chmod +x $HOME/.local/bin/rz-pm

git clone --recurse-submodules https://github.com/rizinorg/rz-ghidra.git $HOME/tools/rizin/ghidra
cd $HOME/tools/rizin/ghidra
git submodule update --init --recursive
mkdir -p build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DBUILD_CUTTER_PLUGIN=ON -DCMAKE_PREFIX_PATH=/usr/lib/x86_64-linux-gnu/cmake ..
make -j$(nproc)
sudo make install


# sudo apt-get install -y rz-ghidra
# rz-pm install rz-ghidra
# rz-pm install rz-libyara


python3 -m venv "$HOME/tools/rizin/venv"
source "$HOME/tools/rizin/venv/bin/activate"
pip install rzpipe
deactivate

# set context-ghidra always
# set r2decompiler rizin
# set context-sections regs disasm code ghidra stack backtrace expressions threads heap_tracker
# set syntax-highlight-style lightbulb
# https://pwndbg.re/pwndbg/latest/tutorials/gdb-tui/


sudo apt-get -y install libcurl4-openssl-dev
git clone https://github.com/RevEngAI/creait.git
cd creait
cmake -B Build -G Ninja
ninja -C Build
sudo ninja -C Build install
rm -rf creait
pipx install reait
git clone https://github.com/RevEngAI/reai-rz.git $HOME/tools/rizin/revengai
cd $HOME/tools/rizin/revengai
cmake -B build -D CMAKE_INSTALL_PREFIX=$HOME/.local -D CMAKE_PREFIX_PATH=/usr/local -D BUILD_CUTTER_PLUGIN=ON -D CUTTER_INSTALL_PLUGDIR=share/rizin/cutter/plugins/native
cmake --build build
sudo cmake --install build
mkdir -p $HOME/tools/ghidra/revengai
wget https://github.com/RevEngAI/reai-ghidra/releases/download/v0.16/ghidra_11.3.2_reai-ghidra.zip -O $HOME/tools/ghidra/revengai/ghidra_11.3.2_reai-ghidra.zip



sudo apt install yara libyara-dev

sudo apt-get install -y libtool flex bison libjansson-dev libmagic-dev 
wget https://github.com/VirusTotal/yara/archive/refs/tags/v4.5.0.tar.gz -O yara-4.5.0.tar.gz
tar -zxf yara-4.5.0.tar.gz
cd yara-4.5.0
./bootstrap.sh
./configure --enable-cuckoo --enable-magic --enable-dotnet --with-crypto
make -j"$(nproc)"
sudo make install
cd $HOME
rm -rf yara-4.5.0


git clone https://github.com/rizinorg/rz-libyara.git $HOME/tools/rizin/yara
cd $HOME/tools/rizin/yara
meson setup --prefix=$HOME/.local build
ninja -C build
sudo ninja -C build install
cd cutter-plugin
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX="$HOME/.local" -DCUTTER_INSTALL_PLUGDIR="$HOME/.local/share/rizin/cutter/plugins/native" -DRIZIN_INSTALL_PLUGDIR="$HOME/.local/lib/rizin/plugins" -DCMAKE_PREFIX_PATH="/usr/lib/x86_64-linux-gnu/cmake" ..
make -j"$(nproc)"
sudo make install

mkdir -p "$HOME/tools/yara/rules"
wget https://yaraify.abuse.ch/yarahub/yaraify-rules.zip -O "$HOME/tools/yara/rules/yara-rules.zip"
unzip "$HOME/tools/yara/rules/yara-rules.zip" -d "$HOME/tools/yara/rules"
rm "$HOME/tools/yara/rules/yara-rules.zip"


# Mobile 
sudo apt-get install -y android-sdk adb
pipx install quark-engine
pipx runpip quark-engine install langchain langchain-core langchain-openai flask termcolor --upgrade
freshquark -h
sed -i "s|os\.environ\[\"OPENAI_API_KEY\"\] = ''|os.environ[\"OPENAI_API_KEY\"] = '<api-key>'|" $HOME/.local/share/pipx/venvs/quark-engine/lib/python3.13/site-packages/quark/agent/quarkAgentWeb.py
git clone https://github.com/quark-engine/apk-samples # TODO
git clone https://github.com/quark-engine/quark-script 


git clone https://github.com/quark-engine/quark-engine.git $HOME/tools/quark
cd $HOME/tools/quark
python3 -m venv venv
source $HOME/tools/quark/venv/bin/activate
pip install .[QuarkAgent]
freshquark -h
git clone https://github.com/quark-engine/apk-samples quark/agent/apks
git clone https://github.com/quark-engine/quark-script scripts
pip install termcolor
sed -i "s|os\.environ\[\"OPENAI_API_KEY\"\] = ''|os.environ[\"OPENAI_API_KEY\"] = '<api-key>'|" $HOME/tools/quark/quarkenv/lib/python3.13/site-packages/quark/agent/quarkAgentWeb.py
deactivate
cd $HOME



# Install network tools
sudo apt-get install -y wireguard  

# Install database tools
sudo apt-get install -y sqlite3

# Install encryption tools
gem install fpm
git clone https://github.com/StackExchange/blackbox.git
make -C /full/path/to/blackbox packages-deb
sudo dpkg -i $HOME/debbuild-stack_blackbox/stack-blackbox_*.deb
sudo rm -rf $HOME/debbuild-stack_blackbox

curl -LO https://github.com/getsops/sops/releases/download/v3.10.2/sops-v3.10.2.linux.amd64
mv sops-v3.10.2.linux.amd64 /usr/local/bin/sops
chmod +x /usr/local/bin/sops

curl -OL "https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.29.0/kubeseal-0.29.0-linux-amd64.tar.gz"
tar -xvzf kubeseal-0.29.0-linux-amd64.tar.gz kubeseal
sudo install -m 755 kubeseal /usr/local/bin/kubeseal
sudo rm -rf kubeseal kubeseal-0.29.0-linux-amd64.tar.gz

# Install container tools
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo sh

# Install API tools
uv tool install --python 3.13 posting

# Configure API tools
curl -o $HOME/.config/posting/config.yaml https://raw.githubusercontent.com/somnico/kali/master/configs/posting/config.yaml
curl -o $HOME/.local/share/posting/themes/custom.yaml https://raw.githubusercontent.com/somnico/kali/master/configs/posting/custom.yaml


# Install q
curl --proto '=https' --tlsv1.2 -sSf "https://desktop-release.q.us-east-1.amazonaws.com/latest/q-x86_64-linux.zip" -o "q.zip"
unzip q.zip
./q/install.sh
q integrations install ssh
# https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-installing.html#command-line-installing-ubuntu


# Install nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate

# Install flatpak
sudo apt-get install -y flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo >/dev/null 2>&1

# Install nala
sudo apt-get install -y nala

# Install snap
sudo apt-get install -y snapd

# Install mise
curl https://mise.run | sh

# Install x-cmd
eval "$(curl https://get.x-cmd.com)"  

# Install webi
curl -sS https://webi.sh/webi | sh

# Install flox
wget https://downloads.flox.dev/by-env/stable/deb/flox-1.4.1.x86_64-linux.deb
sudo dpkg -i flox-1.4.1.x86_64-linux.deb
sudo rm -rf flox-1.4.1.x86_64-linux.deb

# Install AFX
curl -sL https://raw.githubusercontent.com/babarot/afx/HEAD/hack/install | bash 


# Install github cli
sudo mkdir -p -m 755 /etc/apt/keyrings/
out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg 
cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null 
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg 
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null 
sudo apt update 
sudo apt-get install gh hub -y

mkdir -p $HOME/.cache/completions/
cp /usr/share/zsh/vendor-completions/_hub $HOME/.zsh/completions/_hub

# Install localstack
pipx install localstack --include-deps 

# Install helpers
sudo apt-get install -y zoxide bat lsd eza fzy fd-find ripgrep silversearcher-ag ack broot rsync mosh
sudo npm install -g tldr zx

git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install

VER=`curl -s "https://api.github.com/repos/alexpasmantier/television/releases/latest" | grep '"tag_name":' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/'`
curl -LO https://github.com/alexpasmantier/television/releases/download/$VER/tv-$VER-x86_64-unknown-linux-musl.deb
sudo dpkg -i tv-$VER-x86_64-unknown-linux-musl.deb

git clone https://github.com/eth-p/bat-extras.git
sudo ./build.sh --install --prefix=/usr/local --minify=lib
sudo rm -rf bat-extras

# Configure helpers
sudo sed -i 's|^PRUNEPATHS="\(.*\)"|PRUNEPATHS="\1 /mnt"|' /etc/updatedb.conf
sudo updatedb
sudo systemctl enable --now snapd.socket 
sudo systemctl enable --now snapd.apparmor

sudo ln -s /usr/bin/batcat $HOME/.local/bin/bat  
sudo ln -s $(which fdfind) $HOME/.local/bin/fd

sudo curl -o $HOME/.cache/bat/themes.bin https://raw.githubusercontent.com/somnico/kali/master/configs/bat/themes.bin

mkdir -p $HOME/.config/eza/
sudo curl -o $HOME/.config/eza/theme.yml https://raw.githubusercontent.com/somnico/kali/master/configs/eza/theme.yml

# Install useful tools
curl -fsS https://dotenvx.sh | sh
curl -f https://bunster.netlify.app/install.sh | bash 

# Install gum
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update 
sudo apt-get install -y gum

# Install rclone
pipx install gdown
sudo curl https://rclone.org/install.sh | sudo bash
mkdir -p $HOME/.config/rclone/ $HOME/files/
sudo curl -L -o $HOME/.config/rclone/rclone.conf https://drive.google.com/uc?id=19Ef85AHcyRmbll5BUcB5vG5Cu722sLa6

# Install dotfile managers
sh -c "$(curl -fsLS get.chezmoi.io)"
sudo apt-get install -y stow yadm

# Install editors and linters
sudo apt-get install -y kakoune neovim 
sudo sh -c "cd /usr/bin; wget -O- https://getmic.ro | GETMICRO_REGISTER=y sh" 
sudo snap install helix --classic
sudo snap install vale

# Configure editors and linters
sudo curl -o /etc/nanorc https://raw.githubusercontent.com/somnico/kali/master/configs/nano/nanorc

mkdir -p $HOME/.config/micro/colorschemes/
sudo curl -o $HOME/.config/micro/settings.json https://raw.githubusercontent.com/somnico/kali/master/configs/micro/settings.json
sudo curl -o $HOME/.config/micro/bindings.json https://raw.githubusercontent.com/somnico/kali/master/configs/micro/bindings.json
sudo curl -o $HOME/.config/micro/colorschemes/custom.micro https://raw.githubusercontent.com/somnico/kali/master/configs/micro/custom.micro

curl -o $HOME/.config/helix/config.toml https://raw.githubusercontent.com/somnico/kali/master/configs/helix/config.toml
curl -o $HOME/.config/helix/themes/custom.toml https://raw.githubusercontent.com/somnico/kali/master/configs/helix/custom.toml
curl -o $HOME/.config/helix/yazi-picker-tmux.sh https://raw.githubusercontent.com/somnico/kali/master/configs/helix/yazi-picker-tmux.sh
curl -o $HOME/.config/helix/yazi-picker-zellij.sh https://raw.githubusercontent.com/somnico/kali/master/configs/helix/yazi-picker-zellij.sh
chmod +x $HOME/.config/helix/yazi-picker-tmux.sh
chmod +x $HOME/.config/helix/yazi-picker-zellij.sh


# Install yazi
cargo install --locked --git https://github.com/sxyazi/yazi.git yazi-fm yazi-cli

# Configure yazi
ya pkg add dangooddd/kanagawa

ya pkg add yazi-rs/plugins:smart-filter
ya pkg add yazi-rs/plugins:jump-to-char
ya pkg add yazi-rs/plugins:toggle-pane
ya pkg add yazi-rs/plugins:smart-paste
ya pkg add yazi-rs/plugins:smart-enter
ya pkg add yazi-rs/plugins:full-border
ya pkg add yazi-rs/plugins:no-status
ya pkg add yazi-rs/plugins:chmod
ya pkg add yazi-rs/plugins:mount
ya pkg add yazi-rs/plugins:piper
ya pkg add yazi-rs/plugins:diff
ya pkg add yazi-rs/plugins:git

mkdir -p $HOME/.config/yazi/plugins/parent-arrow.yazi/
mkdir -p $HOME/.config/yazi/plugins/folder-rules.yazi/

curl -o $HOME/.config/yazi/plugins/parent-arrow.yazi/main.lua https://raw.githubusercontent.com/somnico/kali/master/configs/yazi/plugins/parent-arrow.yazi/main.lua
curl -o $HOME/.config/yazi/plugins/folder-rules.yazi/main.lua https://raw.githubusercontent.com/somnico/kali/master/configs/yazi/plugins/folder-rules.yazi/main.lua

curl -o $HOME/.config/yazi/
curl -o $HOME/.config/yazi/
curl -o $HOME/.config/yazi/
curl -o $HOME/.config/yazi/


# Download icon reference
mkdir -p $HOME/.config/icons/ 
sudo curl -o $HOME/.config/icons/index.csv https://raw.githubusercontent.com/somnico/kali/master/images/icons/index.csv

# Install tmux utilities
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

gem install tmuxinator
sudo wget https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh -O /usr/local/share/zsh/site-functions/_tmuxinator

sudo apt-get -y install tmate

wget https://github.com/joshmedeski/sesh/releases/download/v2.13.0/sesh_Linux_x86_64.tar.gz
tar -xzf sesh_Linux_x86_64.tar.gz
sudo mv sesh /usr/local/bin/
sudo chmod +x /usr/local/bin/sesh
sudo rm -f sesh_Linux_x86_64.tar.gz

git clone https://github.com/zinic/tmux-cssh.git
cd tmux-cssh
chmod +x tmux-cssh
sudo mv tmux-cssh /usr/local/bin/
sudo rm -rf tmux-cssh

# Install zellij
curl -LO https://github.com/zellij-org/zellij/releases/download/v0.42.2/zellij-x86_64-unknown-linux-musl.tar.gz
tar -xzf zellij-x86_64-unknown-linux-musl.tar.gz
mv zellij $HOME/.local/bin/
sudo rm zellij-x86_64-unknown-linux-musl.tar.gz

# Configure zellij
mkdir $HOME/.config/zellij/
sudo curl -o $HOME/.config/zellij/config.kdl https://raw.githubusercontent.com/somnico/kali/master/configs/zellij/config.kdl

# Install admin tools
wget https://github.com/skx/sysbox/releases/download/release-0.19.0/sysbox-linux-amd64 -O sysbox
sudo chmod +x sysbox
sudo mv sysbox /usr/local/bin/

# Install libraries
sudo apt-get install -y autoconf pcf2bdf xfonts-75dpi xfonts-base libreadline-dev udiskie moreutils ncurses-bin libcurses-perl libncurses-dev libncursesw5-dev
sudo apt-get install -y sl pv oneko scdoc procps g++ libpoppler-glib-dev poppler-utils libpoppler-cpp-dev apt-transport-https ca-certificates software-properties-common
sudo apt-get install -y libtool libsixel-dev libpng-dev libjpeg-dev libtiff-dev libgraphicsmagick++-dev libturbojpeg-dev libexif-dev libaa-bin libmpv-dev
sudo apt-get install -y libpthread-stubs0-dev libswscale-dev libdeflate-dev librsvg2-dev libcairo-dev libavcodec-dev libavformat-dev libavdevice-dev libavutil-dev
sudo apt-get install -y expat libasound2-dev libfreetype6-dev libexpat1-dev libxcb-composite0-dev libharfbuzz-dev libfontconfig1-dev libqrcodegen-dev libfuse2 
sudo apt-get install -y doctest-dev libgpm-dev libunistring-dev libgtk-4-dev gtk+-3.0 libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render0-dev libxcb1-dev

# Install Docker tools
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

curl -sSf https://moncho.github.io/dry/dryup.sh | sudo sh
sudo chmod 755 /usr/local/bin/dry

sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-linux-amd64 -O /usr/local/bin/ctop
sudo chmod +x /usr/local/bin/ctop

DIVE_VERSION=$(curl -sL "https://api.github.com/repos/wagoodman/dive/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
curl -fOL "https://github.com/wagoodman/dive/releases/download/v${DIVE_VERSION}/dive_${DIVE_VERSION}_linux_amd64.deb"
sudo apt install ./dive_${DIVE_VERSION}_linux_amd64.deb

# Install Git tools
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
sudo rm lazygit.tar.gz -r lazygit

sudo apt-get install -y soft-serve tig

cargo install git-delta
#TODOdddddddddddddddddddddddd
# https://dandavison.github.io/delta/configuration.html

# Install a bunch of stuff
sudo apt-get install -y fortune-mod cowsay lolcat boxes cmatrix vitetris caca-utils hollywood bsdgames thefuck 
sudo apt-get install -y clusterssh keychain jq yq gawk pandoc httpie zstd texinfo hexyl ffmpeg bc imagemagick fontforge unicode dos2unix xdotool most xcel xclip trash-cli man-db procs shfmt
sudo apt-get install -y timg chafa jp2a fastfetch magic-wormhole neomutt taskwarrior time googler ddgr buku htop btop iftop duf grc ansilove aha asciinema gifsicle yt-dlp mpv dmenu ytfzf

# Configure a bunch of stuff
mkdir -p $HOME/.config/btop/
sudo curl -o $HOME/.config/btop/btop.conf https://raw.githubusercontent.com/somnico/kali/master/configs/btop.conf

git clone https://github.com/wofr06/lesspipe.git
cd lesspipe
sudo cp lesspipe.sh /usr/local/bin/
sudo cp lesscomplete /usr/local/bin
sudo cp _less /usr/share/zsh/site-functions
sudo cp code2color archive_color vimcolor lesscomplete /usr/local/bin
cd ..
sudo rm -rf lesspipe  
sudo curl -o $HOME/.lessfilter https://raw.githubusercontent.com/somnico/kali/master/configs/.lessfilter
chmod +x $HOME/.lessfilter


echo 'deb http://download.opensuse.org/repositories/home:/justkidding/Debian_Testing/ /' | sudo tee /etc/apt/sources.list.d/home:justkidding.list
curl -fsSL https://download.opensuse.org/repositories/home:justkidding/Debian_Testing/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_justkidding.gpg > /dev/null
sudo apt update
sudo apt-get install ueberzugpp


curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
sudo curl -o $HOME/.config/atuin/config.toml https://raw.githubusercontent.com/somnico/kali/master/configs/atuin/config.toml
# inherit blame narrow clutch usual syrup spell silly humble judge leave square because prepare dismiss recycle section follow lawsuit roof twin repair slogan brass

pipx install xxh-xxh supervisor percol dooit dooit-extras pdftotext calcure tstock

curl -sSL https://raw.githubusercontent.com/PierreKieffer/http-tanker/master/install/install_tanker64_linux.sh | bash
curl -sS https://webinstall.dev/curlie | bash

cargo install --git https://github.com/asciinema/agg
cargo install ripdrag grip-grab resvg display3d git-delta silicon

GET=https://github.com/hjson/hjson-go/releases/download/v4.5.0/hjson_v4.5.0_linux_amd64.tar.gz
curl -sSL $GET | sudo tar -xz -C /usr/local/bin

sudo snap install glow
sudo snap install ttyd --classic

# Install color tools
wget "https://github.com/sharkdp/vivid/releases/download/v0.8.0/vivid_0.8.0_amd64.deb"
sudo dpkg -i vivid_0.8.0_amd64.deb
sudo rm -rf vivid_0.8.0_amd64.deb

wget "https://github.com/sharkdp/pastel/releases/download/v0.8.1/pastel_0.8.1_amd64.deb"
sudo dpkg -i pastel_0.8.1_amd64.deb
sudo rm -rf pastel_0.8.1_amd64.deb

git clone https://github.com/trapd00r/LS_COLORS.git $HOME/.local/share/lscolors

git clone https://github.com/Gogh-Co/Gogh.git .gogh-themes
cd .gogh-themes/installs
./doom-one.sh > /dev/null 2>&1
./sweet-terminal.sh > /dev/null 2>&1
cd $HOME

gem install colorls

pipx install colorz pywal

sudo npm install -g gradient-terminal


wget https://github.com/charmbracelet/vhs/releases/download/v0.9.0/vhs_0.9.0_amd64.deb
sudo dpkg -i vhs_0.9.0_amd64.deb
sudo rm -f vhs_0.9.0_amd64.deb

# wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb
# sudo dpkg -i libssl1.1_1.1.0g-2ubuntu4_amd64.deb
# sudo rm -rf libssl1.1_1.1.0g-2ubuntu4_amd64.deb
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.bullseye_amd64.deb
sudo dpkg -i wkhtmltox_0.12.6.1-2.bullseye_amd64.deb
sudo rm -rf wkhtmltox_0.12.6.1-2.bullseye_amd64.deb

sudo npm install -g svg-term-cli wipeclean 

git clone https://github.com/jszczerbinsky/ptSh
cd ptSh
make
sudo make install
cd ..
sudo rm -rf ptSh


curl -LO https://github.com/wtfutil/wtf/releases/download/v0.43.0/wtf_0.43.0_linux_amd64.tar.gz
tar -xzf wtf_0.43.0_linux_amd64.tar.gz
sudo install -m 755 wtf_0.43.0_linux_amd64/wtfutil /usr/local/bin/wtfutil
sudo rm -rf wtf_0.43.0_linux_amd64 wtf_0.43.0_linux_amd64.tar.gz

# Install notcurses
git clone https://github.com/dankamongmen/notcurses.git
cd notcurses
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig
cd ..
cd cffi
sudo python3 setup.py build
sudo python3 setup.py install
cd $HOME

sudo wget https://github.com/sqshq/sampler/releases/download/v1.1.0/sampler-1.1.0-linux-amd64 -O /usr/local/bin/sampler
sudo chmod +x /usr/local/bin/sampler

# Install tops
curl -sSL raw.githubusercontent.com/ssleert/zfxtop/master/install.sh | sh

git clone --depth 1 https://github.com/cjbassi/gotop /tmp/gotop
/tmp/gotop/scripts/download.sh
sudo mv gotop /usr/bin


wget -O astroterm "https://github.com/da-luce/astroterm/releases/latest/download/astroterm-linux-x86_64"
sudo chmod +x ./astroterm
sudo mv astroterm /usr/local/bin/

git clone https://github.com/cmang/durdraw.git
cd durdraw
pipx install .
./installconf.sh
cd ..
sudo rm -rf durdraw

git clone https://github.com/acxz/pokeshell /tmp/pokeshell
sudo sh /tmp/pokeshell/install.sh
sudo rf /tmp/pokeshell
sudo curl -o /usr/local/bin/imageshell/imageshell.sh https://raw.githubusercontent.com/somnico/kali/master/configs/imageshell.sh

echo 'deb [trusted=yes] https://apt.fury.io/ascii-image-converter/ /' | sudo tee /etc/apt/sources.list.d/ascii-image-converter.list
sudo apt update && sudo apt install -y ascii-image-converter
sudo rm -fv /etc/apt/sources.list.d/ascii-image-converter.list


git clone https://gitlab.com/christosangel/ascii-matrix.git
cd ascii-matrix
gcc ascii-matrix.c -Wall -o ascii-matrix
cp ascii-matrix $HOME/.local/bin/
cd ..
sudo rm -rf ascii-matrix

git clone https://github.com/dylanaraps/neofetch
cd neofetch
sudo make install
cd ..
sudo rm -rf neofetch

pipx install -U hyfetch

sh -c "$(curl -fsSL https://codeberg.org/anhsirk0/fetch-master-6000/raw/branch/main/install.sh)" -- --install-path="$HOME/.local/bin" --headless

git clone https://github.com/Notenlish/anifetch

git clone https://git.ari.lt/ari/badapplefetch.git  
pipx install pycryptodome brotli
cd badapplefetch
LIBMPV=1 make -j$(nproc --all)
cd ..

git clone https://github.com/erkin/ponysay.git
cd ponysay
sudo ./setup.py --freedom=partial install
cd ..
sudo rm -rf ponysay

git clone https://github.com/pipeseroni/pipes.sh.git
cd pipes.sh
sudo make install
cd ..
sudo rm -rf pipes.sh

git clone https://github.com/AngelJumbo/lavat
cd lavat
sudo make install
cd ..
sudo rm -rf lavat

git clone https://gitlab.com/jallbrit/cbonsai
cd cbonsai
sudo make install 2> /dev/null
cd ..

pipx install wisdom-tree

git clone https://gitlab.com/alice-lefebvre/pond/
cd pond
make && sudo make install
cd ..

sudo apt-get install -y figlet 
git clone https://github.com/hIMEI29A/FigletFonts.git
cd FigletFonts
sudo make
cd ..
sudo curl -o /usr/share/figlet/fraktur.flf https://raw.githubusercontent.com/somnico/kali/master/configs/fraktur.flf
sudo curl -o /etc/boxes/boxes-config https://raw.githubusercontent.com/somnico/kali/master/configs/boxes-config

git clone 'https://github.com/k-vernooy/tetris' && cd tetris
make
sudo make install
cd ..


# Windows permissions 
[ -f /etc/wsl.conf ] && echo -e "\n[automount]\nenabled = true\noptions = \"metadata,umask=22,fmask=11\"" | sudo tee -a /etc/wsl.conf

# No sudo
echo -e "Defaults:kali timestamp_timeout=-1\nkali ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/kali > /dev/null
sudo chmod 0440 /etc/sudoers.d/kali && sudo visudo -c

# OMZ sudo fix
compaudit | xargs -r chmod g-w,o-w
sudo chown -RL kali:lali /home/kali/.oh-my-zsh

# Configure ZSH
sudo curl -o $HOME/.zshrc https://gist.githubusercontent.com/somnico/62d5f387f0a33ee82265f22ba1cd63c7/raw

# Reset debconf
unset DEBIAN_FRONTEND

# Clean up
sudo apt autoremove -y && sudo apt clean

# Start VNC server
vncserver -geometry 1600x900
sleep 5        

# Update terminal
exec zsh
