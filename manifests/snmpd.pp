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
class psp::snmpd inherits ::snmp {
  File['snmpd.conf'] {
    mode    => '0660',
    group   => 'hpsmh',
    source  => undef,
    content => undef,
  }
}
