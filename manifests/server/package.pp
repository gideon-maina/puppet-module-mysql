# == Class: mysql::server::package
#
# This class exists to coordinate all software package management related
# actions, functionality and logical units in a central place.
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
#   class { 'mysql::server::package': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Vlad Ghinea <mailto:vgit@vladgh.com>
#
class mysql::server::package {

  #### Package management

  # set params: in operation
  if $mysql::server::ensure == 'present' {

    $package_ensure = $mysql::server::autoupgrade ? {
      true  => 'latest',
      false => 'present',
    }

  # set params: removal
  } else {
    $package_ensure = 'purged'
  }

  # action
  package { $mysql::params::server_package:
    ensure => $package_ensure,
  }

}
