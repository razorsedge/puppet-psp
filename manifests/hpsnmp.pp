class psp::hpsnmp {
  include psp::snmpd

  package { "hp-snmp-agents":
    ensure => "present",
    name   => $operatingsystem ? {
      default => "hp-snmp-agents",
    },
#    require => Class["snmp"],
    require => [ User["hpsmh"], Yumrepo["HP-psp"], ],
  }
  
  exec { "copy_snmpd.conf-HP":
    command     => "/bin/cp -p /etc/snmp/snmpd.conf-HP /etc/snmp/snmpd.conf",
   #onlyif      => "test -f /etc/snmp/snmpd.conf-HP",
    require     => File["snmpd.conf-HP"],
    notify      => Exec["hpsnmpconfig"],
    refreshonly => "true",
  }

  exec { "hpsnmpconfig":
    command     => "/sbin/hpsnmpconfig",
    environment => [
      "CMASILENT=yes",
      "CMALOCALHOSTRWCOMMSTR=8t0BAcw4Fjop9IrS4",
     #"CMASYSCONTACT=",
     #"CMASYSLOCATION=",
     #"CMAMGMTSTATIONROCOMMSTR=",
     #"CMAMGMTSTATIONROIPORDNS=",
     #"CMATRAPDESTINATIONCOMMSTR=",
     #"CMATRAPDESTINATIONIPORDNS="
    ],
#    subscribe => File["snmpd.conf"],
#    creates => "/etc/hp-snmp-agents.conf",
    refreshonly => "true",
    require     => Package["hp-snmp-agents"],
    before      => Service["hp-snmp-agents"],
    notify      => Service["snmpd"],
  }

  file { "cma.conf":
    mode    => "755",
    owner   => "root",
    group   => "root",
    require => Package["hp-snmp-agents"],
    ensure  => "present",
    path    => $operatingsystem ? {
      default => "/opt/hp/hp-snmp-agents/cma.conf",
    },
    source  => [
      "puppet:///modules/psp/cma.conf-${fqdn}",
      "puppet:///modules/psp/cma.conf",
    ],
    notify  => Service["hp-snmp-agents"],
  }

  service { "hp-snmp-agents":
    name       => $operatingsystem ? {
      default => "hp-snmp-agents",
    },
    ensure     => "running",
    enable     => "true",
    hasrestart => "true",
    hasstatus  => "true",
    require    => Package["hp-snmp-agents"],
  }

}

class psp::snmpd inherits snmpd::server {
  File["snmpd.conf"] {
    mode   => "660",
    owner  => "root",
    group  => "hpsmh",
    source => undef,
    content => undef,
  }

  file { "snmpd.conf-HP":
    mode    => "660",
    owner   => "root",
    group   => "hpsmh",
    require => Package["snmpd"],
    ensure  => "present",
    path    => $operatingsystem ? {
      default => "/etc/snmp/snmpd.conf-HP",
    },
    source  => [
      "puppet:///modules/snmpd/snmpd.conf-${fqdn}",
      "puppet:///modules/snmpd/snmpd.conf",
    ],
   #notify  => Service["snmpd"],
    notify  => Exec["copy_snmpd.conf-HP"],
  }

}

