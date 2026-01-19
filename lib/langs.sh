# shellcheck shell=bash
######################################################################
#<
#
# Function: p6df::modules::go::langs::pull()
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::go::langs::pull() {

  p6_run_dir "$P6_DFZ_SRC_DIR/syndbg/goenv" "p6_git_cli_pull_rebase_autostash_ff_only"

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
  goenv uninstall -f "$previous"

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
  goenv install "$latest"
  goenv global "$latest"
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
