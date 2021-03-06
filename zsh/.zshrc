source <(antibody init)
antibody bundle < $HOME/.antibody_plugins

bindkey -e

# only compinit once a day
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# Setup history stuff
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

export GOPATH=$HOME/Code/Go
export GOROOT=/usr/local/opt/go/libexec
export PATH="$HOME/.cargo/bin:/usr/local/heroku/bin:/Users/cooperlebrun/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Users/cooperlebrun/.local/bin:/usr/local/opt/llvm/bin:$GOPATH/bin:$GOROOT/bin:$PATH"
export PATH="$HOME/zig:$PATH"
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=23'

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Turn off terminal bell/beep for ambiguous list completions
unsetopt LIST_BEEP

export BROWSER='firefox'

# Abbreviations
alias g='git'
alias be='bundle exec'
alias tm='tmux'
alias -g htop='sudo htop'
alias dot='cd ~/dotfiles'

alias buu='brew upgrade && brew cleanup -s' # brew upgrade / clean old packages
alias bdump='brew bundle dump --force --global' # show all installed brew packages
alias resrc='source ~/.zshrc' # doesn't play well with antigen

# Heroku
alias he='heroku'
alias her="heroku run rails console -r"
alias hel="heroku logs"

# Docker
if type "docker" &> /dev/null; then
    alias d="docker"
    alias dc="docker-compose"
    alias d-clean='docker rm $(docker ps -qa --no-trunc --filter "status=exited") && docker rmi $(docker images --filter "dangling=true" -q --no-trunc)'
fi

# Rust
if type "rustc" &> /dev/null; then
    source $HOME/.cargo/env
    eval $(/usr/libexec/path_helper -s)
fi

# Ruby
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh
chruby ruby-2.7.1

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--reverse --border -m --preview='bat --color=\"always\" {}'"

export BAT_THEME="zenburn"

# # TODO: enable multi/tweak fzf flags for pretty shit etc
# config () {
#   # what we need to prepend to a relative dotfile path to make it absolute
#   local PREFIX="${HOME}/dotfiles/"

#   # Get list of config files
#   pushd ~/dotfiles &>/dev/null
#   local CONFIG_FILES="$(git ls-files)"
#   popd &>/dev/null

#   $EDITOR $(echo $CONFIG_FILES | fzf --preview="bat --color=always ${PREFIX}{}" | awk -v p=${PREFIX} '{print p $0}')
# }

# After getting burned by using rm, I'd like to make an effort to correct bad
# habits.
alias del="rmtrash" # Don't alias rm to rmtrash. I want to correct the habit, not slap a bandaid on it
alias rm="echo 'Use del, or the full path of rm if you really need in (/bin/rm)'"

alias ed='nvim $(git ls-files | fzf)'

# alias -g pick="\$(fd --hidden -t f -E .git/ | fzf | awk -v pwd=\$(pwd) '{print pwd \"/\" \$0}')"
wttr () { curl http://wttr.in/$1 }
alias chr='chruby $(chruby | sed "s/\*/ /" | awk "{print $1}" | fzf)'
alias dca="docker-compose run web ash"
alias ls="exa"
alias l="exa -lh --git"
alias tma='tmux a -t $(tmux ls -F #{session_name} | fzf)'

copyonchange () { echo $1 | entr -cps "cat $1 | pbcopy" }

# Helper function requiring ruby and xsv spreadsheet tool
#
# uses xsv to format csv (from stdin) into fields
# separated by tabs, feeds it to a ruby script string (first argument)
# and formats the stdout of that script string output back
# to csv format.
# NOTES:
# The ruby script prints whatever value $_ is at the end of a given line.
# $. is the line number, 1-indexed.
# -l auto #chomps line endings from $_
rsv () { xsv fmt -t "\t" | ruby -ple $1 | xsv fmt -d "\t" }
asv () { xsv fmt -t "\t" | awk -F "\t" $1 | xsv fmt -d "\t" }

alias rec='ls -1t | head'

export NVM_DIR="$HOME/.nvm"
alias loadnvm='[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"'
