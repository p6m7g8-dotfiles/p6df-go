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
# Function: p6df::modules::go::langs::pull()
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::go::langs::pull() {

  p6_run_dir "$P6_DFZ_SRC_DIR/syndbg/goenv" "p6_git_p6_pull"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::go::langs::nuke()
#
#>
######################################################################
p6df::modules::go::langs::nuke() {

  # nuke the old one
  local previous=$(p6df::modules::go::goenv::latest::installed)
  goenv uninstall -f $previous

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::go::langs::install()
#
#>
######################################################################
p6df::modules::go::langs::install() {

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
# Function: p6df::modules::go::langs::packages()
#
#>
######################################################################
p6df::modules::go::langs::packages() {

  go install github.com/spf13/cobra-cli@latest
  go install github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest
  go install github.com/ramya-rao-a/go-outline@latest
  go install github.com/cweill/gotests/...@latest
  go install github.com/mgechev/revive@master

  go install golang.org/x/tools/cmd/guru@latest
  go install golang.org/x/tools/cmd/goimports@latest

  go install honnef.co/go/tools/cmd/staticcheck@latest

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

  goenv install -l | p6_filter_select "1.2" | p6_filter_last "1" | p6_filter_spaces_strip
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

  # https://maelvls.dev/go111module-everywhere/

  local str
  str="goenv_root:\t  $GOENV_ROOT
gopath:\t\t  $GOPATH
goroot:\t\t  $GOROOT"

  p6_return_str "$str"
}
