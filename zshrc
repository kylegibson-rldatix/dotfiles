export HISTFILE=~/.histfile
export HISTSIZE=1000
export SAVEHIST=1000
export COLORTERM=yes

export EDITOR=vim
export PAGER=less
export RSYNC_RSH=/usr/bin/ssh
export FIGNORE='.o:.out:~'
# DISPLAY=:0.0

# output colored grep
export GREP_COLOR='7;31'

export LS_COLORS='no=0:fi=0:di=1;34:ln=1;36:pi=40;33:so=1;35:do=1;35:bd=40;33;1:cd=40;33;1:or=40;31;1:ex=1;32:*.tar=1;31:*.tgz=1;31:*.arj=1;31:*.taz=1;31:*.lzh=1;31:*.zip=1;31:*.rar=1;31:*.z=1;31:*.Z=1;31:*.gz=1;31:*.bz2=1;31:*.tbz2=1;31:*.deb=1;31:*.pdf=1;31:*.jpg=1;35:*.jpeg=1;35:*.gif=1;35:*.bmp=1;35:*.pbm=1;35:*.pgm=1;35:*.ppm=1;35:*.pnm=1;35:*.tga=1;35:*.xbm=1;35:*.xpm=1;35:*.tif=1;35:*.tiff=1;35:*.png=1;35:*.mpg=1;35:*.mpeg=1;35:*.mov=1;35:*.avi=1;35:*.wmv=1;35:*.ogg=1;35:*.mp3=1;35:*.mpc=1;35:*.wav=1;35:*.au=1;35:*.swp=1;30:*.pl=36:*.c=36:*.cc=36:*.h=36:*.core=1;33;41:*.gpg=1;33:'
export ZLS_COLORS="$LS_COLORS"

export PYTHONSTARTUP=$HOME/.pythonrc

unsetopt BEEP
# Allow functions in prompt
setopt prompt_subst
# Make cd push the old directory onto the directory stack.
setopt autopushd
# Don’t push multiple copies of the same directory onto the directory stack.
setopt PUSHD_IGNORE_DUPS
# Do not print the directory stack after pushd or popd.
setopt PUSHD_SILENT
# Do not enter command lines into the history list if they are duplicates of
# the previous event.
setopt HIST_IGNORE_DUPS
# Remove command lines from the history list when the first character on the
# line is a space, or when one of the expanded aliases contains a leading
# space.
setopt HIST_IGNORE_SPACE
# N/A
setopt SHARE_HISTORY
# Save each command’s beginning timestamp (in seconds since the epoch) and the
# duration (in seconds) to the history file.
setopt EXTENDED_HISTORY

setopt CORRECT
setopt INTERACTIVE_COMMENTS
# Allow the character sequence '' to signify a single quote within singly
# quoted strings.
setopt RC_QUOTES

# Whenever the user enters a line with history expansion, don’t execute the line
# directly; instead, perform history expansion and reload the line into the
# editing buffer.
setopt HIST_VERIFY

bindkey -v
# bindkey -M viins 'zz' vi-cmd-mode
bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward

test -f /etc/zsh_command_not_found && source /etc/zsh_command_not_found

# fpath=(~/.zsh.d/functions $fpath)

autoload -U bashcompinit; bashcompinit
autoload -U colors; colors
autoload -U compinit; compinit
autoload -U promptinit; promptinit
autoload -Uz vcs_info

precmd() {
  vcs_info
}

zstyle ':vcs_info:*' enable git

# Formats: include %{sha} where you want it
zstyle ':vcs_info:git:*' formats '%F{magenta}{%b%u%c}%f'
zstyle ':vcs_info:git:*' actionformats '%F{red}{%b|%a}%f'

# Prompt: first line shows path + vcs info; second line has `| ` for typing
PROMPT='%F{green}%~%f${vcs_info_msg_0_}
| '

unset RPROMPT

zstyle :compinstall filename $HOME/.zshrc

# Prefer GNU coreutils/grep if installed, otherwise fall back to BSD versions

if command -v gls >/dev/null 2>&1; then
  # Homebrew coreutils (gls) – Linux-like behavior
  alias ls='gls --color=always --group-directories-first'
  alias ll='LANG=C gls -o --group-directories-first'
else
  # macOS/BSD ls – best-effort color
  alias ls='ls -G'
  alias ll='ls -lG'
fi

if command -v ggrep >/dev/null 2>&1; then
  alias grep='ggrep --color=auto'
  alias fgrep='gfgrep --color=auto'
  alias egrep='gegrep --color=auto'
else
  # No color flags on BSD grep; leave them plain to avoid errors
  alias grep='grep'
  alias fgrep='fgrep'
  alias egrep='egrep'
fi

alias g='git'
alias gs='git st'
alias gd='git diff'
alias commit='git ci'
alias pull='git pull'
alias stash='git stash'
alias master='git checkout master'
alias vu='vagrant up'
alias vs='vagrant status'
alias vr='vagrant run'
alias vtest='vagrant run test'
alias mv='mv -i'

if [ -d "$HOME/work/git/PolicyStat" ]; then
    alias pstat='cd $HOME/work/git/PolicyStat'
else
    alias pstat='cd $HOME/git/PolicyStat'
fi

if [[ "$TERM" == screen* ]]; then
    function preexec {
      title=$(echo $1 | cut -c1-20)
      echo -ne "\ek$title\e\\"
    }
else
    detached=$(screen -ls | grep terminal | grep Detached | cut -f2)
    if [ -n "$detached" ]; then
        screen -r "$detached"
    else
        screen -S terminal
    fi
fi

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi


if [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  source "$NVM_DIR/nvm.sh" # This loads nvm
  source "$NVM_DIR/bash_completion" # This loads nvm bash_completion
fi

test -s "$HOME/.local/bin/env" && source "$HOME/.local/bin/env"
