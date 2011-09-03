class psp::hphealth {
  package { "hp-OpenIPMI":
    ensure => "present",
    name => $operatingsystem ? {
      /CentOS|centos|Redhat|redhat|OEL|oel/ => $operatingsystemrelease ? {
        /6.*/      => "OpenIPMI",
        /5.[5-9]*/ => "OpenIPMI",
        default    => "hp-OpenIPMI",
      },  
      default                               => "hp-OpenIPMI",
    },
  }
  
  package { "hponcfg":
    ensure => "present",
    name   => "hponcfg",
  }
  
  package { "hp-health":
    ensure => "present",
    name   => "hp-health",
  }
  
  package { "hp-ilo":
    ensure => $operatingsystem ? {
      /CentOS|centos|Redhat|redhat|OEL|oel/ => $operatingsystemrelease ? {
        /6.*/      => "absent",
        /5.[3-9]*/ => "absent",
        default    => "present",
      },
      default                               => "present",
    },
    name   => "hp-ilo",
  }

  package { "hpacucli":
    ensure => "present",
    name   => "hpacucli",
  }
  
  service { "hp-ilo":
    name       => "hp-ilo",
    ensure => $operatingsystem ? {
      /CentOS|centos|Redhat|redhat|OEL|oel/ => $operatingsystemrelease ? {
        /6.*/      => undef,
        /5.[3-9]*/ => undef,
        default    => "running",
      },
      default                               => "running",
    },
    enable => $operatingsystem ? {
      /CentOS|centos|Redhat|redhat|OEL|oel/ => $operatingsystemrelease ? {
        /6.*/      => undef,
        /5.[3-9]*/ => undef,
        default    => "true",
      },
      default                               => "true",
    },
    hasrestart => "true",
    hasstatus  => "true",
    require    => Package["hp-ilo"],
  }

  service { "hp-health":
    name       => "hp-health",
    ensure     => "running",
    enable     => "true",
    hasrestart => "true",
    hasstatus  => "true",
    require    => [ Package["hp-health"], Package["hp-OpenIPMI"], ],
  }

#  service { "hp-asrd":
#    name       => "hp-asrd",
#    ensure     => "running",
#    enable     => "true",
#    hasrestart => "true",
#    hasstatus  => "true",
#    require    => Package["hp-health"],
#  }

}

