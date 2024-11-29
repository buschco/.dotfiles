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
git clone git@github.com:buschco/.dotfiles.git dotfiles
git clone --separate-git-dir=~/github.com.nosync/dotfiles /path/to/repo ~
```

## [WezTerm]

```sh
brew install --cask iterm2
brew install spaceship
brew install --cask alfred
brew install --cask bitwarden
brew install fzf
xcode-select --install
brew install rbenv ruby-build
brew install --cask finicky

brew install --cask firefox
brew install --cask slack

brew install --cask figma
brew install --cask visual-studio-code
brew install --cask intellij-idea-ce
brew install --cask google-chrome
brew install --cask docker
brew install gnupg

brew install go
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
brew install --cask android-studio
brew install the_silver_searcher
brew install ripgrep
brew install fd
brew install cmake
brew install pinentry
brew install pinentry-mac
brew install awscli
brew install diff-so-fancy
# install go https://go.dev/dl/
go install golang.org/x/tools/gopls@latest
cspell link add @cspell/dict-de-de
```
