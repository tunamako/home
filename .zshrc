# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
LD_LIBRARY_PATH=/usr/lib:/usr/lib32:/usr/lib64
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/michael/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

PROMPT="[%n@ %1~]$ "

source $HOME/.aliases