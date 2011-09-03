# Class: psp::base
#
# This module handles installation of the HP Proliant Support Pack.
#
# Parameters:
#
# Actions:
#
# Requires:
#   $operatingsystem - fact
#
# Sample Usage:
#
class psp::base {
  group { "hpsmh":
    ensure => "present",
    gid    => "490",
  }
  
  user { "hpsmh":
    ensure  => "present",
    uid     => "490",
    gid     => "hpsmh",
    home    => "/opt/hp/hpsmh",
    shell   => "/sbin/nologin",
  }
  
#  package {
#    "gcc": ensure => "present";
#    "cpp": ensure => "present";
#    "binutils": ensure => "present";
#    "glibc-devel": ensure => "present";
#    "kernel-headers": ensure => "present";
#    "kernel-devel": ensure => "present";
#  }

  case $operatingsystem {
    CentOS: {
      yumrepo { "HP-psp":
        descr    => "HP Software Delivery Repository for Proliant Support Pack",
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => "http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/GPG-KEY-ProLiantSupportPack",
        baseurl  => "http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/CentOS/\$releasever/packages/\$basearch/",
        priority => 10,
        protect  => 0,
       #require  => [ Package["yum-priorities"], Package["yum-protectbase"], ],
      }
    }
    OEL: {
      yumrepo { "HP-psp":
        descr    => "HP Software Delivery Repository for Proliant Support Pack",
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => "http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/GPG-KEY-ProLiantSupportPack",
        baseurl  => "http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/Oracle/\$releasever/packages/\$basearch/",
        priority => 10,
        protect  => 0,
       #require  => [ Package["yum-priorities"], Package["yum-protectbase"], ],
      }
    }
    Redhat: {
      yumrepo { "HP-psp":
        descr    => "HP Software Delivery Repository for Proliant Support Pack",
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => "http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/GPG-KEY-ProLiantSupportPack",
        baseurl  => "http://downloads.linux.hp.com/SDR/downloads/proliantsupportpack/RedHat/\$releasever/packages/\$basearch/",
        priority => 10,
        protect  => 0,
       #require  => [ Package["yum-priorities"], Package["yum-protectbase"], ],
      }
    }
    default: { }
  }

}

