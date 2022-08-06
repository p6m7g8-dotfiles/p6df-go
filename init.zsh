######################################################################
#<
#
# Function: p6df::modules::go::deps()
#
#>
######################################################################
p6df::modules::go::deps() {
  ModuleDeps=(
    p6m7g8-dotfiles/p6common
    syndbg/goenv
  )
}

######################################################################
#<
#
# Function: p6df::modules::go::vscodes()
#
#>
######################################################################
p6df::modules::go::vscodes() {

  # go
  go get golang.org/x/tools/gopls
  code --install-extension golang.go
}

######################################################################
#<
#
# Function: p6df::modules::go::home::symlink()
#
#  Environment:	 GOPATH P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::go::home::symlink() {

  if ! p6_string_blank "$GOPATH"; then
    p6_file_symlink "$P6_DFZ_SRC_DIR" "$GOPATH/src"
  fi
}

######################################################################
#<
#
# Function: p6df::modules::go::langs()
#
#  Environment:	 HEAD P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::go::langs() {

  p6_run_dir "$P6_DFZ_SRC_DIR/syndbg/goenv" "p6_git_p6_pull"

  # nuke the old one
  local previous=$(goenv install -l | tail -2 | head -1 | sed -e 's, *,,g')
  goenv uninstall -f $previous

  # get the shiny one
  local latest=$(goenv install -l | grep 1.18 | tail -1 | sed -e 's, *,,g')
  goenv install $latest
  goenv global $latest
  goenv rehash
}

######################################################################
#<
#
# Function: p6df::modules::go::init()
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::go::init() {

  p6df::modules::go::goenv::init "$P6_DFZ_SRC_DIR"

  p6df::modules::go::prompt::init
}

######################################################################
#<
#
# Function: p6df::modules::go::prompt::init()
#
#>
######################################################################
p6df::modules::go::prompt::init() {

  p6df::core::prompt::line::add "p6_lang_prompt_info"
  p6df::core::prompt::line::add "p6_lang_envs_prompt_info"
  p6df::core::prompt::lang::line::add go
}

######################################################################
#<
#
# Function: p6df::modules::go::goenv::init(dir)
#
#  Args:
#	dir -
#
#  Environment:	 DISABLE_ENVS GOENV_ROOT GOPATH HAS_GOENV
#>
######################################################################
p6df::modules::go::goenv::init() {
  local dir="$1"

  [ -n "$DISABLE_ENVS" ] && return

  GOENV_ROOT=$dir/syndbg/goenv

  if [ -x $GOENV_ROOT/bin/goenv ]; then
    export GOENV_ROOT
    export HAS_GOENV=1

    p6_path_if $GOENV_ROOT/bin
    eval "$(p6_run_code goenv init - zsh)"
    p6_path_if $GOPATH/bin
  fi
}

######################################################################
#<
#
# Function: str str = p6_go_env_prompt_info()
#
#  Returns:
#	str - str
#
#  Environment:	 GOENV_ROOT GOPATH GOROOT
#>
######################################################################
p6_go_env_prompt_info() {

  local str
  str="goenv_root:\t  $GOENV_ROOT
gopath:\t\t  $GOPATH
goroot:\t\t  $GOROOT"

  p6_return_str "$str"
}
