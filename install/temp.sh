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
sudo apt-get install -y kali-desktop-xfce kali-defaults kali-tools-top10 

# Install other tools
sudo apt-get install -y ghidra libimage-exiftool-perl dirb theharvester wfuzz openvas-scanner exploitdb dnsutils socat tigervnc-standalone-server dconf-cli expect
bash <(curl -s https://raw.githubusercontent.com/robiot/rustcat/master/pkg/debian-install.sh)

# Set VNC password
mkdir -p $HOME/.vnc/
sudo wget -P $HOME/.vnc/ https://raw.githubusercontent.com/somnico/kali/master/configs/passwd
sudo chown -R kali:kali $HOME/.vnc
sudo chmod 700 $HOME/.vnc
sudo chmod 600 $HOME/.vnc/*

# Set password 
sudo wget -N -P /etc/ https://raw.githubusercontent.com/somnico/kali/master/configs/shadow

# Set time
sudo timedatectl set-timezone Europe/Oslo

# Change wallpaper 
sudo apt install -y kali-wallpapers-all
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


# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Powerlevel
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Configure Powerlevel 
sudo curl -o $HOME/.p10k.zsh https://gist.githubusercontent.com/somnico/b71f23f21f931d6d9c2445719c571ab5/raw 

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

# Keybinds
sudo curl -o $HOME/.oh-my-zsh/lib/key-bindings.zsh https://raw.githubusercontent.com/somnico/kali/master/configs/key-bindings.zsh


# Install shells
sudo apt-get -y install fish xonsh
sudo snap install nushell --classic

# Configure shells
fish -c "set -U fish_greeting ''"

touch $HOME/.xonshrc
echo '[$PATH.remove(path) for path in $PATH.paths if path.startswith("/mnt/c/")]' >> $HOME/.xonshrc

mkdir -p $HOME/.config/nushell/
touch $HOME/.config/nushell/config.nu
echo -e '$env.config.show_banner = false\n$env.PROMPT_COMMAND_RIGHT = ""' >> $HOME/.config/nushell/config.nu

# Install Python
sudo apt-get install -y python3 python3-dev python3-pip pipx python3-venv python3-setuptools python3-cffi python3-pypandoc git build-essential libssl-dev libffi-dev 
source $HOME/.profile
pipx install ipython uv poetry virtualenv virtualenvwrapper wheel
python3 -m pip install --upgrade pip --no-warn-script-location

# Configure Python 
ipython profile create
echo "c.TerminalIPythonApp.display_banner = False" >> $HOME/.ipython/profile_default/ipython_config.py
echo "c.InteractiveShell.colors = 'linux'" >> $HOME/.ipython/profile_default/ipython_config.py

# Install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal

# Install ruby
sudo apt-get install -y ruby3.3-dev   


# Install lazy script
git clone https://github.com/arismelachroinos/lscript.git
cd lscript
sudo chmod +x install.sh
./install.sh
cd ..

# Install shodan
pipx install shodan

# Install pwntools
python3 -m pip install --upgrade pwntools --no-warn-script-location

# Install gdb peda
sudo apt-get install -y gdb
git clone https://github.com/longld/peda.git $HOME/peda
echo "source $HOME/peda/peda.py" >> $HOME/.gdbinit

# Script for gdb
curl -o $HOME/peda/pid.sh https://raw.githubusercontent.com/somnico/kali/master/scripts/gdb_pid.sh
sudo chmod +x pid.sh

# Install oletools
sudo -H pip install -U oletools[full]


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
sudo apt update && sudo apt install gh hub -y

mkdir -p $HOME/.cache/completions/
cp /usr/share/zsh/vendor-completions/_hub $HOME/.zsh/completions/_hub

# Install localstack
pipx install localstack --include-deps 

# Install helpers
sudo apt-get install -y nodejs npm snapd
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
sudo apt update && sudo apt install -y gum

# Install rclone
sudo curl https://rclone.org/install.sh | sudo bash
python3 -m pip install gdown --no-warn-script-location
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

sudo curl -o $HOME/.config/micro/settings.json https://raw.githubusercontent.com/somnico/kali/master/configs/micro/settings.json
sudo curl -o $HOME/.config/micro/bindings.json https://raw.githubusercontent.com/somnico/kali/master/configs/micro/bindings.json
sudo curl -o $HOME/.config/micro/colorschemes/custom.micro https://raw.githubusercontent.com/somnico/kali/master/configs/micro/custom.micro

curl -o $HOME/.config/helix/config.toml https://raw.githubusercontent.com/somnico/kali/master/configs/helix/config.toml
curl -o $HOME/.config/helix/themes/custom.toml https://raw.githubusercontent.com/somnico/kali/master/configs/helix/custom.toml
curl -o $HOME/.config/helix/yazi-picker-tmux.sh https://raw.githubusercontent.com/somnico/kali/master/configs/helix/yazi-picker-tmux.sh
curl -o $HOME/.config/helix/yazi-picker-zellij.sh https://raw.githubusercontent.com/somnico/kali/master/configs/helix/yazi-picker-zellij.sh
chmod +x ~/.config/helix/yazi-picker-tmux.sh
chmod +x ~/.config/helix/yazi-picker-zellij.sh


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

# Install utilities
sudo apt-get install -y autoconf pcf2bdf xfonts-75dpi xfonts-base zlib1g-dev libreadline-dev udiskie moreutils ncurses-bin libcurses-perl libncurses-dev libncursesw5-dev
sudo apt-get install -y sl pv oneko scdoc procps g++ pkg-config libpoppler-glib-dev poppler-utils libpoppler-cpp-dev apt-transport-https ca-certificates software-properties-common
sudo apt-get install -y libtool libsixel-dev libpng-dev libjpeg-dev libtiff-dev libgraphicsmagick++-dev libturbojpeg-dev libexif-dev libaa-bin libmpv-dev
sudo apt-get install -y libpthread-stubs0-dev libswscale-dev libdeflate-dev librsvg2-dev libcairo-dev libavcodec-dev libavformat-dev libavdevice-dev libavutil-dev
sudo apt-get install -y expat libxml2-dev libasound2-dev libfreetype6-dev libexpat1-dev libxcb-composite0-dev libharfbuzz-dev libfontconfig1-dev libqrcodegen-dev
sudo apt-get install -y doctest-dev libgpm-dev libunistring-dev libfuse2 libgtk-4-dev gtk+-3.0 libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render0-dev libxcb1-dev

# Install build tools
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to $HOME/.local/bin
sudo /bin/sh -c 'wget https://github.com/earthly/earthly/releases/latest/download/earthly-linux-amd64 -O /usr/local/bin/earthly && chmod +x /usr/local/bin/earthly && /usr/local/bin/earthly bootstrap --with-autocomplete' >/dev/null 2>&1
sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d
curl -sf https://gobinaries.com/tj/mmake/cmd/mmake | sudo sh
sudo apt-get install -y automake cmake 
curl https://get.please.build | bash
pipx install snakemake

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
sudo apt-get install -y fortune-mod cowsay lolcat boxes cmatrix vitetris caca-utils hollywood timg chafa jp2a bsdgames thefuck 
sudo apt-get install -y clusterssh keychain jq yq gawk pandoc httpie zstd texinfo hexyl ffmpeg imagemagick fontforge unicode dos2unix xdotool most xcel xclip trash-cli man-db procs shfmt
sudo apt-get install -y fastfetch magic-wormhole neomutt taskwarrior time googler ddgr buku htop btop iftop duf grc ansilove aha asciinema gifsicle yt-dlp mpv dmenu ytfzf

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
sudo apt install ueberzugpp


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
cd ../..

gem install colorls

pipx install colorz pywal

sudo npm install -g gradient-terminal


curl -s "https://get.sdkman.io" | bash

wget https://github.com/charmbracelet/vhs/releases/download/v0.9.0/vhs_0.9.0_amd64.deb
sudo dpkg -i vhs_0.9.0_amd64.deb
sudo rm -f vhs_0.9.0_amd64.deb

wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb
sudo dpkg -i libssl1.1_1.1.0g-2ubuntu4_amd64.deb
sudo rm -rf libssl1.1_1.1.0g-2ubuntu4_amd64.deb
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
cd ../..

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
pip install --upgrade pycryptodome brotli yt-dlp
cd badapplefetch
make -j$(nproc --all)
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

ipx install wisdom-tree

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
# sudo chown -RL root:root /home/kali/.oh-my-zsh

# Configure ZSH
sudo curl -o $HOME/.zshrc https://gist.githubusercontent.com/somnico/62d5f387f0a33ee82265f22ba1cd63c7/raw

# Reset debconf
unset DEBIAN_FRONTEND

# Start VNC server
vncserver -geometry 1600x900
sleep 5        

# Update terminal
exec zsh


# Notes
 
# Kali packages
# https://www.kali.org/docs/general-use/metapackages/

# Install pentesting tools as root
# curl -k -s https://raw.githubusercontent.com/blacklanternsecurity/kali-setup-script/master/kali-setup-script.sh | bash

# Establish SSH connection
# sudo chmod 400 $HOME/Kali.pem
# ssh -o StrictHostKeyChecking=no -i Kali.pem kali@51.20.37.35
# ssh -L 5901:localhost:5901 -N -f -i kali.pem kali@51.20.37.35

# SSH connectivity issues
# ssh-keygen -f "/mnt/c/Users/nfs/.ssh/known_hosts" -R "51.20.37.35"
# ssh-keygen -f "/home/nicolafs/.ssh/known_hosts" -R "51.20.37.35"
# ipconfig /flushdns

# Change shell
# chsh -s $(which zsh)

# Commands for file sharing
# Web application instead of Desktop app in Google Credentials
# rclone config
# rclone lsd Drive:
# curl -L -o file.type https://drive.google.com/uc?id=id_here

# Remove VNC settings
# vncserver -list
# vncserver -kill :1
# sudo rm -rf $HOME/.vnc/passwd $HOME/.vnc/xstartup
# sudo rm -rf /tmp/.X*-lock /tmp/.X11-unix/X*
# sudo kill -9 $(ps aux | grep '[X]tightvnc' | awk '{print $2}')

# Setup RDP
# Add inbound RDP rule and reboot
# sudo apt-get install -y xrdp
# sudo systemctl enable xrdp

# Setup NX
# Add inbound custom TCP rule for port 4000 and reboot
# curl -O https://download.nomachine.com/download/8.10/Linux/nomachine_8.10.1_1_amd64.deb
# sudo apt-get install -y cups
# sudo dpkg -i nomachine_*.deb

# More backgrounds
# mkdir -p /usr/share/backgrounds/windows/
# sudo curl -o /usr/share/backgrounds/windows/windows-wallpaper-1.jpg https://raw.githubusercontent.com/somnico/kali/master/images/backgrounds/kali-actiniaria.png

# More fonts
# git clone --depth=1 --branch=master https://github.com/ryanoasis/nerd-fonts.git nerd-fonts
# ./nerd-fonts/install.sh FiraCode
# sudo cp -r nerd-fonts/patched-fonts/FiraCode/Regular /usr/share/fonts/truetype/firanerd
# sudo apt-get install -y fonts-powerline

# Install only one font family 
# sudo apt-get install -y subversion
# svn checkout --depth=empty https://github.com/ryanoasis/nerd-fonts/trunk/patched-fonts
# cd patched-fonts
# svn update --set-depth=infinity DejaVuSansMono
# cd ..
# sudo cp -r patched-fonts/DejaVuSansMono/Regular/DejaVuSansMNerdFontMono-Regular.ttf /usr/share/fonts/truetype/dejavu

# GUI updates
# xfdesktop -Q && xfdesktop &
# pkill xfce4-panel && xfce4-panel &

# Individual entries for qterminal 
# sudo sed -i 's/\(fontFamily=\).*/\1DejaVuSansM Nerd Font Mono/' $HOME/.config/qterminal.org/qterminal.ini

# Change syntax highlighting theme
# git clone https://github.com/dracula/zsh-syntax-highlighting.git
# sudo sed -i '/ZSH_THEME="powerlevel10k\/powerlevel10k"/a\
# \
# # Set Syntax Highlighting theme\
# source $HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.sh' $HOME/.zshrc

# Docks
# sudo apt-get install -y cairo-dock plank

# Greetings
# fortune | cowsay -f "$(ls /usr/share/cowsay/cows | sort -R | head -1)" | lolcat -a -d 1
# echo "kali" | figlet -f fraktur | boxes -d twisted -a hcvc -p h6v1 | awk -v cols=$(tput cols) '{ printf "%*s\n", (cols + length) / 2, $0 }' | lolcat -f -a -d 1 -p 5 -F 0.03 -S 30
# fortune | cowsay -f calvin | boxes -d columns -a c | awk -v cols=$(tput cols) '{ printf "%*s\n", (cols + length) / 2, $0 }' | lolcat -a -d 1 -S 20
# fm6000 -dog -l 50 -say "$(echo "KALI" | figlet -f big)" | lolcat -a -d 1 -S 19
# fortune | cowsay -f "$(ls /usr/share/cowsay/cows | sort -R | head -1)" | while IFS= read -r line; do printf "%s" "$line" | while IFS= read -n1 -r char; do printf "%s" "$char"; sleep 0.0001; done; echo; done;
# neofetch --ascii $HOME/.config/neofetch/custom.txt

# Alternatives
# 3d_diagonal, Big_Money-ne, Chiseled, cosmike, doubleshorts, Elite, doubleshorts, fraktur, Georgia11, ghost, henry3d, lildevil, larry3d, lineblocks
# columns, ian_jones, twisted
# ascii, digit, extra, diagonal, alpha, stipple, technical, wide
# 2, 6, 7, 10, 12, 13, 17, 24

# AWS alternative
# mkdir -p $HOME/.aws/
# sudo curl -L -o $HOME/.aws/config https://drive.google.com/uc?id=
# sudo curl -L -o $HOME/.aws/credentials https://drive.google.com/uc?id=

# Various 
# xfconf-query -c xfce4-desktop -p /desktop-icons/gravity --create -t int -s 1
# xfconf-query -c xsettings -p /Net/PreferredApplications/TextEditor -n -t string -s "org.xfce.mousepad.desktop" 
# xfdesktop -A  

# Xfconf reference
# for channel in $( xfconf-query --list | tail --lines=+2 | sort ); do printf -- '\n\e[1;36m%s\e[m\n' "${channel}"; xfconf-query --list --verbose --channel "${channel}"; done

# Keybind reference
# https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets
# $HOME/.oh-my-zsh/lib/key-bindings.zsh
# bindkey 
# showkey --ascii
# man ascii

# Consistent gist links
# gistusercontent/raw or gistusercontent/raw/filename 

# Blinking
# echo -e "\e[5mBlinking Text\e[25m" 

# Display clock
# while sleep 1;do tput sc;tput cup 0 $(($(tput cols)-29));date;tput rc;done &

# Color reference
# for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
