# == Class: mysql::server
#
# This class is able to install or remove the MySQL Server on a node.
# There are 2 configuration files that can be served from the custom mount
# points defined in site.pp (see the common module):
# [*my.cnf*]
# [*debian.cnf*]
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
#
# [*status*]
#   String to define the status of the service. Possible values:
#   * <tt>enabled</tt>: Service is running and will be started at boot time.
#   * <tt>disabled</tt>: Service is stopped and will not be started at boot
#     time.
#   * <tt>running</tt>: Service is running but will not be started at boot time.
#     You can use this to start a service on the first Puppet run instead of
#     the system startup.
#   * <tt>unmanaged</tt>: Service will not be started at boot time and Puppet
#     does not care whether the service is running or not. For example, this may
#     be useful if a cluster management software is used to decide when to start
#     the service plus assuring it is running on the desired node.
#   Defaults to <tt>enabled</tt>. The singular form ("service") is used for the
#   sake of convenience. Of course, the defined status affects all services if
#   more than one is managed (see <tt>service.pp</tt> to check if this is the
#   case).
#
# [*root_password*]
#   String. The password for the MySQL Server.
#   On Ubuntu a special user is created inside debian.cnf for administrative
#   purposes. This script uses that user to create or modify the root password.
#
# [*files_source*]
#   String. Location of files.
#   Defaults to Puppet's built-in file server.
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
class mysql::server(
  $ensure        = $mysql::params::ensure,
  $autoupgrade   = $mysql::params::autoupgrade,
  $status        = $mysql::params::status,
  $root_password = $mysql::params::root_password,
  $files_source  = $mysql::params::files_source
) inherits mysql::params {

  #### Validate parameters

  # ensure
  if ! ($ensure in [ 'present', 'absent' ]) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
  }

  # autoupgrade
  validate_bool($autoupgrade)

  # service status
  if ! ($status in [ 'enabled', 'disabled', 'running', 'unmanaged' ]) {
    fail("\"${status}\" is not a valid status parameter value")
  }

  # mysql root password
  validate_string($root_password)


  #### Manage actions

  # package(s)
  class { 'mysql::server::package': }

  # configuration
  class { 'mysql::server::config': }

  # service(s)
  class { 'mysql::server::service': }



  #### Manage relationships

  if $ensure == 'present' {
    # we need the software before configuring it
    Class['mysql::server::package'] -> Class['mysql::server::config']

    # we need the software and a working configuration before running a service
    Class['mysql::server::package'] -> Class['mysql::server::service']
    Class['mysql::server::config']  -> Class['mysql::server::service']

  } else {

    # make sure all services are getting stopped before software removal
    Class['mysql::server::service'] -> Class['mysql::server::package']
  }

}
