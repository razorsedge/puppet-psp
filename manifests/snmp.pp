# Class: psp::snmp
#
# This class manages snmp.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class psp::snmp inherits snmp::server {
  File['snmpd.conf'] {
    mode    => '0660',
    group   => 'hpsmh',
    source  => undef,
    content => undef,
  }
}
