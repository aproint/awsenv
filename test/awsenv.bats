#!/usr/bin/env bats

source ../awsenv.sh

harness_dir="${BATS_TEST_DIRNAME}/harness"

@test "find a file in the current dir" {
  cd "${harness_dir}/1"
  run _awsenv_find_up '.awsenv'
  [ "$status" -eq 0 ]
  [ "$output" = "${harness_dir}/1" ]
}

@test "find a file a level up" {
  cd "${harness_dir}/2/3"
  run _awsenv_find_up '.awsenv'
  [ "$status" -eq 0 ]
  [ "$output" = "${harness_dir}/2" ]
}

@test "find .awsenv file" {
  cd "${harness_dir}/2/3"
  run _awsenv_find_awsenv
  [ "$status" -eq 0 ]
  [ "$output" = "${harness_dir}/2/.awsenv" ]
}

@test "save AWS env vars" {
  AWS_ACCESS_KEY_ID="access_key"
  AWS_CA_BUNDLE="ca_budle"
  AWS_CONFIG_FILE="config_file"
  AWS_DEFAULT_OUTPUT="default_output"
  AWS_DEFAULT_REGION="default_region"
  AWS_PAGER="pager"
  AWS_PROFILE="profile"
  AWS_ROLE_SESSION_NAME="role_session_name"
  AWS_SECRET_ACCESS_KEY="secret_access_key"
  AWS_SESSION_TOKEN="session_token"
  AWS_SHARED_CREDENTIALS_FILE="shared_credentials_file"
  _awsenv_save_vars
  [ "$AWSENV_PREV_AWS_ACCESS_KEY_ID" = "access_key" ]
  [ "$AWSENV_PREV_AWS_CA_BUNDLE" = "ca_budle" ]
  [ "$AWSENV_PREV_AWS_CONFIG_FILE" = "config_file" ]
  [ "$AWSENV_PREV_AWS_DEFAULT_OUTPUT" = "default_output" ]
  [ "$AWSENV_PREV_AWS_DEFAULT_REGION" = "default_region" ]
  [ "$AWSENV_PREV_AWS_PAGER" = "pager" ]
  [ "$AWSENV_PREV_AWS_PROFILE" = "profile" ]
  [ "$AWSENV_PREV_AWS_ROLE_SESSION_NAME" = "role_session_name" ]
  [ "$AWSENV_PREV_AWS_SECRET_ACCESS_KEY" = "secret_access_key" ]
  [ "$AWSENV_PREV_AWS_SESSION_TOKEN" = "session_token" ]
  [ "$AWSENV_PREV_AWS_SHARED_CREDENTIALS_FILE" = "shared_credentials_file" ]
}

@test "load previous AWS env vars" {
  AWSENV_PREV_AWS_ACCESS_KEY_ID="access_key"
  AWSENV_PREV_AWS_CA_BUNDLE="ca_budle"
  AWSENV_PREV_AWS_CONFIG_FILE="config_file"
  AWSENV_PREV_AWS_DEFAULT_OUTPUT="default_output"
  AWSENV_PREV_AWS_DEFAULT_REGION="default_region"
  AWSENV_PREV_AWS_PAGER="pager"
  AWSENV_PREV_AWS_PROFILE="profile"
  AWSENV_PREV_AWS_ROLE_SESSION_NAME="role_session_name"
  AWSENV_PREV_AWS_SECRET_ACCESS_KEY="secret_access_key"
  AWSENV_PREV_AWS_SESSION_TOKEN="session_token"
  AWSENV_PREV_AWS_SHARED_CREDENTIALS_FILE="shared_credentials_file"
  _awsenv_load_vars
  [ "$AWS_ACCESS_KEY_ID" = "access_key" ]
  [ "$AWS_CA_BUNDLE" = "ca_budle" ]
  [ "$AWS_CONFIG_FILE" = "config_file" ]
  [ "$AWS_DEFAULT_OUTPUT" = "default_output" ]
  [ "$AWS_DEFAULT_REGION" = "default_region" ]
  [ "$AWS_PAGER" = "pager" ]
  [ "$AWS_PROFILE" = "profile" ]
  [ "$AWS_ROLE_SESSION_NAME" = "role_session_name" ]
  [ "$AWS_SECRET_ACCESS_KEY" = "secret_access_key" ]
  [ "$AWS_SESSION_TOKEN" = "session_token" ]
  [ "$AWS_SHARED_CREDENTIALS_FILE" = "shared_credentials_file" ]
}

@test "execute .awsenv file" {
  cd "${harness_dir}/1"
  _awsenv_execute
  [ "$AWSENV_ACTIVE" -eq 1 ]
  [ "$AWS_PROFILE" = "1" ]
  cd "${harness_dir}"
  _awsenv_execute
  [ -z "$AWSENV_ACTIVE" ]
  [ -z "$AWS_PROFILE" ]
  [ -z "$AWSENV_PREV_AWS_PROFILE" ]
}

@test "execute .awsenv file with a pre-existing AWS_PROFILE" {
  AWS_PROFILE="test"
  cd "${harness_dir}/1"
  _awsenv_execute
  [ "$AWSENV_ACTIVE" -eq 1 ]
  [ "$AWS_PROFILE" = "1" ]
  [ "$AWSENV_PREV_AWS_PROFILE" = "test" ]
  cd "${harness_dir}"
  _awsenv_execute
  [ -z "$AWSENV_ACTIVE" ]
  [ "$AWS_PROFILE" = "test" ]
  [ -z "$AWSENV_PREV_AWS_PROFILE" ]
}

@test "switch between child and parent .awsenv directories" {
  AWS_PROFILE="test"
  cd "${harness_dir}/2/4"
  _awsenv_execute
  [ "$AWSENV_ACTIVE" -eq 1 ]
  [ "$AWS_PROFILE" = "4" ]
  [ "$AWSENV_PREV_AWS_PROFILE" = "test" ]
  cd "${harness_dir}/2"
  _awsenv_execute
  [ "$AWSENV_ACTIVE" -eq 1 ]
  [ "$AWS_PROFILE" = "2" ]
  [ "$AWSENV_PREV_AWS_PROFILE" = "test" ]
}
