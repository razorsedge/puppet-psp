# Class: psp
#
# This module handles installation of the HP Proliant Support Pack version 8.60.
#
# Parameters:
#
# Actions:
#
# Requires:
#   $manufacturer: This fact must be 'HP'.
#
# Sample Usage:
#
class psp {
  case $manufacturer {
    HP: {
      include psp::base
      #include psp::hpdiags
      include psp::hpsmh
      include psp::hpsnmp
      include psp::hphealth
      include psp::hpvca
    }
    default: { }
  }
}

