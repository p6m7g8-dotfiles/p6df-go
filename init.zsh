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
#  Environment:	 GOPATH P6_DFZ_SRC_DIR P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::modules::go::home::symlink() {

  if ! p6_string_blank "$GOPATH"; then
    p6_file_symlink "$P6_DFZ_SRC_DIR" "$GOPATH/src"
  fi

  p6_file_symlink "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-go/share/.goenvrc" ".goenvrc"

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

  p6_bootstrap "$dir"

  p6df::core::lang::mgr::init "$P6_DFZ_SRC_DIR/syndbg/goenv" "go"

  p6_return_void
}

######################################################################
#<
#
# Function: str str = p6df::modules::go::prompt::env()
#
#  Returns:
#	str - str
#
#  Environment:	 GOPATH
#>
######################################################################
p6df::modules::go::prompt::env() {

  # https://maelvls.dev/go111module-everywhere/

#  local str
#  str="goenv_root:\t  $GOENV_ROOT
#  goroot:\t\t  $GOROOT"

   local str="gopath:\t\t  $GOPATH"

  p6_return_str "$str"
}

######################################################################
#<
#
# Function: p6df::modules::go::prompt::lang()
#
#>
######################################################################
p6df::modules::go::prompt::lang() {

  local ver

  local ver_mgr
  ver_mgr=$(goenv version-name 2>/dev/null)
  if p6_string_eq "$ver_mgr" "system"; then
    local ver_sys="sys@"
    local v
    v=$(go version 2>/dev/null| awk '{print $3}' | sed -e 's,^go,,')
    if p6_string_blank "$v"; then
      ver_sys="sys:no"
    fi
    ver="$ver_sys"
  else
    ver="$ver_mgr"
  fi

  local str="go:$ver"

  p6_return "$str"
}
