# == Class: psp::params
#
# This class handles OS-specific configuration of the psp module.
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class psp::params {
  $gid          = '490'
  $uid          = '490'
  $yum_server   = 'http://downloads.linux.hp.com'
  $yum_path     = '/SDR/downloads/proliantsupportpack'
  $yum_priority = '50'
  $yum_protect  = '0'

  case $::operatingsystem {
    'CentOS': {
      $yum_os = 'CentOS'
    }
    'OracleLinux', 'OEL': {
      $yum_os = 'Oracle'
    }
    'RedHat': {
      $yum_os = 'RedHat'
    }
    default: {
      fail("Module psp is not supported on ${::operatingsystem}")
    }
  }
}
