# Class: psp::base
#
# This class handles installation of the hpsmh user and group as well as the YUM repository.
#
# Parameters:
#
# Actions:
#
# Requires:
#   $::operatingsystem - fact
#
# Sample Usage:
#
class psp::base {
  group { "hpsmh":
    ensure => "present",
    gid    => "490",
  }
  
  user { "hpsmh":
    ensure => "present",
    uid    => "490",
    gid    => "hpsmh",
    home   => "/opt/hp/hpsmh",
    shell  => "/sbin/nologin",
  }

  case $::operatingsystem {
    CentOS: {
      yumrepo { "HP-psp":
        descr    => "HP Software Delivery Repository for Proliant Support Pack",
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => "http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/GPG-KEY-ProLiantSupportPack",
        baseurl  => "http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/CentOS/\$releasever/packages/\$basearch/",
        priority => 50,
        protect  => 0,
       #require  => [ Package["yum-priorities"], Package["yum-protectbase"], ],
      }
    }
    OracleLinux, OEL: {
      yumrepo { "HP-psp":
        descr    => "HP Software Delivery Repository for Proliant Support Pack",
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => "http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/GPG-KEY-ProLiantSupportPack",
        baseurl  => "http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/Oracle/\$releasever/packages/\$basearch/",
        priority => 50,
        protect  => 0,
       #require  => [ Package["yum-priorities"], Package["yum-protectbase"], ],
      }
    }
    RedHat: {
      yumrepo { "HP-psp":
        descr    => "HP Software Delivery Repository for Proliant Support Pack",
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => "http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/GPG-KEY-ProLiantSupportPack",
        baseurl  => "http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/RedHat/\$releasever/packages/\$basearch/",
        priority => 50,
        protect  => 0,
       #require  => [ Package["yum-priorities"], Package["yum-protectbase"], ],
      }
    }
    default: {
      fail("${::hostname}: This module does not support operatingsystem ${::operatingsystem}")
    }
  }
}
