class psp::hpdiags {
  package { "hpdiags":
    ensure => "present",
    name   => $operatingsystem ? {
      default => "hpdiags",
    },
    require => Package["hpsmh"],
  }
  
}

