# == Class: psp::hpsmh
#
# This class handles installation of the HP Proliant Support Pack System
# Management Homepage.
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
# [*admin_group*]
#   List of OS users to put in the SMH admin group, separated by semicolons.
#   Default: empty
#
# [*operator_group*]
#   List of OS users to put in the SMH operator group, separated by semicolons.
#   Default: empty
#
# [*user_group*]
#   List of OS users to put in the SMH user group, separated by semicolons.
#   Default: empty
#
# [*allow_default_os_admin*]
#   Allow the OS root user to login to SMH.
#   Default: true
#
# [*anonymous_access*]
#   Allow an unauthenticated user to log in to SMH.
#   Default: false
#
# [*localaccess_enabled*]
#   Enable unauthenticated access from localhost.
#   Default: false
#
# [*localaccess_type*]
#   The type of authorization when localaccess_enabled=true.
#   administrator|anonymous
#   Default: Anonymous
#
# [*trustmode*]
#   ?
#   TrustByName|TrustByCert|TrustByAll
#   Default: TrustByCert
#
# [*xenamelist*]
#   A list of trusted server hostnames.
#   Default: empty
#
# [*ip_binding*]
#   Bind SMH to a specific IP address on the host?
#   Default: false
#
# [*ip_binding_list*]
#   A list IP addresses and/or IP address/netmask pairs, separated by
#   semicolons.
#   Default: empty
#
# [*ip_restricted_logins*]
#   Restrict logins to SMH via IP address?
#   Default: false
#
# [*ip_restricted_include*]
#   A list of IP addresses, separated by semicolons.
#   Default: empty
#
# [*ip_restricted_exclude*]
#   A list of IP addresses, separated by semicolons.
#   Default: empty
#
# [*port2301*]
#   Whether to enable unencrypted port 2301 access.
#   Default: true
#
# [*iconview*]
#   ?
#   Default: false
#
# [*box_order*]
#   ?
#   Default: status
#
# [*box_item_order*]
#   ?
#   Default: status
#
# [*session_timeout*]
#   ?
#   Default: 15
#
# [*ui_timeout*]
#   ?
#   Default: 20
#
# [*httpd_error_log*]
#   ?
#   Default: false
#
# [*multihomed*]
#   A list of hostnames and IP addresses, separated by semicolons.
#   Default: empty
#
# [*rotate_logs_size*]
#   ?
#   Default: 5
#
# === Actions:
#
# Installs and configures the HP System Management Homepage.
# Installs the HP Array Configuration Utility.
# Installs the HP Insight Diagnostics.
#
# === Requires:
#
# Class['psp']
#
# === Sample Usage:
#
#   class { 'psp::hpsmh': }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class psp::hpsmh (
  $ensure                 = 'present',
  $autoupgrade            = false,
  $service_ensure         = 'running',
  $service_enable         = true,
  $libz_fix               = $psp::params::libz_fix,
  $admin_group            = '',
  $operator_group         = '',
  $user_group             = '',
  $allow_default_os_admin = 'true',
  $anonymous_access       = 'false',
  $localaccess_enabled    = 'false',
  $localaccess_type       = 'Anonymous',
  $trustmode              = 'TrustByCert',
  $xenamelist             = '',
  $ip_binding             = 'false',
  $ip_binding_list        = '',
  $ip_restricted_logins   = 'false',
  $ip_restricted_include  = '',
  $ip_restricted_exclude  = '',
  $port2301               = 'true',
  $iconview               = 'false',
  $box_order              = 'status',
  $box_item_order         = 'status',
  $session_timeout        = 15,
  $ui_timeout             = 20,
  $httpd_error_log        = 'false',
  $multihomed             = '',
  $rotate_logs_size       = 5
) inherits psp::params {

  case $ensure {
    /(present)/: {
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else {
        $package_ensure = 'present'
      }
      $file_ensure = 'present'
      if $service_ensure in [ running, stopped ] {
        $service_ensure_real = $service_ensure
        $service_enable_real = $service_enable
      } else {
        fail('service_ensure parameter must be running or stopped')
      }
    }
    /(absent)/: {
      $package_ensure = 'absent'
      $file_ensure = 'absent'
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
      realize Group['hpsmh']
      realize User['hpsmh']

      package { 'cpqacuxe':
        ensure => $package_ensure,
      }

      package { 'hpdiags':
        ensure  => $package_ensure,
        require => Package['hpsmh'],
      }

      package { 'hp-smh-templates':
        ensure  => $package_ensure,
        require => Package['hpsmh'],
        #require => Package['hp-snmp-agents'],
      }

      # HP PSP 8.62 on CentOS 6 has an error in the install scripts.
      file { '/usr/lib/libz.so.1':
        ensure => $libz_fix,
      }

      package { 'hpsmh':
        ensure  => $package_ensure,
        require => File['/usr/lib/libz.so.1'],
      }

      # TODO: Figure out some dynamic way to use hpsmh-cert-host1
      # This file resource installs the cert from the HP SIM server into SMH so that
      # when clicking through to the host from SIM, the user is not prompted for
      # authentication.  Multiple certs can be specified.
#      file { 'hpsmh-cert-host1':
#        ensure  => $file_ensure,
#        mode    => '0644',
#        owner   => 'root',
#        group   => 'root',
#        path    => '/opt/hp/hpsmh/certs/host1.pem',
#        source  => 'puppet:///modules/psp/host1.pem',
#        require => Package['hpsmh'],
#        notify  => Service['hpsmhd'],
#      }

      # TODO: SMH server certs are in /etc/opt/hp/sslshare/{cert,file}.pem

      file { 'hpsmhconfig':
        ensure  => $file_ensure,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        path    => '/opt/hp/hpsmh/conf/smhpd.xml',
        content => template('psp/smhpd.xml.erb'),
        require => Package['hpsmh'],
        notify  => Service['hpsmhd'],
      }

#     TODO: Exec['smhconfig'] or File['hpsmhconfig']?
#      exec { 'smhconfig':
#        command => '/opt/hp/hpsmh/sbin/smhconfig --trustmode=TrustByCert',
#        notify  => Service['hpsmhd'],
#      }

      service { 'hpsmhd':
        ensure     => $service_ensure_real,
        enable     => $service_enable_real,
        hasrestart => true,
        hasstatus  => true,
        require    => Package['hpsmh'],
      }
    }
    # If we are not on HP hardware, do not do anything.
    default: { }
  }
}
