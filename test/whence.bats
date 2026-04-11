#!/usr/bin/env bats

load test_helper

create_executable() {
  local bin="${PHPENV_ROOT}/versions/${1}/bin"
  mkdir -p "$bin"
  touch "${bin}/$2"
  chmod +x "${bin}/$2"
}

@test "finds versions where present" {
 create_executable "7.4.33" "php"
 create_executable "7.4.33" "pecl"
 create_executable "8.2.10" "php"
 create_executable "8.2.10" "phar"

 run phpenv-whence php
 assert_success
 assert_output <<OUT
7.4.33
8.2.10
OUT

 run phpenv-whence pecl
 assert_success "7.4.33"

 run phpenv-whence phar
 assert_success "8.2.10"
}
