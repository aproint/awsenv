# AWS RC
# the implementation is adopted from https://github.com/nvm-sh/nvm
# The list of AWS environment variables from https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html

_awsenv_echo() {
  command printf %s\\n "$*" 2>/dev/null
}

# Traverse up in directory tree to find containing folder
_awsenv_find_up() {
  local path_
  path_="${PWD}"
  while [ "${path_}" != "" ] && [ ! -f "${path_}/${1-}" ]; do
    path_=${path_%/*}
  done
  _awsenv_echo "${path_}"
}

# Find .awsenv file
_awsenv_find_awsenv() {
  local awsenv_file=".awsenv"
  local dir
  dir="$(_awsenv_find_up ${awsenv_file})"
  if [ -e "${dir}/${awsenv_file}" ]; then
    _awsenv_echo "${dir}/${awsenv_file}"
  fi
}

_awsenv_unset_aws() {
  unset AWS_ACCESS_KEY_ID
  unset AWS_CA_BUNDLE
  unset AWS_CONFIG_FILE
  unset AWS_DEFAULT_OUTPUT
  unset AWS_DEFAULT_REGION
  unset AWS_PAGER
  unset AWS_PROFILE
  unset AWS_ROLE_SESSION_NAME
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
  unset AWS_SHARED_CREDENTIALS_FILE
}

_awsenv_unset_previous() {
  unset AWSENV_PREV_AWS_ACCESS_KEY_ID
  unset AWSENV_PREV_AWS_CA_BUNDLE
  unset AWSENV_PREV_AWS_CONFIG_FILE
  unset AWSENV_PREV_AWS_DEFAULT_OUTPUT
  unset AWSENV_PREV_AWS_DEFAULT_REGION
  unset AWSENV_PREV_AWS_PAGER
  unset AWSENV_PREV_AWS_PROFILE
  unset AWSENV_PREV_AWS_ROLE_SESSION_NAME
  unset AWSENV_PREV_AWS_SECRET_ACCESS_KEY
  unset AWSENV_PREV_AWS_SESSION_TOKEN
  unset AWSENV_PREV_AWS_SHARED_CREDENTIALS_FILE
}

# `true` is used so our tests don't fail; the value itself is ignored anyway
_awsenv_save_vars() {
  set -o allexport
  [ ! -z "${AWS_ACCESS_KEY_ID+x}" ] && AWSENV_PREV_AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" || true
  [ ! -z "${AWS_CA_BUNDLE}" ] && AWSENV_PREV_AWS_CA_BUNDLE="${AWS_CA_BUNDLE}" || true
  [ ! -z "${AWS_CONFIG_FILE}" ] && AWSENV_PREV_AWS_CONFIG_FILE="${AWS_CONFIG_FILE}" || true
  [ ! -z "${AWS_DEFAULT_OUTPUT}" ] && AWSENV_PREV_AWS_DEFAULT_OUTPUT="${AWS_DEFAULT_OUTPUT}" || true
  [ ! -z "${AWS_DEFAULT_REGION}" ] && AWSENV_PREV_AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}" || true
  [ ! -z "${AWS_PAGER}" ] && AWSENV_PREV_AWS_PAGER="${AWS_PAGER}" || true
  [ ! -z "${AWS_PROFILE}" ] && AWSENV_PREV_AWS_PROFILE="${AWS_PROFILE}" || true
  [ ! -z "${AWS_ROLE_SESSION_NAME}" ] && AWSENV_PREV_AWS_ROLE_SESSION_NAME="${AWS_ROLE_SESSION_NAME}" || true
  [ ! -z "${AWS_SECRET_ACCESS_KEY}" ] && AWSENV_PREV_AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" || true
  [ ! -z "${AWS_SESSION_TOKEN}" ] && AWSENV_PREV_AWS_SESSION_TOKEN="${AWS_SESSION_TOKEN}" || true
  [ ! -z "${AWS_SHARED_CREDENTIALS_FILE}" ] && AWSENV_PREV_AWS_SHARED_CREDENTIALS_FILE="${AWS_SHARED_CREDENTIALS_FILE}" || true
  set +o allexport
}

# `true` is used so our tests don't fail; the value itself is ignored anyway
_awsenv_load_vars() {
  set -o allexport
  [ ! -z "${AWSENV_PREV_AWS_PROFILE}" ] && AWS_PROFILE="${AWSENV_PREV_AWS_PROFILE}" || true
  [ ! -z "${AWSENV_PREV_AWS_ACCESS_KEY_ID}" ] && AWS_ACCESS_KEY_ID="${AWSENV_PREV_AWS_ACCESS_KEY_ID}" || true
  [ ! -z "${AWSENV_PREV_AWS_CA_BUNDLE}" ] && AWS_CA_BUNDLE="${AWSENV_PREV_AWS_CA_BUNDLE}" || true
  [ ! -z "${AWSENV_PREV_AWS_CONFIG_FILE}" ] && AWS_CONFIG_FILE="${AWSENV_PREV_AWS_CONFIG_FILE}" || true
  [ ! -z "${AWSENV_PREV_AWS_DEFAULT_OUTPUT}" ] && AWS_DEFAULT_OUTPUT="${AWSENV_PREV_AWS_DEFAULT_OUTPUT}" || true
  [ ! -z "${AWSENV_PREV_AWS_DEFAULT_REGION}" ] && AWS_DEFAULT_REGION="${AWSENV_PREV_AWS_DEFAULT_REGION}" || true
  [ ! -z "${AWSENV_PREV_AWS_PAGER}" ] && AWS_PAGER="${AWSENV_PREV_AWS_PAGER}" || true
  [ ! -z "${AWSENV_PREV_AWS_PROFILE}" ] && AWS_PROFILE="${AWSENV_PREV_AWS_PROFILE}" || true
  [ ! -z "${AWSENV_PREV_AWS_ROLE_SESSION_NAME}" ] && AWS_ROLE_SESSION_NAME="${AWSENV_PREV_AWS_ROLE_SESSION_NAME}" || true
  [ ! -z "${AWSENV_PREV_AWS_SECRET_ACCESS_KEY}" ] && AWS_SECRET_ACCESS_KEY="${AWSENV_PREV_AWS_SECRET_ACCESS_KEY}" || true
  [ ! -z "${AWSENV_PREV_AWS_SESSION_TOKEN}" ] && AWS_SESSION_TOKEN="${AWSENV_PREV_AWS_SESSION_TOKEN}" || true
  [ ! -z "${AWSENV_PREV_AWS_SHARED_CREDENTIALS_FILE}" ] && AWS_SHARED_CREDENTIALS_FILE="${AWSENV_PREV_AWS_SHARED_CREDENTIALS_FILE}" || true
  set +o allexport
}

_awsenv_clear() {
  _awsenv_unset_aws
  _awsenv_unset_previous
}

# Load or unload .awsenv
_awsenv_execute() {
  local awsenv_path
  awsenv_path="$(_awsenv_find_awsenv)"
  if [ -e "$awsenv_path" ]; then
    if [ -z "${AWSENV_ACTIVE}" ]; then
      _awsenv_save_vars
    fi
    source <(cat "$awsenv_path" | grep "^AWS_")
    export AWSENV_ACTIVE=1
  else
    if [ ! -z "${AWSENV_ACTIVE}" ]; then
      _awsenv_unset_aws
      _awsenv_load_vars
      _awsenv_unset_previous
      unset AWSENV_ACTIVE
    fi
  fi
}

alias awsenv=_awsenv_execute
alias awsenvclr=_awsenv_clear
