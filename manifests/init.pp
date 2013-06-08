# == Class: mysql
#
# This class is able to install or remove the MySQL Client package on a node.
#
# Read more about the custom mount points and file sources in the main
# {README}[http://j.mp/TAEVWT] file.
#
#
# === Parameters
#
# [*ensure*]
#   String. Controls if the managed resources shall be <tt>present</tt> or
#   <tt>absent</tt>.
#   Defaults to <tt>present</tt>.
#
# [*autoupgrade*]
#   Boolean. If set to <tt>true</tt>, any managed package gets upgraded
#   on each Puppet run when the package provider is able to find a newer
#   version than the present one. The exact behavior is provider dependent.
#   Defaults to <tt>false</tt>.
#
# [*files_source*]
#   String. Location of files.
#   Defaults to Puppet's built-in file server.
#
#
# The default values for the parameters are set in mysql::params. Have
# a look at the corresponding <tt>params.pp</tt> manifest file if you need more
# technical information about them.
#
#
# === Examples
#
# * Installation:
#     class { 'mysql': }
#
# * Removal/decommissioning:
#     class { 'mysql':
#       ensure => 'absent',
#     }
#
# * Install everything but disable service(s) afterwards
#     class { 'mysql':
#       status => 'disabled',
#     }
#
#
# === Authors
#
# * Vlad Ghinea <mailto:vg@vladgh.com>
#
class mysql(
  $ensure      = $mysql::params::ensure,
  $autoupgrade = $mysql::params::autoupgrade,
  $files_source = $mysql::params::files_source
) inherits mysql::params {

  #### Validate parameters

  # ensure
  if ! ($ensure in [ 'present', 'absent' ]) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
  }

  # autoupgrade
  validate_bool($autoupgrade)


  #### Manage actions

  # package(s)
  class { 'mysql::package': }

}
