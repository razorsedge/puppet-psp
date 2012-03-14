# Class: snmpd
#
# This class manages snmpd.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class psp::snmpd inherits ::snmpd {
  File["snmpd.conf"] {
    mode    => "660",
    group   => "hpsmh",
    source  => undef,
    content => undef,
  }
}
