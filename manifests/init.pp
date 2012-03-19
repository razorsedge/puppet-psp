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
    "HP": {
      group { "hpsmh":
        ensure => "present",
        gid    => $psp::params::gid,
      }

      user { "hpsmh":
        ensure => "present",
        uid    => $psp::params::uid,
        gid    => "hpsmh",
        home   => "/opt/hp/hpsmh",
        shell  => "/sbin/nologin",
      }

#      Yumrepo {
#        descr    => "HP Software Delivery Repository for Proliant Support Pack",
#        enabled  => 1,
#        gpgkey   => "http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/GPG-KEY-ProLiantSupportPack",
#        gpgcheck => 1,
#        priority => 50,
#        protect  => 0,
#        #require  => [ Package["yum-priorities"], Package["yum-protectbase"], ],
#      }
#
#      case $::operatingsystem {
#        CentOS: {
#          yumrepo { "HP-psp":
#            baseurl  => "http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/CentOS/\$releasever/packages/\$basearch/",
#          }
#        }
#        OracleLinux, OEL: {
#          yumrepo { "HP-psp":
#            baseurl  => "http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/Oracle/\$releasever/packages/\$basearch/",
#          }
#        }
#        RedHat: {
#          yumrepo { "HP-psp":
#            baseurl  => "http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/RedHat/\$releasever/packages/\$basearch/",
#          }
#        }
#        default: {
#          fail("${::hostname}: This module does not support operatingsystem ${::operatingsystem}")
#        }
#      }

      yumrepo { "HP-psp":
        descr    => "HP Software Delivery Repository for Proliant Support Pack",
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => "http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/GPG-KEY-ProLiantSupportPack",
        baseurl  => "http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/${psp::params::yum_operatingsystem}/\$releasever/packages/\$basearch/",
        priority => $psp::params::yum_priority,
        protect  => $psp::params::yum_protect,
       #require  => [ Package["yum-priorities"], Package["yum-protectbase"], ],
      }

      include psp::params
      include psp::hpsmh
      include psp::hpsnmp
      include psp::hphealth
      include psp::hpvca
    }
    default: { }
  }
}
