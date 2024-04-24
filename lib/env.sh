# shellcheck shell=bash
######################################################################
#<
#
# Function: p6df::modules::go::goenv::latest()
#
#>
######################################################################
p6df::modules::go::goenv::latest() {

  goenv install -l | p6_filter_row_select "1.2" | p6_filter_row_last "1" | p6_filter_spaces_strip
}

######################################################################
#<
#
# Function: p6df::modules::go::goenv::latest::installed()
#
#>
######################################################################
p6df::modules::go::goenv::latest::installed() {

  goenv install -l | p6_filter_row_from_end "2" | p6_filter_spaces_strip
}
