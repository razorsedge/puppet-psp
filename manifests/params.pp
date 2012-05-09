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
      $vca_ensure = 'absent'
      case $::operatingsystemrelease {
        /4.*/: {
          $ipmi_name = 'hp-OpenIPMI'
          $ilo_package_ensure = 'present'
          $ilo_service_ensure = 'running'
          $ilo_service_enable = true
        }
        /5.[0-2]*/: {
          $ipmi_name = 'hp-OpenIPMI'
          $ilo_package_ensure = 'present'
          $ilo_service_ensure = 'running'
          $ilo_service_enable = true
        }
        /5.[3-4]*/: {
          $ipmi_name = 'hp-OpenIPMI'
          $ilo_package_ensure = 'absent'
          $ilo_service_ensure = undef
          $ilo_service_enable = undef
        }
        default: {
          $ipmi_name = 'OpenIPMI'
          $ilo_package_ensure = 'absent'
          $ilo_service_ensure = undef
          $ilo_service_enable = undef
        }
      }
    }
    'OracleLinux', 'OEL': {
      $yum_os = 'Oracle'
      $vca_ensure = 'absent'
      case $::operatingsystemrelease {
        /4.*/: {
          $ipmi_name = 'hp-OpenIPMI'
          $ilo_package_ensure = 'present'
          $ilo_service_ensure = 'running'
          $ilo_service_enable = true
        }
        /5.[0-2]*/: {
          $ipmi_name = 'hp-OpenIPMI'
          $ilo_package_ensure = 'present'
          $ilo_service_ensure = 'running'
          $ilo_service_enable = true
        }
        /5.[3-4]*/: {
          $ipmi_name = 'hp-OpenIPMI'
          $ilo_package_ensure = 'absent'
          $ilo_service_ensure = undef
          $ilo_service_enable = undef
        }
        default: {
          $ipmi_name = 'OpenIPMI'
          $ilo_package_ensure = 'absent'
          $ilo_service_ensure = undef
          $ilo_service_enable = undef
        }
      }
    }
    'RedHat': {
      $yum_os = 'RedHat'
      $vca_ensure = 'present'
      case $::operatingsystemrelease {
        /4.*/: {
          $ipmi_name = 'hp-OpenIPMI'
          $ilo_package_ensure = 'present'
          $ilo_service_ensure = 'running'
          $ilo_service_enable = true
        }
        /5.[0-2]*/: {
          $ipmi_name = 'hp-OpenIPMI'
          $ilo_package_ensure = 'present'
          $ilo_service_ensure = 'running'
          $ilo_service_enable = true
        }
        /5.[3-4]*/: {
          $ipmi_name = 'hp-OpenIPMI'
          $ilo_package_ensure = 'absent'
          $ilo_service_ensure = undef
          $ilo_service_enable = undef
        }
        default: {
          $ipmi_name = 'OpenIPMI'
          $ilo_package_ensure = 'absent'
          $ilo_service_ensure = undef
          $ilo_service_enable = undef
        }
      }
    }
    default: {
      fail("Module psp is not supported on ${::operatingsystem}")
    }
  }
}
