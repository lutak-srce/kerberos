#
# = Class: apcupsd
#
# This class manages APC UPS daemon
#
#
# == Parameters
#
# [*ensure*]
#   Type: string, default: 'present'
#   Manages package installation and class resources. Possible values:
#   * 'present' - Install package, ensure files are present (default)
#   * 'absent'  - Stop service and remove package and managed files
#
# [*package*]
#   Type: string, default on $::osfamily basis
#   Manages the name of the package.
#
# [*version*]
#   Type: string, default: undef
#   If this value is set, the defined version of package is installed.
#   Possible values are:
#   * 'x.y.z' - Specific version
#   * latest  - Latest available
#
# [*file_mode*]
# [*file_owner*]
# [*file_group*]
#   Type: string, default: '0600'
#   Type: string, default: 'root'
#   Type: string, default 'root'
#   File permissions and ownership information assigned to config files.
#
# [*file_krb5_conf*]
#   Type: string, default on $::osfamily basis
#   Path to apcuspd.conf.
#
# [*dependency_class*]
#   Type: string, default: undef
#   Name of a custom class to autoload to manage module's dependencies
#
# [*my_class*]
#   Type: string, default: undef
#   Name of a custom class to autoload to manage module's customizations
#
# [*noops*]
#   Type: boolean, default: undef
#   Set noop metaparameter to true for all the resources managed by the module.
#   If true no real change is done is done by the module on the system.
#
# [*default_realm*]
#   Type: string, default: EXAMPLE.COM
#   Default realm to use, this is also known as your 'local realm'.
#
class kerberos (
  $ensure            = $::kerberos::params::ensure,
  $package           = $::kerberos::params::package,
  $package_config    = $::kerberos::params::package_config,
  $version           = $::kerberos::params::version,
  $file_mode         = $::kerberos::params::file_mode,
  $file_owner        = $::kerberos::params::file_owner,
  $file_group        = $::kerberos::params::file_group,
  $file_krb5_conf    = $::kerberos::params::file_krb5_conf,
  $dependency_class  = $::kerberos::params::dependency_class,
  $my_class          = $::kerberos::params::my_class,
  $noops             = undef,
  $default_realm     = 'EXAMPLE.COM',
) inherits kerberos::params {

  ### Input parameters validation
  validate_re($ensure, ['present','absent'], 'Valid values are: present, absent')
  validate_string($package)
  validate_string($version)

  ### Internal variables (that map class parameters)
  if $ensure == 'present' {
    $package_ensure = $version ? {
      ''      => 'present',
      default => $version,
    }
    $file_ensure = present
  } else {
    $package_ensure = 'absent'
    $file_ensure    = absent
  }

  ### Extra classes
  if $dependency_class { include $dependency_class }
  if $my_class         { include $my_class         }

  package { 'krb5-workstation':
    ensure => $package_ensure,
    name   => $package,
    noop   => $noops,
  }

  package { 'krb5-config':
    ensure => $package_ensure,
    name   => $package_config,
    noop   => $noops,
  }

  # set defaults for file resource in this scope.
  File {
    ensure  => $file_ensure,
    owner   => $file_owner,
    group   => $file_group,
    mode    => $file_mode,
    noop    => $noops,
  }

  concat { $file_krb5_conf:
    require => Package['krb5-config'],
  }

  concat::fragment { "${file_krb5_conf}_header":
    target  => $file_krb5_conf,
    content => template('kerberos/krb5.conf_header.erb'),
    order   => '100',
  }

  concat::fragment { "${file_krb5_conf}_domainrealm":
    target  => $file_krb5_conf,
    source  => 'puppet:///modules/kerberos/krb5.conf_domainrealm',
    order   => '300',
  }



}
# vi:syntax=puppet:filetype=puppet:ts=4:et:nowrap:
