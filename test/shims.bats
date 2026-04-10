#!/usr/bin/env bats

load test_helper

@test "no shims" {
  run phpenv-shims
  assert_success
  assert [ -z "$output" ]
}

@test "shims" {
  mkdir -p "${PHPENV_ROOT}/shims"
  touch "${PHPENV_ROOT}/shims/php"
  touch "${PHPENV_ROOT}/shims/pear"
  run phpenv-shims
  assert_success
  assert_line "${PHPENV_ROOT}/shims/php"
  assert_line "${PHPENV_ROOT}/shims/pear"
}

@test "shims --short" {
  mkdir -p "${PHPENV_ROOT}/shims"
  touch "${PHPENV_ROOT}/shims/php"
  touch "${PHPENV_ROOT}/shims/pear"
  run phpenv-shims --short
  assert_success
  assert_line "php"
  assert_line "pear"
}
