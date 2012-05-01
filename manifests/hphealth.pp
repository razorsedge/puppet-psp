# Class: psp::hphealth
#
# This class manages hphealth.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class psp::hphealth {
  package { 'hp-OpenIPMI':
    ensure => 'present',
    name   => $::operatingsystem ? {
      /CentOS|RedHat|OEL|OracleLinux/ => $::operatingsystemrelease ? {
        /6.*/      => 'OpenIPMI',
        /5.[5-9]*/ => 'OpenIPMI',
        default    => 'hp-OpenIPMI',
      },
      default                         => 'hp-OpenIPMI',
    },
  }

  package { 'hponcfg':
    ensure => 'present',
    name   => 'hponcfg',
  }

  package { 'hp-health':
    ensure => 'present',
    name   => 'hp-health',
  }

  package { 'hp-ilo':
    ensure => $::operatingsystem ? {
      /CentOS|RedHat|OEL|OracleLinux/ => $::operatingsystemrelease ? {
        /6.*/      => 'absent',
        /5.[3-9]*/ => 'absent',
        default    => 'present',
      },
      default                         => 'present',
    },
    name   => 'hp-ilo',
  }

  package { 'hpacucli':
    ensure => 'present',
    name   => 'hpacucli',
  }

  service { 'hp-ilo':
    ensure     => $::operatingsystem ? {
      /CentOS|RedHat|OEL|OracleLinux/ => $::operatingsystemrelease ? {
        /6.*/      => undef,
        /5.[3-9]*/ => undef,
        default    => 'running',
      },
      default                         => 'running',
    },
    enable     => $::operatingsystem ? {
      /CentOS|RedHat|OEL|OracleLinux/ => $::operatingsystemrelease ? {
        /6.*/      => undef,
        /5.[3-9]*/ => undef,
        default    => true,
      },
      default                         => true,
    },
    hasrestart => true,
    hasstatus  => true,
    require    => Package['hp-ilo'],
    name       => 'hp-ilo',
  }

  service { 'hp-health':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [ Package['hp-health'], Package['hp-OpenIPMI'], ],
    name       => 'hp-health',
  }

#  service { 'hp-asrd':
#    name       => 'hp-asrd',
#    ensure     => 'running',
#    enable     => true,
#    hasrestart => true,
#    hasstatus  => true,
#    require    => Package['hp-health'],
#  }
}
