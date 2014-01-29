MYSQL=/usr/local/mysql/bin
export DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH

export PATH=~/bin:$PATH:$MYSQL
export PATH=/usr/local/sbin:$PATH
export LOCAL_GEMS=1
export CLICOLOR=1 #ls with colors

#functions
  #echo the current rvm gemset
  function parse_rvm_gemset {
    echo `rvm-prompt g`
  }

  #is the branch dirty, if so echo a *
  function parse_git_dirty {
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
  }

  #if in a git repo echo branch name, dirty status, and rvm gemset
  function parse_git_branch {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "("${ref#refs/heads/}"`parse_git_dirty``parse_rvm_gemset`)"
  }

# this makes tab-completion nicer, because it ignore
# case, so `cd co[TAB]` will complete to `cd Code`
bind 'set completion-ignore-case on'

# export PS1="$GREEN\w $YELLOW\$(parse_git_branch)$NO_COLOR → "
PS1="\[\033[1;32m\]\w \[\033[1;33m\]\$(parse_git_branch)\[\033[0m\] >>"


function myip {
  res=$(curl -s checkip.dyndns.org | grep -Eo '[0-9\.]+')
  echo "$res"
}

function git_stats {
# awesome work from https://github.com/esc/git-stats
# including some modifications
if [ -n "$(git symbolic-ref HEAD 2> /dev/null)" ]; then
    echo "Number of commits per author:"
    git --no-pager shortlog -sn --all
    AUTHORS=$( git shortlog -sn --all | cut -f2 | cut -f1 -d' ')
    LOGOPTS=""
    if [ "$1" == '-w' ]; then
        LOGOPTS="$LOGOPTS -w"
        shift
    fi
    if [ "$1" == '-M' ]; then
        LOGOPTS="$LOGOPTS -M"
        shift
    fi
    if [ "$1" == '-C' ]; then
        LOGOPTS="$LOGOPTS -C --find-copies-harder"
        shift
    fi
    for a in $AUTHORS
    do
        echo '-------------------'
        echo "Statistics for: $a"
        echo -n "Number of files changed: "
        git log $LOGOPTS --all --numstat --format="%n" --author=$a | cut -f3 | sort -iu | wc -l
        echo -n "Number of lines added: "
        git log $LOGOPTS --all --numstat --format="%n" --author=$a | cut -f1 | awk '{s+=$1} END {print s}'
        echo -n "Number of lines deleted: "
        git log $LOGOPTS --all --numstat --format="%n" --author=$a | cut -f2 | awk '{s+=$1} END {print s}'
        echo -n "Number of merges: "
        git log $LOGOPTS --all --merges --author=$a | grep -c '^commit'
    done
else
    echo "you're currently not in a git repository"
fi
}


# no duplicates in bash history
export HISTCONTROL=ignoredups

# use Sublime as default editor
export EDITOR="subl"
export RAILS_ENV="development"
export ADF_ENV="development"

alias workspace="cd /Users/chad/Documents/workspace/"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function
