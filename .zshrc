export PATH=/opt/homebrew/bin:$PATH
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl/lib/
export PIP_EXTRA_INDEX_URL="https://pypi.dev-kayrros.ovh"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PIPENV_PYTHON="$PYENV_ROOT/shims/python"

plugin=(
  pyenv
)

eval "$(pyenv virtualenv-init -)"

eval "$(pyenv init --path)"
eval "$(pyenv init -)"


# alias to clear terminal history
alias cls="clear && printf '\e[3J'"

# alias kubectl
alias kc="kubectl"

# alias for processing interation helper scripts
alias process_status="PYTHONPATH="." python3 scripts/processing_interation/get_processing_status.py"
alias post_process="PYTHONPATH="." python3 scripts/processing_interation/post_processing.py"
alias delete_process="PYTHONPATH="." python3 scripts/processing_interation/delete_processing.py"
alias deactivate_process="PYTHONPATH="." python3 scripts/processing_interation/update_process_status.py"

# alias for flake
alias flake="flake --max-line-length 120 --igone W504,W605,W503,E722,E741 --exclude alembic/.venv/"

# alias for git commnads
alias gs="git status"
alias gc="git commit -m"
alias gps="git push"
alias gpl="git pull"
alias ga="git add"


# source python venv on opening new shell
source /Users/rahuldev/Documents/PycharmProjects/peng/bin/activate 

# alias to go process-engine-repos folder
alias pe='cd /Users/rahuldev/Documents/PErepos/'

# alias for juputer nptebook
alias note='jupyter notebook'

# alias for pythonpath
alias pp='PYTHONPATH="."'


# zsh prompt to show git branch python virtualenv k8s namespaces
BLACK="%F{black}"
LIGHT_BLACK="%F{black}"
RED="%F{red}"
LIGHT_RED="%F{red}"
GREEN="%F{green}"
LIGHT_GREEN="%F{green}"
YELLOW="%F{yellow}"
LIGHT_YELLOW="%F{yellow}"
BLUE="%F{blue}"
LIGHT_BLUE="%F{blue}"
PURPLE="%F{magenta}"
LIGHT_PURPLE="%F{magenta}"
CYAN="%F{cyan}"
LIGHT_CYAN="%F{cyan}"
WHITE="%F{white}"
LIGHT_WHITE="%F{white}"
COLOR_NONE="%f"


function parse_git_branch(){
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}


function parse_hg_branch(){
  hg branch 2> /dev/null | awk '{print " (" $1 ")"}'
}

# Determine the branch/state information for this git repository.
function set_git_branch() {
  
  branch=$(parse_git_branch)
  
  if [ -z "$branch" ]
  then
    branch=$(parse_hg_branch)
  fi

  
  BRANCH="%F{magenta}${branch}${COLOR_NONE} "
}

function set_k8s_namespace() {
  kubectl config view --minify -o jsonpath="{.contexts[0].context.namespace}"
}

function set_k8s_context() {
  kubectl config current-context
}

function set_k8s_prompt () {
  CONTEXT=$(set_k8s_context)
  NAMESPACE=$(set_k8s_namespace)
  K8S="%F{black}[%F{blue}${CONTEXT}|${NAMESPACE}%F{black}]${COLOR_NONE}"
}


function set_prompt_symbol () {
  if test $1 -eq 0 ; then
      PROMPT_SYMBOL="%F{green}\$%F{white}"
  else
      PROMPT_SYMBOL="%F{red}\$%F{white}"
  fi
}

function set_virtualenv () {
  if test -z "$VIRTUAL_ENV" ; then
      PYTHON_VIRTUALENV=""
  else
      PYTHON_VIRTUALENV="%F{blue}[`basename \"$VIRTUAL_ENV\"`]${COLOR_NONE} "
  fi
}


function set_zsh_prompt () {
  
  set_prompt_symbol $?

  
  set_virtualenv

  
  set_git_branch

  
  set_k8s_prompt

  
  PS1="
${PYTHON_VIRTUALENV}${GREEN}%n@%m${COLOR_NONE}:${LIGHT_YELLOW}%~${COLOR_NONE}${BRANCH}${K8S}
${PROMPT_SYMBOL} "
}


precmd_functions+=(set_zsh_prompt)
