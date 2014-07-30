# == Class: psp
#
# This class handles installation of the HP Proliant Support Pack.
#
# === Parameters:
#
# [*smh_gid*]
#   The group ID of the SMH user.
#   Default: 490
#
# [*smh_uid*]
#   The user ID of the SMH user.
#   Default: 490
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
#
# [*yum_server*]
#   Servername where the repo is
#   Default: 'http://downloads.linux.hp.com'
#
# [*yum_os*]
#   OS-Name for the Repopath
#   Default: Depending on the OS
#
# [*yum_path*]
#   Path on the Server to the repos
#   Default: '/SDR/downloads/proliantsupportpack'
#
# [*yum_priority*]
#   
#   Default: '50'
#
# [*yum_project*]
#   
#   Default: '0'
#
# === Actions:
#
# Installs the SMH user and group as well as the YUM repository.
#
# === Requires:
#
# Nothing.
#
# === Sample Usage:
#
#   class { 'psp': }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class psp (
  $ensure       = 'present',
  $smh_gid      = $psp::params::gid,
  $smh_uid      = $psp::params::uid,
  $yum_server   = $psp::params::yum_server,
  $yum_os       = $psp::params::yum_os,
  $yum_path     = $psp::params::yum_path,
  $yum_priority = $psp::params::yum_priority,
  $yum_project  = $psp::params::yum_project,
) inherits psp::params {

  case $ensure {
    /(present)/: {
      $user_ensure = 'present'
    }
    /(absent)/: {
      $user_ensure = 'absent'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  case $::manufacturer {
    'HP': {
      @group { 'hpsmh':
        ensure => $user_ensure,
        gid    => $smh_gid,
      }

      @user { 'hpsmh':
        ensure => $user_ensure,
        uid    => $smh_uid,
        gid    => 'hpsmh',
        home   => '/opt/hp/hpsmh',
        shell  => '/sbin/nologin',
      }

      yumrepo { 'HP-psp':
        descr    => 'HP Software Delivery Repository for Proliant Support Pack',
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => "${yum_server}${yum_path}/GPG-KEY-ProLiantSupportPack",
        baseurl  => "${yum_server}${yum_path}/${yum_os}/\$releasever/packages/\$basearch/",
        priority => $yum_priority,
        protect  => $yum_protect,
      }
    }
    # If we are not on HP hardware, do not do anything.
    default: { }
  }
}
