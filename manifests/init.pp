# Class: psp
#
# This module handles installation of the HP Proliant Support Pack version 8.60.
#
# Parameters:
#
# Actions:
#
# Requires:
#   $::manufacturer    - fact
#   $::operatingsystem - fact
#
# Sample Usage:
#
class psp {
  case $::manufacturer {
    'HP': {
      include psp::params
      Class['psp'] -> Class['psp::hpsmh'] -> Class['psp::hpsnmp'] -> Class['psp::hphealth'] -> Class['psp::hpvca']

      group { 'hpsmh':
        ensure => 'present',
        gid    => $psp::params::gid,
      }

      user { 'hpsmh':
        ensure => 'present',
        uid    => $psp::params::uid,
        gid    => 'hpsmh',
        home   => '/opt/hp/hpsmh',
        shell  => '/sbin/nologin',
      }

      yumrepo { 'HP-psp':
        descr    => 'HP Software Delivery Repository for Proliant Support Pack',
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => "${psp::params::yum_server}${psp::params::yum_path}/GPG-KEY-ProLiantSupportPack",
        baseurl  => "${psp::params::yum_server}${psp::params::yum_path}/${psp::params::yum_operatingsystem}/\$releasever/packages/\$basearch/",
        priority => $psp::params::yum_priority,
        protect  => $psp::params::yum_protect,
      }

      include psp::hpsmh
      include psp::hpsnmp
      include psp::hphealth
      include psp::hpvca
    }
    # If we are not on HP hardware, do not do anything.
    default: { }
  }
}
