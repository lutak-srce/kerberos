#
# = Class: kerberos::params
#
# This class provides defaults for kerberos
#
class kerberos::params {
  $ensure           = 'present'
  $version          = undef
  $file_mode        = '0644'
  $file_owner       = 'root'
  $file_group       = 'root'

  $dependency_class = undef
  $my_class         = undef

  # install package depending on major version
  case $::osfamily {
    default: {}
    /(RedHat|redhat|amazon)/: {
      $package           = 'krb5-workstation'
      $package_config    = 'krb5-libs'
      $file_krb5_conf    = '/etc/krb5.conf'
    }
    /(debian|ubuntu)/: {
      $package           = 'krb5-user'
      $package_config    = 'krb5-config'
      $file_krb5_conf    = '/etc/krb5.conf'
    }
  }

}
