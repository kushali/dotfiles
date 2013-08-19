PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/sbin

if [ -f /usr/local/etc/autojump ]; then
  . /usr/local/etc/autojump
fi

if [ -f /usr/local/etc/bash_completion ]; then
  . /usr/local/etc/bash_completion
fi

if [ -f /usr/local/etc/bash_completion.d/git-completion.bash  ]; then
  . /usr/local/etc/bash_completion.d/git-completion.bash 
fi


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

[[ -s "$HOME/nvm/nvm.sh" ]] && source "$HOME/nvm/nvm.sh"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

export EDITOR="emacsclient"

export GUARD_NOTIFY='false'

export HOSTNAME='aja.local'

alias dbreset="rake db:drop db:create db:migrate db:seed db:test:prepare"
alias beg="bundle exec guard"
alias startnginx='cd /Users/aja/thoughtstream/sites && sudo nginx -p ./ -c ./nginx.conf'

