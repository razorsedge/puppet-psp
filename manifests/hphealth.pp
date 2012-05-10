# == Class: psp::hphealth
#
# This class handles installation of the HP Proliant Support Pack Health Agent.
#
# === Parameters:
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
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
# Installs the HP System Health Application and Command Line Utilities.
# Installs the RILOE II/iLO online configuration utility.
# Installs the HP Command Line Array Configuration Utility.
# Installs OpenIPMI drivers and/or HP iLO Channel Interface Driver dependent
# upon OS version.
#
# === Requires:
#
# Class['psp']
#
# === Sample Usage:
#
#   class { 'psp::hphealth': }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class psp::hphealth (
  $ensure         = 'present',
  $autoupgrade    = false,
  $service_ensure = 'running',
  $service_enable = true
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
      #Package { require => Class['psp'], }
      include psp

      package { 'hp-OpenIPMI':
        ensure => $package_ensure,
        name   => $psp::params::ipmi_name,
      }

      package { 'hponcfg':
        ensure => $package_ensure,
      }

      package { 'hp-health':
        ensure => $package_ensure,
      }

      package { 'hpacucli':
        ensure => $package_ensure,
      }

      package { 'hp-ilo':
        ensure => $psp::params::ilo_package_ensure,
      }

      service { 'hp-ilo':
        ensure     => $psp::params::ilo_service_ensure,
        enable     => $psp::params::ilo_service_enable,
        hasrestart => true,
        hasstatus  => true,
        require    => Package['hp-ilo'],
      }

      service { 'hp-health':
        ensure     => $service_ensure_real,
        enable     => $service_enable_real,
        hasrestart => true,
        hasstatus  => true,
        require    => [ Package['hp-health'], Package['hp-OpenIPMI'], ],
      }
    }
    # If we are not on HP hardware, do not do anything.
    default: { }
  }
}
