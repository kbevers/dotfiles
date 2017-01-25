source ~/.git-completion.bash
#source ~/.git-prompt.sh

alias ls="ls -G"
alias ll="ls -l"
alias dir=ls
alias vim=/usr/local/bin/vim

export GDAL_DRIVER_PATH=/usr/local/lib/gdalplugins
export VIMRUNTIME=/usr/local/share/vim/vim80/


# LS COLORS
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad

# locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# promtp stuff
export PROMPT_COMMAND=build_prompt

RESET="\[\033[0m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[01;32m\]"
BLUE="\[\033[01;34m\]"
YELLOW="\[\033[0;33m\]"
BGWHITE="\[\033[47m\]"

PS_LINE=`printf -- ' %.0s' {1..200}`
function parse_git_branch {
  PS_BRANCH=''
  PS_FILL=${PS_LINE:0:$COLUMNS}

  # check if we're inside a git repo and store the return code (next line)
  git rev-parse --is-inside-work-tree 2>/dev/null 1>&2
  local IS_GIT=$?

  if [ -d .svn ]; then
    PS_BRANCH="(svn r$(svn info|awk '/Revision/{print $2}'))"
    return
  elif [ -d .hg ]; then
    PS_BRANCH="(hg $(hg branch)) "
    return
  elif [ $IS_GIT -eq 0 ]; then
    ref=$(git rev-parse --abbrev-ref --symbolic-full-name @{u}) 2> /dev/null || return
    PS_BRANCH="(git ${ref}) "
  fi
}

function build_prompt {
    local EXIT="$?"
    parse_git_branch

    PS_INFO="$GREEN\u@\h$RESET:$BLUE\w"
    PS_GIT="$YELLOW\$PS_BRANCH"

    if [ $EXIT != 0 ]; then
        PS_TIME="\[\033[\$((COLUMNS-12-${#EXIT}))G\]\] $RED<$EXIT>[\t]"
    else
        PS_TIME="\[\033[\$((COLUMNS-10))G\]\] $GREEN[\t]"
    fi

    PS1="\${PS_FILL}\[\033[0G\]${PS_INFO} ${PS_GIT}${PS_TIME}\n${RESET}\$ "
}


