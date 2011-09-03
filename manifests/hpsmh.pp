class psp::hpsmh {
  package { "cpqacuxe":
    ensure => "present",
    name   => $operatingsystem ? {
      default => "cpqacuxe",
    },
  }

  package { "hpdiags":
    ensure => "present",
    name   => $operatingsystem ? {
      default => "hpdiags",
    },
    #require => Package["hpsmh"],
  }

  package { "hp-smh-templates":
    ensure  => "present",
    name    => $operatingsystem ? {
      default => "hp-smh-templates",
    },
    #require => Package["hp-snmp-agents"],
  }

  package { "hpsmh":
    ensure => "present",
    name   => $operatingsystem ? {
      default => "hpsmh",
    },
  }

  file { "hpsmh-cert-host1":
    mode    => "644",
    owner   => "root",
    group   => "root",
    require => Package["hpsmh"],
    ensure  => "present",
    path    => $operatingsystem ? {
      default => "/opt/hp/hpsmh/certs/host1.pem",
    },
    source  => "puppet:///modules/psp/host1.pem",
    notify  => Service["hpsmhd"],
  }

  file { "hpsmhconfig":
    mode    => "644",
    owner   => "root",
    group   => "root",
    require => Package["hpsmh"],
    ensure  => "present",
    path    => $operatingsystem ? {
      default => "/opt/hp/hpsmh/config/smhpd.xml",
    },
    source  => [
      "puppet:///modules/psp/smhpd.xml-${fqdn}",
      "puppet:///modules/psp/smhpd.xml",
    ],
    notify  => Service["hpsmhd"],
  }
#  exec { "smhconfig":
#    command => "/opt/hp/hpsmh/sbin/smhconfig --trustmode=TrustByCert",
#  }

  service { "hpsmhd":
    name       => $operatingsystem ? {
      default => "hpsmhd",
    },
    ensure     => "running",
    enable     => "true",
    hasrestart => "true",
    hasstatus  => "true",
    require    => Package["hpsmh"],
  }

}

