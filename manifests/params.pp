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
# * Vlad Ghinea <mailto:vg@vladgh.com>
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
  $root_password = undef

  # files source path
  $files_source = 'puppet:///modules/mysql'


  #### Internal module values

  # packages
  case $::operatingsystem {
    'Debian', 'Ubuntu': {
      # client
      $client_package = [ 'mysql-client' ]
      # server
      $server_package     = [ 'mysql-server' ]
      $service_name       = 'mysql'
      $service_hasrestart = true
      $service_hasstatus  = false
      $service_pattern    = 'mysqld'
      $config             = '/etc/mysql/my.cnf'
      $debian             = '/etc/mysql/debian.cnf'
    }
    default: {
      fail("\"${module_name}\" is not supported on \"${::operatingsystem}\"")
    }
  }

  $owner          = 'root'
  $group          = 'root'
  $mode           = '0644'
  $protected_mode = '0600'

}

