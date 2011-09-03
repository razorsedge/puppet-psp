class psp::hpvca {
  package { "hpvca":
    ensure => $operatingsystem ? {
      /Redhat|redhat/ => "present",
      default         => "absent",
    },
    name   => "hpvca",
  }
  
#mja: file or exec for configuration?

  service { "hpvca":
    name       => "hpvca",
    ensure     => $operatingsystem ? {
      /Redhat|redhat/ => "running",
      default         => "stopped",
    },
    enable     => $operatingsystem ? {
      /Redhat|redhat/ => "true",
      default         => "false",
    },
    hasrestart => "true",
    hasstatus  => "true",
    require    => Package["hpvca"],
  }

}

