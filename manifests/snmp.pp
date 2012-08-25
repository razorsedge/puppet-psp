# == Class: psp::snmp
#
# This class inherits and overrides snmp::server.
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class psp::snmp inherits snmp::server {
  File['snmpd.conf'] {
    mode    => '0660',
    group   => 'hpsmh',
    source  => undef,
    content => undef,
  }
}
