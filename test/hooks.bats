#!/usr/bin/env bats

load test_helper

@test "prints usage help given no argument" {
  run phpenv-hooks
  assert_failure
}

@test "prints list of hooks" {
  path1="${PHPENV_TEST_DIR}/phpenv.d"
  path2="${PHPENV_TEST_DIR}/etc/phpenv_hooks"
  PHPENV_HOOK_PATH="$path1"
  create_hook exec "hello.bash"
  create_hook exec "ahoy.bash"
  create_hook exec "invalid.sh"
  create_hook which "boom.bash"
  PHPENV_HOOK_PATH="$path2"
  create_hook exec "bueno.bash"

  PHPENV_HOOK_PATH="$path1:$path2" run phpenv-hooks exec
  assert_success
  assert_output <<OUT
${PHPENV_TEST_DIR}/phpenv.d/exec/ahoy.bash
${PHPENV_TEST_DIR}/phpenv.d/exec/hello.bash
${PHPENV_TEST_DIR}/etc/phpenv_hooks/exec/bueno.bash
OUT
}

@test "support hook paths with spaces" {
  path1="${PHPENV_TEST_DIR}/my hooks/phpenv.d"
  path2="${PHPENV_TEST_DIR}/etc/phpenv hooks"
  PHPENV_HOOK_PATH="$path1"
  create_hook exec "hello.bash"
  PHPENV_HOOK_PATH="$path2"
  create_hook exec "ahoy.bash"

  PHPENV_HOOK_PATH="$path1:$path2" run phpenv-hooks exec
  assert_success
  assert_output <<OUT
${PHPENV_TEST_DIR}/my hooks/phpenv.d/exec/hello.bash
${PHPENV_TEST_DIR}/etc/phpenv hooks/exec/ahoy.bash
OUT
}

@test "does not resolve symlinks" {
  path="${PHPENV_TEST_DIR}/phpenv.d"
  mkdir -p "${path}/exec"
  mkdir -p "$HOME"
  touch "${HOME}/hola.bash"
  ln -s "../../home/hola.bash" "${path}/exec/hello.bash"
  touch "${path}/exec/bright.sh"
  ln -s "bright.sh" "${path}/exec/world.bash"

  PHPENV_HOOK_PATH="$path" run phpenv-hooks exec
  assert_success
  assert_output <<OUT
${PHPENV_TEST_DIR}/phpenv.d/exec/hello.bash
${PHPENV_TEST_DIR}/phpenv.d/exec/world.bash
OUT
}
