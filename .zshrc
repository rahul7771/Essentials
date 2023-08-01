# The various escape codes that we can use to color our prompt.
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

# determine git branch name
function parse_git_branch(){
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# determine mercurial branch name
function parse_hg_branch(){
  hg branch 2> /dev/null | awk '{print " (" $1 ")"}'
}

# Determine the branch/state information for this git repository.
function set_git_branch() {
  # Get the name of the branch.
  branch=$(parse_git_branch)
  # if not git then maybe mercurial
  if [ -z "$branch" ]
  then
    branch=$(parse_hg_branch)
  fi

  # Set the final branch string.
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

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol () {
  if test $1 -eq 0 ; then
      PROMPT_SYMBOL="%F{green}\$%F{white}"
  else
      PROMPT_SYMBOL="%F{red}\$%F{white}"
  fi
}

# Determine active Python virtualenv details.
function set_virtualenv () {
  if test -z "$VIRTUAL_ENV" ; then
      PYTHON_VIRTUALENV=""
  else
      PYTHON_VIRTUALENV="%F{blue}[`basename \"$VIRTUAL_ENV\"`]${COLOR_NONE} "
  fi
}

# Set the full bash prompt.
function set_zsh_prompt () {
  # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
  # return value of the last command.
  set_prompt_symbol $?

  # Set the PYTHON_VIRTUALENV variable.
  set_virtualenv

  # Set the BRANCH variable.
  set_git_branch

  # set k8s prompt
  set_k8s_prompt

  # Set the bash prompt variable.
  PS1="
${PYTHON_VIRTUALENV}${GREEN}%n@%m${COLOR_NONE}:${LIGHT_YELLOW}%~${COLOR_NONE}${BRANCH}${K8S}
${PROMPT_SYMBOL} "
}

# Tell bash to execute this function just before displaying its prompt.
precmd_functions+=(set_zsh_prompt)
