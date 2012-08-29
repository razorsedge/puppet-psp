# == Class: psp::hpvca
#
# This class handles installation of the HP Proliant Support Pack Version
# Control Agent.
#
# === Parameters:
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: auto-set, platform specific
#
# [*autoupgrade*]
#   Upgrade package automatically, if there is a newer version.
#   Default: false
#
# [*service_ensure*]
#   Ensure if service is running or stopped.
#   Default: running
#
# [*service_enable*]
#   Start service at boot.
#   Default: true
#
# === Actions:
#
# Installs the HP Version Control Agent.
#
# === Requires:
#
# Class['psp']
#
# === Sample Usage:
#
#   class { 'psp::hpvca': }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class psp::hpvca (
  $ensure             = $psp::params::vca_ensure,
  $autoupgrade        = false,
  $service_ensure     = 'running',
  $service_enable     = true
) inherits psp::params {

  case $ensure {
    /(present)/: {
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else {
        $package_ensure = 'present'
      }

      if $service_ensure in [ running, stopped ] {
        $service_ensure_real = $service_ensure
        $service_enable_real = $service_enable
      } else {
        fail('service_ensure parameter must be running or stopped')
      }
    }
    /(absent)/: {
      $package_ensure = 'absent'
      $service_ensure_real = 'stopped'
      $service_enable_real = false
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  case $::manufacturer {
    'HP': {
      Class['psp'] -> Class['psp::hpvca']

      package { 'hpvca':
        ensure => $package_ensure,
      }

      # TODO: file or exec for hpvca configuration?

      service { 'hpvca':
        ensure     => $service_ensure_real,
        enable     => $service_enable_real,
        hasrestart => true,
        hasstatus  => true,
        require    => Package['hpvca'],
      }
    }
    # If we are not on HP hardware, do not do anything.
    default: { }
  }
}
