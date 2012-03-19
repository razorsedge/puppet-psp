class psp::params {
  $gid          = '490'
  $uid          = '490'
  $yum_priority = '50'
  $yum_protect  = '0'

  case $::operatingsystem {
    "CentOS": {
      $yum_operatingsystem = 'CentOS'
    }
    "OracleLinux", "OEL": {
      $yum_operatingsystem = 'Oracle'
    }
    "RedHat": {
      $yum_operatingsystem = 'RedHat'
    }
    default: {
      fail("${::hostname}: This module does not support operatingsystem ${::operatingsystem}")
    }
  }
}
