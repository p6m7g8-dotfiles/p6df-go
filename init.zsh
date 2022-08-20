# shellcheck shell=bash
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

  p6_return_void
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

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::go::langs()
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::go::langs() {

  p6_run_dir "$P6_DFZ_SRC_DIR/syndbg/goenv" "p6_git_p6_pull"

  # nuke the old one
  local previous=$(p6df::modules::go::goenv::latest::installed)
  goenv uninstall -f $previous

  # get the shiny one
  local latest=$(p6df::modules::go::goenv::latest)
  goenv install $latest
  goenv global $latest
  goenv rehash

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::go::goenv::latest()
#
#>
######################################################################
p6df::modules::go::goenv::latest() {

  goenv install -l | p6_filter_select "1.18" | p6_filter_last "1" | p6_filter_spaces_strip
}

######################################################################
#<
#
# Function: p6df::modules::go::goenv::latest::installed()
#
#>
######################################################################
p6df::modules::go::goenv::latest::installed() {

  goenv install -l | p6_filter_from_end "2" | p6_filter_spaces_strip
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

  p6df::core::lang::mgr::init "$P6_DFZ_SRC_DIR/syndbg/goenv" "go"

  p6_return_void
}

######################################################################
#<
#
# Function: str str = p6df::modules::go::env::prompt::info()
#
#  Returns:
#	str - str
#
#  Environment:	 GOENV_ROOT GOPATH GOROOT
#>
######################################################################
p6df::modules::go::env::prompt::info() {

  local str
  str="goenv_root:\t  $GOENV_ROOT
gopath:\t\t  $GOPATH
goroot:\t\t  $GOROOT"

  p6_return_str "$str"
}
