#!/bin/bash

# Default value for the os flag
os=""

# Parse command-line arguments
while getopts ":o:" opt; do
  case $opt in
    o)
      os="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Check if operating system flag is provided
if [ -z "$os" ]; then
    echo "Error: Operating system flag (-o) not provided"
    exit 1
fi

# Function to install Neovim on macOS
install_neovim_macos() {
    brew install neovim
}

# Function to install Neovim on Linux
install_neovim_linux() {
    sudo apt-get update
    sudo apt install neovim
}

install_neovim_linux_yum() {
    sudo yum -y install ninja-build cmake gcc make unzip gettext curl git --allowerasing
    git clone https://github.com/neovim/neovim
    cd neovim && git checkout stable && make CMAKE_BUILD_TYPE=Release
    sudo make install
}

# Install Neovim based on the specified operating system
case "$os" in
    "macos")
        install_neovim_macos
        ;;
    "linux")
        install_neovim_linux
        ;;
    "linux-yum")
	install_neovim_linux_yum
	;;
    *)
        echo "Unsupported operating system"
        exit 1
        ;;
esac

# Create Neovim configuration directory if it doesn't exist
mkdir -p ~/.config/nvim/

# Copy Neovim configuration
cp -r init.vim ~/.config/nvim/

# Instal Vim-Plug (if not already installed)
if [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Install plugins using Vim-Plug
nvim +PlugInstall +qall
