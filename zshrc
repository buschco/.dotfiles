# If you come from bash you might have to change your $PATH.
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:

# Add MacGPG2 to PATH (do I need this?)
#export PATH="/usr/local/MacGPG2/bin:$PATH"

# Using docker now see below
#export PATH="/Library/TeX/texbin:$PATH"

# Add latex docker scripts to PATH (LaTeX-Workshop vscode plugin)
export PATH="$HOME/.latex-docker-scripts/bin:$PATH"

# Add homebrew sbin to PATH
export PATH="/usr/local/sbin:$PATH"

# Add fastlane to PATH (react-native)
export PATH="$HOME/.fastlane/bin:$PATH"

# Add open ssl to Path
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

# Add android tools to PATH (react-native)
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator

# init rbenv (see: https://github.com/rbenv/rbenv)
eval "$(rbenv init -)"

# Path to your oh-my-zsh installation.
export ZSH="/Users/colin/.oh-my-zsh"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="spaceship"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration
USER=''
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias c=clear
alias fga="cd ~/Documents/dwins.nosync/Financeguru"
alias priv="cd ~/Documents/code.nosync/"

# git aliases
alias gfm="git co master && git fetch --all && git pull && git co -"
alias gpb="git fetch --all && git pull"
alias gca="git add . && git commit --amend"
alias gcp="git cherry-pick"
alias gfb="git fetch --all && git pull"

export AWS_DEFAULT_REGION="eu-central-1"
export AWS_ACCESS_KEY_ID="***REMOVED***"
export AWS_SECRET_ACCESS_KEY="***REMOVED***"

SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  user          # Username section
  dir           # Current directory section
  git           # Git section (git_branch + git_status)
  exec_time     # Execution time
  jobs          # Background jobs indicator
  exit_code     # Exit code section
)
SPACESHIP_GIT_STATUS_PREFIX=" "
SPACESHIP_GIT_STATUS_SUFFIX=" "
SPACESHIP_GIT_STATUS_UNTRACKED="🔍 " #Indicator for untracked changes
SPACESHIP_GIT_STATUS_ADDED="🌟 "     #Indicator for added changes
SPACESHIP_GIT_STATUS_MODIFIED="💫 "  #Indicator for unstaged files
SPACESHIP_GIT_STATUS_RENAMED="🗯 "   #Indicator for renamed files
SPACESHIP_GIT_STATUS_DELETED="🗑 "   #Indicator for deleted files
SPACESHIP_GIT_STATUS_STASHED="📨 "   #Indicator for stashed changes
SPACESHIP_GIT_STATUS_UNMERGED="☄️ "  #Indicator for unmerged changes
SPACESHIP_GIT_STATUS_AHEAD="🔥 "     #Indicator for unpushed changes (ahead of remote branch)
SPACESHIP_GIT_STATUS_BEHIND="❄️ "    #Indicator for unpulled changes (behind of remote branch)
SPACESHIP_GIT_STATUS_DIVERGED="🌱 "  #Indicator for diverged changes (diverged with remote branch)

function s3link() {
	aws s3 cp "$1" s3://share.busch.dev/ && aws s3 presign s3://share.busch.dev/"$1" --expires-in 600000
}

function chpwd_profiles() {
    local profile context
    local -i reexecute

    context=":chpwd:profiles:$PWD"
    zstyle -s "$context" profile profile || profile='default'
    zstyle -T "$context" re-execute && reexecute=1 || reexecute=0

    if (( ${+parameters[CHPWD_PROFILE]} == 0 )); then
        typeset -g CHPWD_PROFILE
        local CHPWD_PROFILES_INIT=1
        (( ${+functions[chpwd_profiles_init]} )) && chpwd_profiles_init
    elif [[ $profile != $CHPWD_PROFILE ]]; then
        (( ${+functions[chpwd_leave_profile_$CHPWD_PROFILE]} )) \
            && chpwd_leave_profile_${CHPWD_PROFILE}
    fi  
    if (( reexecute )) || [[ $profile != $CHPWD_PROFILE ]]; then
        (( ${+functions[chpwd_profile_$profile]} )) && chpwd_profile_${profile}
    fi  

    CHPWD_PROFILE="${profile}"
    return 0
}

chpwd_functions=( ${chpwd_functions} chpwd_profiles )

chpwd_profile_dwins() {
  [[ ${profile} == ${CHPWD_PROFILE} ]] && return 1
  print "Switching profile ${CHPWD_PROFILE} -> $profile \n"
  export GIT_AUTHOR_NAME="Colin Busch"
  export GIT_COMMITTER_NAME="Colin Busch"
  export GIT_AUTHOR_EMAIL="colin@dwins.de"
  export GIT_COMMITTER_EMAIL="colin@dwins.de"
  export AWS_ACCESS_KEY_ID="***REMOVED***"
  export AWS_SECRET_ACCESS_KEY="***REMOVED***"
  export AWS_DEFAULT_REGION="eu-central-1"
}

chpwd_profile_default() {
  [[ ${profile} == ${CHPWD_PROFILE} ]] && return 1
  print "Switching profile ${CHPWD_PROFILE} -> $profile"
  export GIT_AUTHOR_NAME="buschco"
  export GIT_COMMITTER_NAME="buschco"
  export GIT_AUTHOR_EMAIL="colin@busch.dev"
  export GIT_COMMITTER_EMAIL="colin@busch.dev"
  export AWS_ACCESS_KEY_ID="***REMOVED***"
  export AWS_SECRET_ACCESS_KEY="***REMOVED***"
  export AWS_DEFAULT_REGION="eu-central-1"
}

zstyle ':chpwd:profiles:/Users/colin/Documents/dwins.nosync(|/|/*)' profile dwins

chpwd_profiles
# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh

docker-run() {
  docker run -it --rm -v $(pwd):/project -w /project "$@"
}

esp-build-and-flash() {
  echo "$@"
  docker-run esp-rtos make -C "$@" all && make -C "$@" erase_flash && make -C "$@" flash && make -C "$@" monitor
}

# git log show with fzf
# from https://gist.github.com/tamphh/3c9a4aa07ef21232624bacb4b3f3c580
gli() {
  if [[ ! `git log -n 1 $@ | head -n 1` ]] ;then
    return
  fi
  local filter
  if [ -n $@ ] && [ -f $@ ]; then
    filter="-- $@"
  fi
  local gitlog=(
    git log
    --graph --color=always
    --abbrev=7
    --format='%C(auto)%h %an %C(blue)%s %C(yellow)%cr'
    $@
  )
  local fzf=(
    fzf
    --ansi --no-sort --reverse --tiebreak=index
    --preview "f() { set -- \$(echo -- \$@ | grep -o '[a-f0-9]\{7\}'); [ \$# -eq 0 ] || git show --color=always \$1 $filter; }; f {}"
    --bind "ctrl-q:abort,ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % $filter | less -R') << 'FZF-EOF'
                {}
                FZF-EOF"
   --preview-window=right:60%
  )
  $gitlog | $fzf
}

