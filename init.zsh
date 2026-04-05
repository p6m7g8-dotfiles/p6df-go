# shellcheck shell=bash
######################################################################
p6df::modules::go::deps() {
  ModuleDeps=(
    p6m7g8-dotfiles/p6common
    syndbg/goenv
    smallnest/goskills
    rohitg00/awesome-claude-code-toolkit:agents/language-experts/golang-developer.md
  )
}

######################################################################
p6df::modules::go::langmgr::init() {

  p6df::core::lang::mgr::init "$P6_DFZ_SRC_DIR/syndbg/goenv" "go"

  p6_return_void
}

######################################################################
p6df::modules::go::home::symlinks() {

  if p6_string_blank_NOT "$GOPATH"; then
    p6_file_symlink "$P6_DFZ_SRC_DIR" "$GOPATH/src"
  fi

  p6_file_symlink "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-go/share/.goenvrc" "$HOME/.goenvrc"

  p6_file_symlink "$P6_DFZ_SRC_DIR/smallnest/goskills"  "$HOME/.claude/skills/goskills"

  p6_return_void
}

######################################################################
p6df::modules::go::langs() {

  p6df::modules::go::langs::pull
  p6df::modules::go::langs::nuke
  p6df::modules::go::langs::install
  p6df::modules::go::langs::packages

  p6_return_void
}

######################################################################
p6df::modules::go::vscodes() {

  # go
  go install golang.org/x/tools/gopls@latest
  p6df::modules::vscode::extension::install golang.go

  p6_return_void
}

######################################################################
p6df::modules::go::vscodes::config() {

  cat <<'EOF'
  "[go]": {
    "editor.defaultFormatter": "golang.go"
  },
  "editor.codeActionsOnSave": {
    "go.generateTests": "always",
    "go.test": "always",
    "go.build": "always",
    "go.vet": "always"
  },
  "go.formatTool": "goimports",
  "go.installDependenciesWhenBuilding": false,
  "go.lintOnSave": "workspace",
  "go.lintTool": "staticcheck",
  "go.toolsManagement.autoUpdate": true,
  "go.useLanguageServer": true,
  "go.vetOnSave": "workspace"
EOF

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::go::deps()
#
#>
######################################################################
#<
#
# Function: p6df::modules::go::vscodes()
#
#>
######################################################################
#<
#
# Function: p6df::modules::go::vscodes::config()
#
#>
######################################################################
#<
#
# Function: p6df::modules::go::home::symlinks()
#
#  Environment:	 GOPATH HOME P6_DFZ_SRC_DIR P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
#<
#
# Function: p6df::modules::go::langs()
#
#>
######################################################################
#<
#
# Function: p6df::modules::go::langmgr::init()
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
#<
#
# Function: str str = p6df::modules::go::prompt::lang()
#
#  Returns:
#	str - str
#
#>
######################################################################
p6df::modules::go::prompt::lang() {

  local str
  str=$(p6df::core::lang::prompt::lang \
    "go" \
    "goenv version-name 2>/dev/null" \
    "go version | p6_filter_column_pluck 3 | p6_filter_strip_leading_go")

  p6_return_str "$str"
}

######################################################################
#<
#
# Function: words go $GOPATH = p6df::modules::go::prompt::env()
#
#  Returns:
#	words - go $GOPATH
#
#  Environment:	 GOPATH
#>
######################################################################
p6df::modules::go::prompt::env() {

  p6_return_words 'go' '$GOPATH'
}
