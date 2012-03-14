# Class: psp::hpdiags
#
# This class manages hpdiags.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class psp::hpdiags {
  package { "hpdiags":
    ensure  => "present",
    name    => "hpdiags",
    require => Package["hpsmh"],
  }
}
