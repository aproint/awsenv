# adopted from https://unix.stackexchange.com/a/531118/403382
_awsenv_chpwd_hook() {
  shopt -s nullglob

  # run awsenv_execute on dir change
  if [[ "$PREVPWD" != "$PWD" ]]; then
    local IFS=$';'
    _awsenv_execute
    unset IFS
  fi
  # refresh last working dir record
  export PREVPWD="$PWD"
}

# add `;` after _awsenv_chpwd_hook if PROMPT_COMMAND is not empty
export PROMPT_COMMAND="_awsenv_chpwd_hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
