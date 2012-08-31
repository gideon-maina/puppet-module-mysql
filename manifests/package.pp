# == Class: mysql::package
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
#   class { 'mysql::package': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Vlad Ghinea <mailto:vgit@vladgh.com>
#
class mysql::package {

  #### Package management

  # set params: in operation
  if $mysql::ensure == 'present' {

    $package_ensure = $mysql::autoupgrade ? {
      true  => 'latest',
      false => 'present',
    }

  # set params: removal
  } else {
    $package_ensure = 'purged'
  }

  # action
  package { $mysql::params::client_package:
    ensure => $package_ensure,
  }

}
