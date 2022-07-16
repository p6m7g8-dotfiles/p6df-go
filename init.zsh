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
#  Depends:	 p6_file p6_string
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

  (
    p6_dir_cd $P6_DFZ_SRC_DIR/syndbg/goenv
    p6_git_p6_pull
  )

  # nuke the old one
  local previous=$(goenv install -l | tail -2 | head -1 | sed -e 's, *,,g')
  goenv uninstall -f $previous

  # get the shiny one
  local latest=$(goenv install -l | grep -v 1.18 | tail -1 | sed -e 's, *,,g')
  goenv install $latest
  goenv global $latest
  goenv rehash

  go get -u -v github.com/mdempsky/gocode
  go get -u -v github.com/uudashr/gopkgs/cmd/gopkgs
  go get -u -v github.com/ramya-rao-a/go-outline
  go get -u -v github.com/acroca/go-symbols
  go get -u -v golang.org/x/tools/cmd/guru
  go get -u -v golang.org/x/tools/cmd/gorename
  go get -u -v github.com/fatih/gomodifytags
  go get -u -v github.com/haya14busa/goplay/cmd/goplay
  go get -u -v github.com/josharian/impl
  go get -u -v github.com/tylerb/gotype-live
  go get -u -v github.com/rogpeppe/godef
  go get -u -v github.com/zmb3/gogetdoc
  go get -u -v golang.org/x/tools/cmd/goimports
  go get -u -v github.com/sqs/goreturns
  go get -u -v winterdrache.de/goformat/goformat
  go get -u -v golang.org/x/lint/golint
  go get -u -v github.com/cweill/gotests/...
  go get -u -v github.com/alecthomas/gometalinter
  go get -u -v honnef.co/go/tools/...
  go get -u -v github.com/mgechev/revive
  go get -u -v github.com/sourcegraph/go-langserver
  go get -u -v github.com/go-delve/delve/cmd/dlv
  go get -u -v github.com/davidrjenni/reftools/cmd/fillstruct
  go get -u -v github.com/godoctor/godoctor

  go get -u -v golang.org/x/tools/cmd/godoc
  go get -u -v github.com/stretchr/testify
  go get -u -v github.com/golang/lint/golint
  go get -u -v gopkg.in/check.v1

  go get -u github.com/golangci/golangci-lint/cmd/golangci-lint
  goenv rehash
  (
    p6_dir_cd $P6_DFZ_SRC_DIR/github.com/golangci/golangci-lint/cmd/golangci-lint
    go install -ldflags "-X 'main.version=$(git describe --tags)' -X 'main.commit=$(git rev-parse --short HEAD)' -X 'main.date=$(date)'"
  )
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
#  Depends:	 p6_string
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
#  Depends:	 p6_string
#  Environment:	 GOPATH GOROOT
#>
######################################################################
p6_go_env_prompt_info() {

  local str
  if ! p6_string_blank "$GOPATH"; then
    str="gopath:\t\t  $GOPATH
goroot:\t\t  $GOROOT"
  fi

  p6_return_str "$str"
}
