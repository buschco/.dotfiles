# dotfiles

## [Homebrew](brew.sh)

## Copy Keys

1. Enable SSH on old mac

```sh
cd ~/.shh
sftp <ip_of_old_mac>
get ~/.ssh/config
get ~/.ssh/id_ed25519
get ~/.ssh/id_ed25519.pub
get ~/.ssh/known_hosts
```

## Clone Dotfiles

```sh
mkdir ~/github.com.nosync/
git clone --bare git@github.com:buschco/.dotfiles.git dotfiles
git --git-dir=$HOME/github.com.nosync/dotfiles --work-tree=$HOME checkout
```

### ZSH

#### Oh My ZSH

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

#### Spaceship

```sh
brew install spaceship
```

#### ZSH autosuggestions

```sh
brew install zsh-autosuggestions
```

#### [WezTerm](https://wezfurlong.org/wezterm/install/macos.html#homebrew)

```sh
brew install --cask wezterm
```

Font:

```sh
brew install --cask font-fira-code
```

### Firefox

```sh
brew install --cask firefox
brew install --cask firefox@developer-edition
brew install --cask finicky
```

### openvpn-connect

```sh
brew install --cask openvpn-connect
```

### nvm

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
npm -g install cspell@latest @cspell/dict-de-de @fsouza/prettierd @tailwindcss/language-server typescript-language-server typescript vscode-langservers-extracted yarn
cspell link add @cspell/dict-de-de

```

### gpg keys

on old mac

```sh
gpg --list-secret-keys --keyid-format=long
gpg --export-secret-keys <keyid> > key
```

on new mac

```sh
brew install gnupg
brew install pinentry
brew install pinentry-mac
gpg --import >> key
```

## Rust

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### nvim (via bob)

```sh
brew install cmake
brew install fzf
cspell link add @cspell/dict-de-de
cargo install bob-nvim
bob use latest
```

### tmux

```sh
brew install tmux
```

### Bitwarden

```sh
brew install --cask bitwarden
```

### Xcodes

```sh
brew install xcodesorg/made/xcodes
brew install aria2

xcodes install --latest
```

### rbenv

```sh
brew install rbenv
```

### Slack

```sh
brew install --cask slack
```

### Figma

```sh
brew install --cask figma
```

### docker

```sh
brew install --cask docker
```

### Raycast

```sh
brew install --cask raycast
```

export settings from old mac

### chrome

```sh
brew install --cask google-chrome
```

### Android Studio

```sh
brew install --cask android-studio
```

### Inkscape

```sh
brew install --cask inkscape
```

### battery

```sh
curl -s https://raw.githubusercontent.com/actuallymentor/battery/main/setup.sh | bash
battery maintain 80
```

### Small shell tools

```sh
brew install the_silver_searcher ripgrep fd awscli diff-so-fancy
```

### Lua

```sh
brew install lua-language-server
```

### Xcode LSP

```sh

```

### idk if i really need this

```sh
brew install rbenv ruby-build
brew install --cask visual-studio-code
brew install --cask intellij-idea-ce

brew install go
# install go https://go.dev/dl/
go install golang.org/x/tools/gopls@latest
```

## macOS defaults
