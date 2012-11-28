# == Class: mysql::params
#
# This class exists to
# 1. Declutter the default value assignment for class parameters.
# 2. Manage internally used module variables in a central place.
#
# Therefore, many operating system dependent differences (names, paths, ...)
# are addressed in here.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class is not intended to be used directly.
#
#
# === Links
#
# * {Puppet Docs: Using Parameterized Classes}[http://j.mp/nVpyWY]
#
#
# === Authors
#
# * Vlad Ghinea <mailto:vgit@vladgh.com>
#
class mysql::params {

  #### Default values for the parameters of the main module class, init.pp

  # ensure
  $ensure = 'present'

  # autoupgrade
  $autoupgrade = false

  # service status
  $status = 'enabled'

  # mysql root password
  $root_password = hiera('mysql::server::root_password', undef)


  #### Internal module values

  # packages
  case $::operatingsystem {
    'Debian', 'Ubuntu': {
      # client
      $client_package = [ 'mysql-client' ]
      # server
      $server_package = [ 'mysql-server' ]
    }
    default: {
      fail("\"${module_name}\" provides no package default value for \"${::operatingsystem}\"")
    }
  }

  # service parameters
  case $::operatingsystem {
    'Debian', 'Ubuntu': {
      $service_name       = 'mysql'
      $service_hasrestart = true
      $service_hasstatus  = false
      $service_pattern    = 'mysqld'
    }
    default: {
      fail("\"${module_name}\" provides no service parameters for \"${::operatingsystem}\"")
    }
  }

  $config         = '/etc/mysql/my.cnf'
  $debian         = '/etc/mysql/debian.cnf'
  $owner          = 'root'
  $group          = 'root'
  $mode           = '0644'
  $protected_mode = '0600'

}

