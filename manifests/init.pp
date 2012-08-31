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
#   <tt>absent</tt>. If set to <tt>absent</tt>:
#   * The managed software packages are being uninstalled.
#   * Any traces of the packages will be purged as good as possible. This may
#     include existing configuration files. The exact behavior is provider
#     dependent. Q.v.:
#     * Puppet type reference: {package, "purgeable"}[http://j.mp/xbxmNP]
#     * {Puppet's package provider source code}[http://j.mp/wtVCaL]
#   * System modifications (if any) will be reverted as good as possible
#     (e.g. removal of created users, services, changed log settings, ...).
#   * This is thus destructive and should be used with care.
#   Defaults to <tt>present</tt>.
#
# [*autoupgrade*]
#   Boolean. If set to <tt>true</tt>, any managed package gets upgraded
#   on each Puppet run when the package provider is able to find a newer
#   version than the present one. The exact behavior is provider dependent.
#   Q.v.:
#   * Puppet type reference: {package, "upgradeable"}[http://j.mp/xbxmNP]
#   * {Puppet's package provider source code}[http://j.mp/wtVCaL]
#   Defaults to <tt>false</tt>.
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
# * Vlad Ghinea <mailto:vgit@vladgh.com>
#
class mysql(
  $ensure      = $mysql::params::ensure,
  $autoupgrade = $mysql::params::autoupgrade
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
