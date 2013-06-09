# == Class: mysql::server::config
#
# This class exists to coordinate all configuration related actions,
# functionality and logical units in a central place.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'mysql::server::config': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Vlad Ghinea <mailto:vg@vladgh.com>
#
class mysql::server::config {

  #### Defaults
  $root_password = $mysql::server::root_password

  File {
    mode  => $mysql::params::mode,
    owner => $mysql::params::owner,
    group => $mysql::params::group,
  }

  #### Configuration
  file {'my.cnf':
    path   => $mysql::params::config,
    source => [ suffix($mysql::params::source, '/my.cnf'), $mysql::params::config ],
    notify => Class['mysql::server::service'],
  }

  file{'debian.cnf':
    path   => $mysql::params::debian,
    mode   => $mysql::params::protected_mode,
    source => [ suffix($mysql::params::source, '/debian.cnf'), $mysql::params::debian ],
    notify => Class['mysql::server::service'],
  }

  case $::operatingsystem {
    'Debian', 'Ubuntu': {
      if $root_password {
        exec {'Set MySQL Password':
          unless  => "/usr/bin/mysqladmin -uroot -p\"${root_password}\" status",
          command => "/usr/bin/mysql --defaults-file=${$mysql::params::debian} -e \"use mysql; update user set password=PASSWORD(\\\"${root_password}\\\") where User=\\\"root\\\"; flush privileges;\"",
          require => File['debian.cnf'],
        }
      }
    }
    default: {
      fail("\"${module_name}\" is not supported on \"${::operatingsystem}\"")
    }
  }

}
