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
  go install golang.org/x/tools/gopls@latest
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
#>
######################################################################
p6df::modules::go::langs() {

  p6df::modules::go::langs::pull
  p6df::modules::go::langs::nuke
  p6df::modules::go::langs::install
  p6df::modules::go::langs::packages

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::go::init(_module, dir)
#
#  Args:
#	_module -
#	dir -
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::go::init() {
  local _module="$1"
  local dir="$2"

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

  # https://maelvls.dev/go111module-everywhere/

  local str
  str="goenv_root:\t  $GOENV_ROOT
gopath:\t\t  $GOPATH
goroot:\t\t  $GOROOT"

  p6_return_str "$str"
}
